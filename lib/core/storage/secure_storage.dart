import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Keys para almacenamiento seguro
class StorageKeys {
  static const String jwtToken = 'jwt_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String wcConsumerKey = 'wc_consumer_key';
  static const String wcConsumerSecret = 'wc_consumer_secret';
  static const String themeMode = 'theme_mode';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String lastSyncDate = 'last_sync_date';
}

/// Servicio de almacenamiento seguro
/// Usa flutter_secure_storage para datos sensibles
class SecureStorage {
  static SecureStorage? _instance;
  late final FlutterSecureStorage _storage;

  SecureStorage._() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
          // Usar cifrado predeterminado (migración automática)
          ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }

  /// Singleton instance
  static SecureStorage get instance {
    _instance ??= SecureStorage._();
    return _instance!;
  }

  // ==================== JWT Token ====================

  /// Guarda el JWT token
  Future<void> saveJwtToken(String token) async {
    await _storage.write(key: StorageKeys.jwtToken, value: token);
  }

  /// Obtiene el JWT token
  Future<String?> getJwtToken() async {
    return await _storage.read(key: StorageKeys.jwtToken);
  }

  /// Elimina el JWT token
  Future<void> deleteJwtToken() async {
    await _storage.delete(key: StorageKeys.jwtToken);
  }

  /// Verifica si hay un token guardado
  Future<bool> hasJwtToken() async {
    final token = await getJwtToken();
    return token != null && token.isNotEmpty;
  }

  // ==================== Refresh Token ====================

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: StorageKeys.refreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: StorageKeys.refreshToken);
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: StorageKeys.refreshToken);
  }

  // ==================== User ID ====================

  Future<void> saveUserId(String id) async {
    await _storage.write(key: StorageKeys.userId, value: id);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: StorageKeys.userId);
  }

  Future<void> deleteUserId() async {
    await _storage.delete(key: StorageKeys.userId);
  }

  // ==================== User Email ====================

  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: StorageKeys.userEmail, value: email);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: StorageKeys.userEmail);
  }

  // ==================== WooCommerce Credentials ====================

  Future<void> saveWcCredentials({
    required String consumerKey,
    required String consumerSecret,
  }) async {
    await Future.wait([
      _storage.write(key: StorageKeys.wcConsumerKey, value: consumerKey),
      _storage.write(key: StorageKeys.wcConsumerSecret, value: consumerSecret),
    ]);
  }

  Future<Map<String, String>?> getWcCredentials() async {
    final key = await _storage.read(key: StorageKeys.wcConsumerKey);
    final secret = await _storage.read(key: StorageKeys.wcConsumerSecret);
    if (key == null || secret == null) return null;
    return {'consumerKey': key, 'consumerSecret': secret};
  }

  // ==================== App Settings ====================

  Future<void> saveThemeMode(String mode) async {
    await _storage.write(key: StorageKeys.themeMode, value: mode);
  }

  Future<String?> getThemeMode() async {
    return await _storage.read(key: StorageKeys.themeMode);
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _storage.write(
      key: StorageKeys.onboardingCompleted,
      value: completed.toString(),
    );
  }

  Future<bool> isOnboardingCompleted() async {
    final value = await _storage.read(key: StorageKeys.onboardingCompleted);
    return value == 'true';
  }

  // ==================== Sync ====================

  Future<void> saveLastSyncDate(DateTime date) async {
    await _storage.write(
      key: StorageKeys.lastSyncDate,
      value: date.toIso8601String(),
    );
  }

  Future<DateTime?> getLastSyncDate() async {
    final value = await _storage.read(key: StorageKeys.lastSyncDate);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  // ==================== Clear All ====================

  /// Limpia todos los datos de autenticación
  Future<void> clearAuthData() async {
    await Future.wait([
      deleteJwtToken(),
      deleteRefreshToken(),
      deleteUserId(),
      _storage.delete(key: StorageKeys.userEmail),
    ]);
  }

  /// Limpia TODO el almacenamiento
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // ==================== Generic Methods ====================

  /// Guarda un valor genérico
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Lee un valor genérico
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Elimina un valor genérico
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Obtiene todas las keys almacenadas
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}

/// Provider para SecureStorage
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage.instance;
});
