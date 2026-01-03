import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../storage/secure_storage.dart';

/// Estado de autenticación global
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Estado global de autenticación
class GlobalAuthState {
  final AuthStatus status;
  final UserModel? user;
  final firebase_auth.User? firebaseUser;
  final String? errorMessage;
  final bool isGoogleSignIn;

  const GlobalAuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.firebaseUser,
    this.errorMessage,
    this.isGoogleSignIn = false,
  });

  GlobalAuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    firebase_auth.User? firebaseUser,
    String? errorMessage,
    bool? isGoogleSignIn,
  }) {
    return GlobalAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      firebaseUser: firebaseUser ?? this.firebaseUser,
      errorMessage: errorMessage,
      isGoogleSignIn: isGoogleSignIn ?? this.isGoogleSignIn,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  String get displayName =>
      user?.fullName ?? firebaseUser?.displayName ?? 'Usuario';
  String? get email => user?.email ?? firebaseUser?.email;
  String? get photoUrl => user?.avatarUrl ?? firebaseUser?.photoURL;
}

/// Notifier para el estado de autenticación global
class AuthStateNotifier extends StateNotifier<GlobalAuthState> {
  final AuthService _authService;
  final SecureStorage _storage;

  AuthStateNotifier({
    AuthService? authService,
    SecureStorage? storage,
  })  : _authService = authService ?? AuthService(),
        _storage = storage ?? SecureStorage.instance,
        super(const GlobalAuthState()) {
    _init();
  }

  /// Inicializa el estado verificando si hay sesión activa
  Future<void> _init() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // Verificar si hay token JWT guardado
      final hasToken = await _storage.hasJwtToken();
      final firebaseUser = _authService.currentFirebaseUser;

      if (hasToken || firebaseUser != null) {
        // Hay sesión activa
        final userId = await _storage.getUserId();

        state = state.copyWith(
          status: AuthStatus.authenticated,
          firebaseUser: firebaseUser,
          isGoogleSignIn: firebaseUser != null,
        );

        // Intentar cargar datos de usuario de WooCommerce
        if (userId != null) {
          try {
            final userProfile =
                await _authService.getUserProfile(int.parse(userId));
            if (userProfile != null) {
              state = state.copyWith(user: userProfile);
            }
            // Si falla, continuamos sin perfil completo (no cerramos sesión)
          } catch (e) {
            // Error al cargar perfil - continuar sin datos completos
            // La sesión sigue activa, solo faltan datos de perfil
          }
        }
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Error al verificar sesión',
      );
    }
  }

  /// Login con Google
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final result = await _authService.signInWithGoogle();

      if (result.isSuccess) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          firebaseUser: result.firebaseUser,
          user: result.wcUser,
          isGoogleSignIn: true,
        );
        return true;
      } else if (result.isCancelled) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return false;
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage:
              result.errorMessage ?? 'Error al iniciar sesión con Google',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Error inesperado: $e',
      );
      return false;
    }
  }

  /// Login con email y password
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final result = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      if (result.isSuccess) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          firebaseUser: result.firebaseUser,
          user: result.wcUser,
          isGoogleSignIn: false,
        );
        return true;
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: result.errorMessage ?? 'Credenciales inválidas',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Error de conexión: $e',
      );
      return false;
    }
  }

  /// Registro de nuevo usuario
  Future<bool> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final result = await _authService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      if (result.isSuccess) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          firebaseUser: result.firebaseUser,
          user: result.wcUser,
          isGoogleSignIn: false,
        );
        return true;
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: result.errorMessage ?? 'Error al registrar',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Error de conexión: $e',
      );
      return false;
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      await _authService.signOut();
      state = const GlobalAuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Error al cerrar sesión',
      );
    }
  }

  /// Limpiar mensaje de error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Actualizar datos de usuario
  void updateUser(UserModel user) {
    state = state.copyWith(user: user);
  }
}

/// Provider global de autenticación
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, GlobalAuthState>((ref) {
  return AuthStateNotifier();
});

/// Provider conveniente para verificar si está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

/// Provider para obtener el usuario actual
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).user;
});

/// Provider para verificar si está cargando
final isAuthLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isLoading;
});
