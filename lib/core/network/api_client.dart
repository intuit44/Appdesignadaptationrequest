import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'api_endpoints.dart';
import '../storage/secure_storage.dart';

/// Cliente API centralizado usando Dio con interceptors para:
/// - Autenticación JWT (Bearer token)
/// - Autenticación WooCommerce (consumer_key/secret)
/// - Manejo de errores
/// - Logging en debug
class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;
  final SecureStorage _storage = SecureStorage.instance;

  // WooCommerce API credentials desde .env
  late final String? _wcConsumerKey;
  late final String? _wcConsumerSecret;

  ApiClient._internal() {
    // Cargar credenciales desde variables de entorno
    _wcConsumerKey = dotenv.env['WC_CONSUMER_KEY'];
    _wcConsumerSecret = dotenv.env['WC_CONSUMER_SECRET'];

    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  /// Configura las credenciales de WooCommerce
  void setWooCommerceCredentials({
    required String consumerKey,
    required String consumerSecret,
  }) {
    _wcConsumerKey = consumerKey;
    _wcConsumerSecret = consumerSecret;
  }

  Future<String?> _getRefreshToken() async {
    return await _storage.read(StorageKeys.refreshToken);
  }

  Future<bool> _refreshJwtToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final response = await _dio.post(
        ApiEndpoints
            .jwtToken, // Assuming jwtToken endpoint can also handle refresh
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final newToken = response.data['token'] ?? response.data['access_token'];
      if (newToken != null && newToken is String) {
        await saveJwtToken(newToken);
        return true;
      }
    } catch (_) {
      // Ignore, handled below
    }
    return false;
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getJwtToken();
        if (token != null && _requiresJwtAuth(options.path)) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        if (_requiresWcAuth(options.path)) {
          _addWooCommerceAuth(options);
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) async {
        // Solo intentar refresh si es 401 y es JWT
        final isJwt = _requiresJwtAuth(error.requestOptions.path);
        if (error.response?.statusCode == 401 && isJwt) {
          final refreshed = await _refreshJwtToken();
          if (refreshed) {
            // Reintentar petición original con nuevo token
            final newToken = await _getJwtToken();
            final opts = error.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newToken';
            try {
              final cloneReq = await _dio.fetch(opts);
              return handler.resolve(cloneReq);
            } catch (e) {
              // Si falla el reintento, limpiar sesión
              await _storage.clearAuthData();
              return handler.next(error);
            }
          } else {
            // Si no se pudo refrescar, limpiar sesión
            await _storage.clearAuthData();
          }
        }
        return handler.next(error);
      },
    ));

    // Interceptor de logging (solo en debug)
    assert(() {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (object) => ('🌐 API: $object'),
      ));
      return true;
    }());
  }

  bool _requiresJwtAuth(String path) {
    // Rutas que requieren JWT
    return path.contains('/wp/v2/users/me') ||
        path.contains('/jwt-auth/v1/token/validate');
  }

  bool _requiresWcAuth(String path) {
    // Rutas de WooCommerce API
    return path.contains('/wc/v3/');
  }

  void _addWooCommerceAuth(RequestOptions options) {
    if (_wcConsumerKey != null && _wcConsumerSecret != null) {
      // Método OAuth 1.0a simplificado para HTTPS
      options.queryParameters['consumer_key'] = _wcConsumerKey;
      options.queryParameters['consumer_secret'] = _wcConsumerSecret;
    }
  }

  // ==================== Token Management ====================

  Future<String?> _getJwtToken() async {
    return await _storage.read(StorageKeys.jwtToken);
  }

  Future<void> saveJwtToken(String token) async {
    await _storage.write(StorageKeys.jwtToken, token);
  }

  Future<void> saveUserId(String oderId) async {
    await _storage.write(StorageKeys.userId, oderId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(StorageKeys.userId);
  }

  Future<void> clearAuthData() async {
    await _storage.deleteJwtToken();
    await _storage.deleteRefreshToken();
    await _storage.deleteUserId();
  }

  Future<bool> isAuthenticated() async {
    final token = await _getJwtToken();
    return token != null && token.isNotEmpty;
  }

  // ==================== HTTP Methods ====================

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

/// Excepciones personalizadas para la API
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioError(DioException error) {
    String message;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Tiempo de conexión agotado';
        break;
      case DioExceptionType.connectionError:
        message = 'Sin conexión a internet';
        break;
      case DioExceptionType.badResponse:
        message = _parseErrorMessage(error.response?.data) ??
            'Error del servidor (${error.response?.statusCode})';
        break;
      case DioExceptionType.cancel:
        message = 'Petición cancelada';
        break;
      default:
        message = 'Error de conexión';
    }

    return ApiException(
      message: message,
      statusCode: error.response?.statusCode,
      data: error.response?.data,
    );
  }

  static String? _parseErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'] ?? data['error_description'];
    }
    return null;
  }

  @override
  String toString() => 'ApiException: $message (code: $statusCode)';
}
