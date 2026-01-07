import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_endpoints.dart';
import '../models/product_model.dart';
import '../models/course_model.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

/// Servicio para interactuar con Cloud Functions
/// Todas las llamadas pasan por el backend de Firebase
class WooCommerceService {
  final Dio _dio;

  WooCommerceService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 60),
              headers: {'Content-Type': 'application/json'},
            ));

  /// Extrae el resultado de la respuesta de Cloud Functions
  Map<String, dynamic> _extractResult(dynamic data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data['result'] ?? data);
    }
    return {};
  }

  // ==================== Productos ====================

  /// Obtiene lista de productos
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int perPage = 20,
    String? category,
    String? search,
    String orderBy = 'date',
    String order = 'desc',
    bool? featured,
    bool? onSale,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.cfGetProducts,
      data: {
        'data': {
          if (category != null) 'category': category,
          if (search != null) 'search': search,
          'limit': perPage,
        },
      },
    );

    final result = _extractResult(response.data);
    if (result['success'] == true && result['products'] != null) {
      return (result['products'] as List)
          .map((json) => ProductModel.fromCloudFunction(json))
          .toList();
    }
    return [];
  }

  /// Obtiene un producto por ID
  Future<ProductModel?> getProductById(int id) async {
    final response = await _dio.post(
      ApiEndpoints.cfGetProductDetail,
      data: {
        'data': {'productId': id},
      },
    );

    final result = _extractResult(response.data);
    if (result['success'] == true && result['product'] != null) {
      return ProductModel.fromCloudFunction(result['product']);
    }
    return null;
  }

  /// Obtiene productos destacados
  Future<List<ProductModel>> getFeaturedProducts({int limit = 10}) async {
    return getProducts(perPage: limit, featured: true);
  }

  /// Obtiene productos en oferta
  Future<List<ProductModel>> getSaleProducts({int limit = 10}) async {
    return getProducts(perPage: limit, onSale: true);
  }

  // ==================== Cursos ====================

  /// Obtiene cursos
  Future<List<CourseModel>> getCourses({
    int page = 1,
    int perPage = 20,
    String? categorySlug,
    String? search,
    String orderBy = 'date',
    String order = 'desc',
    bool? featured,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.cfGetCourses,
      data: {
        'data': {
          if (categorySlug != null) 'category': categorySlug,
          if (search != null) 'search': search,
          'limit': perPage,
        },
      },
    );

    final result = _extractResult(response.data);
    if (result['success'] == true && result['courses'] != null) {
      return (result['courses'] as List)
          .map((json) => CourseModel.fromCloudFunction(json))
          .toList();
    }
    return [];
  }

  /// Obtiene un curso por ID
  Future<CourseModel?> getCourseById(int id) async {
    final response = await _dio.post(
      ApiEndpoints.cfGetCourseDetail,
      data: {
        'data': {'courseId': id.toString()},
      },
    );

    final result = _extractResult(response.data);
    if (result['success'] == true && result['course'] != null) {
      return CourseModel.fromCloudFunction(result['course']);
    }
    return null;
  }

  /// Obtiene cursos destacados
  Future<List<CourseModel>> getFeaturedCourses({int limit = 10}) async {
    return getCourses(perPage: limit, featured: true);
  }

  // ==================== Categorías ====================

  /// Obtiene categorías de productos
  Future<List<ProductCategory>> getCategories({
    int page = 1,
    int perPage = 100,
    int? parent,
    bool hideEmpty = true,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.cfGetCategories,
      data: {
        'data': {
          if (parent != null) 'parent': parent,
        },
      },
    );

    final result = _extractResult(response.data);
    if (result['success'] == true && result['categories'] != null) {
      return (result['categories'] as List)
          .map((json) => ProductCategory.fromCloudFunction(json))
          .toList();
    }
    return [];
  }

  // ==================== Órdenes ====================

  /// Obtiene órdenes de un cliente
  Future<List<OrderModel>> getOrders({
    int? customerId,
    int page = 1,
    int perPage = 20,
    String? status,
  }) async {
    if (customerId == null) return [];

    final response = await _dio.post(
      ApiEndpoints.cfGetOrders,
      data: {
        'data': {
          'customerId': customerId,
          'page': page,
          'limit': perPage,
        },
      },
    );

    final result = _extractResult(response.data);
    if (result['success'] == true && result['orders'] != null) {
      return (result['orders'] as List)
          .map((json) => OrderModel.fromCloudFunction(json))
          .toList();
    }
    return [];
  }

  /// Crea una nueva orden
  Future<OrderModel?> createOrder({
    required int customerId,
    required List<OrderLineItem> lineItems,
    String? paymentMethod,
    String? paymentMethodTitle,
    bool setPaid = false,
    BillingAddress? billing,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.cfCreateOrder,
      data: {
        'data': {
          'customerId': customerId,
          'lineItems': lineItems
              .map((item) => {
                    'productId': item.productId,
                    'quantity': item.quantity,
                  })
              .toList(),
          if (billing != null) 'billing': billing.toJson(),
        },
      },
    );

    final result = _extractResult(response.data);
    if (result['success'] == true && result['order'] != null) {
      return OrderModel.fromCloudFunction(result['order']);
    }
    return null;
  }

  /// Obtiene las órdenes de un cliente
  Future<List<OrderModel>> getCustomerOrders({
    required int customerId,
    int page = 1,
    int perPage = 20,
    String? status,
  }) async {
    return getOrders(
        customerId: customerId, page: page, perPage: perPage, status: status);
  }

  /// Obtiene una orden por ID (usa getOrders y filtra)
  Future<OrderModel?> getOrderById(int id) async {
    // Cloud Functions no tiene endpoint específico, se implementaría si es necesario
    return null;
  }

  /// Actualiza el estado de una orden (no disponible via Cloud Functions aún)
  Future<OrderModel?> updateOrderStatus(int orderId, String status) async {
    return null;
  }

  // ==================== Clientes ====================

  /// Obtiene o crea un cliente
  Future<UserModel?> getOrCreateCustomer({
    required String email,
    String? firstName,
    String? lastName,
    Map<String, String>? billing,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.cfGetOrCreateCustomer,
      data: {
        'data': {
          'email': email,
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (billing != null) 'billing': billing,
        },
      },
    );

    final result = _extractResult(response.data);
    if (result['success'] == true && result['customer'] != null) {
      return UserModel.fromCloudFunction(result['customer']);
    }
    return null;
  }

  /// Obtiene información de un cliente (usa getOrCreateCustomer)
  Future<UserModel?> getCustomer(int id) async {
    return null; // No hay endpoint directo por ID
  }

  /// Crea un nuevo cliente
  Future<UserModel?> createCustomer({
    required String email,
    String? password,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    return getOrCreateCustomer(
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
  }

  /// Actualiza información del cliente (no disponible aún)
  Future<UserModel?> updateCustomer(
    int id, {
    String? firstName,
    String? lastName,
    String? phone,
    BillingAddress? billing,
  }) async {
    return null;
  }

  /// Busca cliente por email
  Future<UserModel?> findCustomerByEmail(String email) async {
    return getOrCreateCustomer(email: email);
  }

  // ==================== Carrito ====================

  /// Obtiene o crea orden pendiente como carrito
  Future<OrderModel?> getOrCreateCart(int customerId) async {
    final pendingOrders = await getCustomerOrders(
      customerId: customerId,
      status: 'pending',
      perPage: 1,
    );

    if (pendingOrders.isNotEmpty) {
      return pendingOrders.first;
    }

    return createOrder(
      customerId: customerId,
      lineItems: [],
    );
  }

  /// Agrega item al carrito (no implementado aún via Cloud Functions)
  Future<OrderModel?> addToCart({
    required int orderId,
    required int productId,
    int quantity = 1,
  }) async {
    return null;
  }
}

/// Provider para WooCommerceService
final wooCommerceServiceProvider = Provider<WooCommerceService>((ref) {
  return WooCommerceService();
});
