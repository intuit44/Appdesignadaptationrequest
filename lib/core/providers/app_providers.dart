import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../storage/secure_storage.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/woocommerce_service.dart';

/// ==================== Core Providers ====================

/// Provider para SecureStorage
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage.instance;
});

/// Provider para ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient.instance;
});

/// ==================== Service Providers ====================

/// Provider para AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Provider para WooCommerceService
final wooCommerceServiceProvider = Provider<WooCommerceService>((ref) {
  return WooCommerceService();
});

// Los providers de repositorios se definen en sus respectivos archivos:
// - auth_repository.dart: authRepositoryProvider
// - course_repository.dart: courseRepositoryProvider
// - shop_repository.dart: shopRepositoryProvider, cartRepositoryProvider
