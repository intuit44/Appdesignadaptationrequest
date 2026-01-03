import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/product_model.dart';
import '../models/course_model.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

/// Servicio para interactuar con WooCommerce REST API
/// Maneja productos, cursos, órdenes y clientes
class WooCommerceService {
  final ApiClient _apiClient;

  WooCommerceService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

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
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'orderby': orderBy,
      'order': order,
    };

    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;
    if (featured != null) queryParams['featured'] = featured;
    if (onSale != null) queryParams['on_sale'] = onSale;

    final response = await _apiClient.get(
      ApiEndpoints.products,
      queryParameters: queryParams,
    );

    if (response.data is List) {
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    }
    return [];
  }

  /// Obtiene un producto por ID
  Future<ProductModel?> getProductById(int id) async {
    final response = await _apiClient.get(ApiEndpoints.productById(id));
    if (response.data != null) {
      return ProductModel.fromJson(response.data);
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

  /// Obtiene cursos (productos de categoría específica)
  /// Asume que los cursos están en una categoría "cursos" o similar
  Future<List<CourseModel>> getCourses({
    int page = 1,
    int perPage = 20,
    String? categorySlug,
    String? search,
    String orderBy = 'date',
    String order = 'desc',
    bool? featured,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'orderby': orderBy,
      'order': order,
      // Filtrar por categoría de cursos si no se especifica otra
      if (categorySlug != null) 'category': categorySlug,
    };

    if (search != null) queryParams['search'] = search;
    if (featured != null) queryParams['featured'] = featured;

    final response = await _apiClient.get(
      ApiEndpoints.products,
      queryParameters: queryParams,
    );

    if (response.data is List) {
      return (response.data as List)
          .map((json) => CourseModel.fromJson(json))
          .toList();
    }
    return [];
  }

  /// Obtiene un curso por ID
  Future<CourseModel?> getCourseById(int id) async {
    final response = await _apiClient.get(ApiEndpoints.productById(id));
    if (response.data != null) {
      return CourseModel.fromJson(response.data);
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
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'hide_empty': hideEmpty,
    };

    if (parent != null) queryParams['parent'] = parent;

    final response = await _apiClient.get(
      ApiEndpoints.productCategories,
      queryParameters: queryParams,
    );

    if (response.data is List) {
      return (response.data as List)
          .map((json) => ProductCategory.fromJson(json))
          .toList();
    }
    return [];
  }

  // ==================== Órdenes ====================

  /// Crea una nueva orden
  Future<OrderModel?> createOrder({
    required int customerId,
    required List<OrderLineItem> lineItems,
    String? paymentMethod,
    String? paymentMethodTitle,
    bool setPaid = false,
    BillingAddress? billing,
  }) async {
    final data = <String, dynamic>{
      'customer_id': customerId,
      'line_items': lineItems.map((item) => item.toJson()).toList(),
      'set_paid': setPaid,
    };

    if (paymentMethod != null) data['payment_method'] = paymentMethod;
    if (paymentMethodTitle != null) {
      data['payment_method_title'] = paymentMethodTitle;
    }
    if (billing != null) data['billing'] = billing.toJson();

    final response = await _apiClient.post(
      ApiEndpoints.orders,
      data: data,
    );

    if (response.statusCode == 201 && response.data != null) {
      return OrderModel.fromJson(response.data);
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
    final queryParams = <String, dynamic>{
      'customer': customerId,
      'page': page,
      'per_page': perPage,
    };

    if (status != null) queryParams['status'] = status;

    final response = await _apiClient.get(
      ApiEndpoints.orders,
      queryParameters: queryParams,
    );

    if (response.data is List) {
      return (response.data as List)
          .map((json) => OrderModel.fromJson(json))
          .toList();
    }
    return [];
  }

  /// Obtiene una orden por ID
  Future<OrderModel?> getOrderById(int id) async {
    final response = await _apiClient.get(ApiEndpoints.orderById(id));
    if (response.data != null) {
      return OrderModel.fromJson(response.data);
    }
    return null;
  }

  /// Actualiza el estado de una orden
  Future<OrderModel?> updateOrderStatus(int orderId, String status) async {
    final response = await _apiClient.put(
      ApiEndpoints.orderById(orderId),
      data: {'status': status},
    );

    if (response.data != null) {
      return OrderModel.fromJson(response.data);
    }
    return null;
  }

  // ==================== Clientes ====================

  /// Obtiene información de un cliente
  Future<UserModel?> getCustomer(int id) async {
    final response = await _apiClient.get(ApiEndpoints.customerById(id));
    if (response.data != null) {
      return UserModel.fromJson(response.data);
    }
    return null;
  }

  /// Crea un nuevo cliente
  Future<UserModel?> createCustomer({
    required String email,
    String? password,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    final data = <String, dynamic>{
      'email': email,
    };

    if (password != null) data['password'] = password;
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (phone != null) data['billing'] = {'phone': phone};

    final response = await _apiClient.post(
      ApiEndpoints.customers,
      data: data,
    );

    if (response.statusCode == 201 && response.data != null) {
      return UserModel.fromJson(response.data);
    }
    return null;
  }

  /// Actualiza información del cliente
  Future<UserModel?> updateCustomer(
    int id, {
    String? firstName,
    String? lastName,
    String? phone,
    BillingAddress? billing,
  }) async {
    final data = <String, dynamic>{};

    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (phone != null) data['billing'] = {'phone': phone};
    if (billing != null) data['billing'] = billing.toJson();

    if (data.isEmpty) return null;

    final response = await _apiClient.put(
      ApiEndpoints.customerById(id),
      data: data,
    );

    if (response.data != null) {
      return UserModel.fromJson(response.data);
    }
    return null;
  }

  /// Busca cliente por email
  Future<UserModel?> findCustomerByEmail(String email) async {
    final response = await _apiClient.get(
      ApiEndpoints.customers,
      queryParameters: {'email': email},
    );

    if (response.data is List && (response.data as List).isNotEmpty) {
      return UserModel.fromJson((response.data as List).first);
    }
    return null;
  }

  // ==================== Carrito (usando órdenes pendientes) ====================

  /// Obtiene o crea orden pendiente como carrito
  Future<OrderModel?> getOrCreateCart(int customerId) async {
    // Buscar orden pendiente existente
    final pendingOrders = await getCustomerOrders(
      customerId: customerId,
      status: 'pending',
      perPage: 1,
    );

    if (pendingOrders.isNotEmpty) {
      return pendingOrders.first;
    }

    // Crear nueva orden pendiente como carrito
    return createOrder(
      customerId: customerId,
      lineItems: [],
    );
  }

  /// Agrega item al carrito
  Future<OrderModel?> addToCart({
    required int orderId,
    required int productId,
    int quantity = 1,
  }) async {
    final order = await getOrderById(orderId);
    if (order == null) return null;

    final lineItems = order.lineItems.toList();

    // Verificar si el producto ya está en el carrito
    final existingIndex =
        lineItems.indexWhere((item) => item.productId == productId);

    if (existingIndex >= 0) {
      // Actualizar cantidad - crear nuevo item con cantidad actualizada
      final existing = lineItems[existingIndex];
      lineItems[existingIndex] = OrderLineItem(
        id: existing.id,
        name: existing.name,
        productId: existing.productId,
        quantity: existing.quantity + quantity,
        subtotal: existing.subtotal,
        total: existing.total,
      );
    } else {
      // Agregar nuevo item (se completará con datos del producto al guardar)
      lineItems.add(OrderLineItem(
        id: 0,
        name: '',
        productId: productId,
        quantity: quantity,
        subtotal: '0',
        total: '0',
      ));
    }

    final response = await _apiClient.put(
      ApiEndpoints.orderById(orderId),
      data: {
        'line_items': lineItems.map((item) => item.toJson()).toList(),
      },
    );

    if (response.data != null) {
      return OrderModel.fromJson(response.data);
    }
    return null;
  }
}

/// Provider para WooCommerceService
final wooCommerceServiceProvider = Provider<WooCommerceService>((ref) {
  return WooCommerceService();
});
