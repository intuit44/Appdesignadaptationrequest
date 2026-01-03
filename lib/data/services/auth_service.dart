import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/user_model.dart';

/// Servicio de autenticación que maneja:
/// - Google Sign-In (v7.x API)
/// - Firebase Auth
/// - JWT Token con WordPress/WooCommerce
class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final ApiClient _apiClient;
  bool _googleSignInInitialized = false;

  AuthService({
    firebase_auth.FirebaseAuth? firebaseAuth,
    ApiClient? apiClient,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _apiClient = apiClient ?? ApiClient.instance;

  /// Inicializa Google Sign-In (API 7.x requiere initialize())
  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await GoogleSignIn.instance.initialize();
    _googleSignInInitialized = true;
  }

  /// Usuario actual de Firebase
  firebase_auth.User? get currentFirebaseUser => _firebaseAuth.currentUser;

  /// Stream de cambios en el estado de autenticación
  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  /// Está autenticado?
  bool get isSignedIn => currentFirebaseUser != null;

  // ==================== Google Sign-In ====================

  /// Inicia sesión con Google y sincroniza con WooCommerce
  /// API 7.x: usa GoogleSignIn.instance.authenticate()
  Future<AuthResult> signInWithGoogle() async {
    try {
      // 1. Asegurar inicialización de Google Sign-In
      await _ensureGoogleSignInInitialized();

      // 2. Autenticar con Google (API 7.x)
      final GoogleSignInAccount googleUser;
      try {
        googleUser = await GoogleSignIn.instance.authenticate(
          scopeHint: ['email', 'profile'],
        );
      } on GoogleSignInException catch (e) {
        if (e.code == GoogleSignInExceptionCode.canceled) {
          return AuthResult.cancelled();
        }
        rethrow;
      }

      // 3. Obtener idToken para Firebase Auth
      final idToken = googleUser.authentication.idToken;

      // 4. Crear credencial para Firebase
      // Nota: En API 7.x, GoogleSignInAuthentication solo tiene idToken
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: idToken,
      );

      // 5. Sign in con Firebase
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // 7. Sincronizar con WooCommerce (crear/obtener customer)
      final wcUser = await _syncWithWooCommerce(
        email: googleUser.email,
        displayName: googleUser.displayName,
        photoUrl: googleUser.photoUrl,
      );

      return AuthResult.success(
        firebaseUser: userCredential.user,
        wcUser: wcUser,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      return AuthResult.error(_mapFirebaseError(e.code));
    } on GoogleSignInException catch (e) {
      return AuthResult.error(
          'Error de Google Sign-In: ${e.description ?? e.code.name}');
    } catch (e) {
      return AuthResult.error('Error al iniciar sesión: $e');
    }
  }

  // ==================== Email/Password Sign-In ====================

  /// Inicia sesión con email y contraseña
  /// Usa JWT Auth de WordPress
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Obtener JWT token de WordPress
      final response = await _apiClient.post(
        ApiEndpoints.jwtToken,
        data: {
          'username': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final token = response.data['token'];
        // userEmail y displayName disponibles si se necesitan:
        // response.data['user_email'], response.data['user_display_name']

        // Guardar token
        await _apiClient.saveJwtToken(token);

        // 2. También autenticar con Firebase (opcional)
        try {
          await _firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } catch (_) {
          // Si Firebase falla, continuar solo con JWT
        }

        // 3. Obtener datos completos del usuario
        final wcUser = await _getCurrentWcUser();

        return AuthResult.success(
          firebaseUser: _firebaseAuth.currentUser,
          wcUser: wcUser,
        );
      }

      return AuthResult.error('Credenciales inválidas');
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Error de conexión';
      return AuthResult.error(message);
    } catch (e) {
      return AuthResult.error('Error al iniciar sesión: $e');
    }
  }

  // ==================== Registration ====================

  /// Registra un nuevo usuario
  Future<AuthResult> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      // 1. Crear customer en WooCommerce
      final response = await _apiClient.post(
        ApiEndpoints.customers,
        data: {
          'email': email,
          'password': password,
          'first_name': firstName ?? '',
          'last_name': lastName ?? '',
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        // 2. Iniciar sesión con las credenciales
        return signInWithEmail(email: email, password: password);
      }

      return AuthResult.error('Error al crear cuenta');
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Error de conexión';
      return AuthResult.error(message);
    } catch (e) {
      return AuthResult.error('Error al registrar: $e');
    }
  }

  // ==================== Sign Out ====================

  /// Cierra sesión en todos los proveedores
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      GoogleSignIn.instance.signOut(),
      _apiClient.clearAuthData(),
    ]);
  }

  // ==================== Public Methods ====================

  /// Obtiene el perfil de usuario desde WooCommerce por ID
  /// Útil para restaurar sesión al iniciar la app
  Future<UserModel?> getUserProfile(int userId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.customerById(userId),
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      // Log error pero no lanzar excepción
      // Permite que la app continúe sin perfil completo
      return null;
    }
  }

  // ==================== Private Methods ====================

  /// Sincroniza usuario de Google con WooCommerce
  Future<UserModel?> _syncWithWooCommerce({
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      // Buscar si el customer ya existe
      final searchResponse = await _apiClient.get(
        ApiEndpoints.customers,
        queryParameters: {'email': email},
      );

      if (searchResponse.data is List &&
          (searchResponse.data as List).isNotEmpty) {
        // Customer existe, retornar datos
        final customerData = (searchResponse.data as List).first;
        final userId = customerData['id'].toString();
        await _apiClient.saveUserId(userId);
        return UserModel.fromJson(customerData);
      }

      // Customer no existe, crear nuevo
      final nameParts = (displayName ?? '').split(' ');
      final createResponse = await _apiClient.post(
        ApiEndpoints.customers,
        data: {
          'email': email,
          'first_name': nameParts.isNotEmpty ? nameParts.first : '',
          'last_name':
              nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
        },
      );

      if (createResponse.statusCode == 201 && createResponse.data != null) {
        final userId = createResponse.data['id'].toString();
        await _apiClient.saveUserId(userId);
        return UserModel.fromJson(createResponse.data);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Obtiene el usuario actual de WooCommerce
  Future<UserModel?> _getCurrentWcUser() async {
    try {
      final userId = await _apiClient.getUserId();
      if (userId == null) return null;

      final response = await _apiClient.get(
        ApiEndpoints.customerById(int.parse(userId)),
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No existe una cuenta con este email';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'Este email ya está registrado';
      case 'weak-password':
        return 'La contraseña es muy débil';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos. Intente más tarde';
      case 'network-request-failed':
        return 'Error de conexión';
      default:
        return 'Error de autenticación';
    }
  }
}

/// Resultado de operación de autenticación
class AuthResult {
  final bool isSuccess;
  final bool isCancelled;
  final String? errorMessage;
  final firebase_auth.User? firebaseUser;
  final UserModel? wcUser;

  AuthResult._({
    required this.isSuccess,
    this.isCancelled = false,
    this.errorMessage,
    this.firebaseUser,
    this.wcUser,
  });

  factory AuthResult.success({
    firebase_auth.User? firebaseUser,
    UserModel? wcUser,
  }) {
    return AuthResult._(
      isSuccess: true,
      firebaseUser: firebaseUser,
      wcUser: wcUser,
    );
  }

  factory AuthResult.error(String message) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }

  factory AuthResult.cancelled() {
    return AuthResult._(
      isSuccess: false,
      isCancelled: true,
    );
  }
}

/// Provider para AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Provider para el estado de autenticación
final authStateProvider = StreamProvider<firebase_auth.User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Provider para el usuario actual
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);

  final user = authState.valueOrNull;
  if (user == null) return null;

  // Obtener datos de WooCommerce
  final userId = await ApiClient.instance.getUserId();
  if (userId == null) return null;

  try {
    final response = await ApiClient.instance.get(
      ApiEndpoints.customerById(int.parse(userId)),
    );
    if (response.data != null) {
      return UserModel.fromJson(response.data);
    }
  } catch (_) {}
  return null;
});
