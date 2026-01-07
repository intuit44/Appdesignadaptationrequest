import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

/// Servicio centralizado para llamar a todas las Cloud Functions
/// Reemplaza las llamadas directas a WooCommerce y Agent CRM
class CloudFunctionsService {
  final Dio _dio;
  static CloudFunctionsService? _instance;

  static const String _baseUrl =
      'https://us-central1-eng-gate-453810-h3.cloudfunctions.net';

  CloudFunctionsService._()
      : _dio = Dio(BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
          headers: {'Content-Type': 'application/json'},
        ));

  static CloudFunctionsService get instance {
    _instance ??= CloudFunctionsService._();
    return _instance!;
  }

  // ==================== PRODUCTOS ====================

  /// Obtiene lista de productos
  Future<CloudFunctionsResponse<List<CloudProduct>>> getProducts({
    String? category,
    String? search,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.post(
        '/getProducts',
        data: {
          'data': {
            if (category != null) 'category': category,
            if (search != null) 'search': search,
            'limit': limit,
          },
        },
      );

      final result = _extractResult(response.data);
      if (result['success'] == true && result['products'] != null) {
        final products = (result['products'] as List)
            .map((p) => CloudProduct.fromJson(p))
            .toList();
        return CloudFunctionsResponse.success(products);
      }

      return CloudFunctionsResponse.error('Error obteniendo productos');
    } catch (e) {
      debugPrint('CloudFunctions getProducts error: $e');
      return CloudFunctionsResponse.error(_getErrorMessage(e));
    }
  }

  /// Obtiene detalle de un producto
  Future<CloudFunctionsResponse<CloudProduct>> getProductDetail({
    int? productId,
    String? productSlug,
  }) async {
    try {
      final response = await _dio.post(
        '/getProductDetail',
        data: {
          'data': {
            if (productId != null) 'productId': productId,
            if (productSlug != null) 'productSlug': productSlug,
          },
        },
      );

      final result = _extractResult(response.data);
      if (result['success'] == true && result['product'] != null) {
        return CloudFunctionsResponse.success(
          CloudProduct.fromJson(result['product']),
        );
      }

      return CloudFunctionsResponse.error('Producto no encontrado');
    } catch (e) {
      debugPrint('CloudFunctions getProductDetail error: $e');
      return CloudFunctionsResponse.error(_getErrorMessage(e));
    }
  }

  /// Obtiene categorías de productos
  Future<CloudFunctionsResponse<List<CloudCategory>>> getCategories({
    int? parent,
  }) async {
    try {
      final response = await _dio.post(
        '/getCategories',
        data: {
          'data': {
            if (parent != null) 'parent': parent,
          },
        },
      );

      final result = _extractResult(response.data);
      if (result['success'] == true && result['categories'] != null) {
        final categories = (result['categories'] as List)
            .map((c) => CloudCategory.fromJson(c))
            .toList();
        return CloudFunctionsResponse.success(categories);
      }

      return CloudFunctionsResponse.error('Error obteniendo categorías');
    } catch (e) {
      debugPrint('CloudFunctions getCategories error: $e');
      return CloudFunctionsResponse.error(_getErrorMessage(e));
    }
  }

  /// Verifica disponibilidad de producto
  Future<CloudFunctionsResponse<CloudAvailability>> checkAvailability({
    required int productId,
  }) async {
    try {
      final response = await _dio.post(
        '/checkAvailability',
        data: {
          'data': {'productId': productId},
        },
      );

      final result = _extractResult(response.data);
      if (result['success'] == true && result['availability'] != null) {
        return CloudFunctionsResponse.success(
          CloudAvailability.fromJson(result['availability']),
        );
      }

      return CloudFunctionsResponse.error('Error verificando disponibilidad');
    } catch (e) {
      debugPrint('CloudFunctions checkAvailability error: $e');
      return CloudFunctionsResponse.error(_getErrorMessage(e));
    }
  }

  // ==================== CURSOS ====================

  /// Obtiene lista de cursos
  Future<CloudFunctionsResponse<List<CloudCourse>>> getCourses({
    String? category,
    String? search,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.post(
        '/getCourses',
        data: {
          'data': {
            if (category != null) 'category': category,
            if (search != null) 'search': search,
            'limit': limit,
          },
        },
      );

      final result = _extractResult(response.data);
      if (result['success'] == true && result['courses'] != null) {
        final courses = (result['courses'] as List)
            .map((c) => CloudCourse.fromJson(c))
            .toList();
        return CloudFunctionsResponse.success(courses);
      }

      return CloudFunctionsResponse.error('Error obteniendo cursos');
    } catch (e) {
      debugPrint('CloudFunctions getCourses error: $e');
      return CloudFunctionsResponse.error(_getErrorMessage(e));
    }
  }

  /// Obtiene detalle de un curso
  Future<CloudFunctionsResponse<CloudCourse>> getCourseDetail({
    String? courseId,
    String? courseName,
  }) async {
    try {
      final response = await _dio.post(
        '/getCourseDetail',
        data: {
          'data': {
            if (courseId != null) 'courseId': courseId,
            if (courseName != null) 'courseName': courseName,
          },
        },
      );

      final result = _extractResult(response.data);
      if (result['success'] == true && result['course'] != null) {
        return CloudFunctionsResponse.success(
          CloudCourse.fromJson(result['course']),
        );
      }

      return CloudFunctionsResponse.error('Curso no encontrado');
    } catch (e) {
      debugPrint('CloudFunctions getCourseDetail error: $e');
      return CloudFunctionsResponse.error(_getErrorMessage(e));
    }
  }

  /// Obtiene próximos eventos
  Future<CloudFunctionsResponse<List<CloudEvent>>> getUpcomingEvents({
    int limit = 10,
  }) async {
    try {
      final response = await _dio.post(
        '/getUpcomingEvents',
        data: {
          'data': {'limit': limit},
        },
      );

      final result = _extractResult(response.data);
      if (result['success'] == true && result['events'] != null) {
        final events = (result['events'] as List)
            .map((e) => CloudEvent.fromJson(e))
            .toList();
        return CloudFunctionsResponse.success(events);
      }

      return CloudFunctionsResponse.error('Error obteniendo eventos');
    } catch (e) {
      debugPrint('CloudFunctions getUpcomingEvents error: $e');
      return CloudFunctionsResponse.error(_getErrorMessage(e));
    }
  }

  // ==================== ÓRDENES ====================

  /// Obtiene órdenes de un cliente
  Future<CloudFunctionsResponse<List<CloudOrder>>> getOrders({
    required int customerId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.post(
        '/getOrders',
        data: {
          'data': {
            'customerId': customerId,
            'page': page,
            'limit': limit,
          },
        },
      );

      final result = _extractResult(response.data);
      if (result['success'] == true && result['orders'] != null) {
        final orders = (result['orders'] as List)
            .map((o) => CloudOrder.fromJson(o))
            .toList();
        return CloudFunctionsResponse.success(orders);
      }

      return CloudFunctionsResponse.error('Error obteniendo órdenes');
    } catch (e) {
      debugPrint('CloudFunctions getOrders error: $e');
      return CloudFunctionsResponse.error(_getErrorMessage(e));
    }
  }

  /// Crea una nueva orden
  Future<CloudFunctionsResponse<CloudOrderResult>> createOrder({
    int? customerId,
    required List<CloudLineItem> lineItems,
    Map<String, String>? billing,
    Map<String, String>? shipping,
  }) async {
    try {
      final response = await _dio.post(
        '/createOrder',
        data: {
          'data': {
            if (customerId != null) 'customerId': customerId,
            'lineItems': lineItems.map((i) => i.toJson()).toList(),
            if (billing != null) 'billing': billing,
            if (shipping != null) 'shipping': shipping,
          },
        },
      );

      final result = _extractResult(response.data);
      if (result['success'] == true && result['order'] != null) {
        return CloudFunctionsResponse.success(
          CloudOrderResult.fromJson(result['order']),
        );
      }

      return CloudFunctionsResponse.error('Error creando orden');
    } catch (e) {
      debugPrint('CloudFunctions createOrder error: $e');
      return CloudFunctionsResponse.error(_getErrorMessage(e));
    }
  }

  // ==================== CLIENTES ====================

  /// Obtiene o crea un cliente
  Future<CloudFunctionsResponse<CloudCustomer>> getOrCreateCustomer({
    required String email,
    String? firstName,
    String? lastName,
    Map<String, String>? billing,
  }) async {
    try {
      final response = await _dio.post(
        '/getOrCreateCustomer',
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
        return CloudFunctionsResponse.success(
          CloudCustomer.fromJson(result['customer']),
        );
      }

      return CloudFunctionsResponse.error('Error procesando cliente');
    } catch (e) {
      debugPrint('CloudFunctions getOrCreateCustomer error: $e');
      return CloudFunctionsResponse.error(_getErrorMessage(e));
    }
  }

  // ==================== CONTACTO ====================

  /// Obtiene información de contacto
  Future<CloudFunctionsResponse<CloudContact>> getContactInfo() async {
    try {
      final response = await _dio.post(
        '/getContactInfo',
        data: {'data': {}},
      );

      final result = _extractResult(response.data);
      if (result['success'] == true && result['contact'] != null) {
        return CloudFunctionsResponse.success(
          CloudContact.fromJson(result['contact']),
        );
      }

      return CloudFunctionsResponse.error('Error obteniendo contacto');
    } catch (e) {
      debugPrint('CloudFunctions getContactInfo error: $e');
      return CloudFunctionsResponse.error(_getErrorMessage(e));
    }
  }

  // ==================== HELPERS ====================

  Map<String, dynamic> _extractResult(dynamic data) {
    if (data is Map) {
      return data['result'] ?? data;
    }
    return {};
  }

  String _getErrorMessage(dynamic e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Conexión lenta. Intenta de nuevo.';
        case DioExceptionType.connectionError:
          return 'Sin conexión a internet.';
        default:
          return 'Error de conexión.';
      }
    }
    return 'Error inesperado.';
  }
}

// ==================== MODELOS ====================

/// Respuesta genérica de Cloud Functions
class CloudFunctionsResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  CloudFunctionsResponse._({
    required this.success,
    this.data,
    this.error,
  });

  factory CloudFunctionsResponse.success(T data) {
    return CloudFunctionsResponse._(success: true, data: data);
  }

  factory CloudFunctionsResponse.error(String message) {
    return CloudFunctionsResponse._(success: false, error: message);
  }
}

/// Producto desde Cloud Functions
class CloudProduct {
  final int id;
  final String name;
  final String price;
  final String? regularPrice;
  final String? salePrice;
  final String description;
  final List<String> categories;
  final String? image;
  final String stockStatus;
  final int? stockQuantity;
  final bool onSale;
  final bool featured;
  final String? rating;
  final int? ratingCount;

  CloudProduct({
    required this.id,
    required this.name,
    required this.price,
    this.regularPrice,
    this.salePrice,
    required this.description,
    required this.categories,
    this.image,
    required this.stockStatus,
    this.stockQuantity,
    required this.onSale,
    required this.featured,
    this.rating,
    this.ratingCount,
  });

  factory CloudProduct.fromJson(Map<String, dynamic> json) {
    return CloudProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price']?.toString() ?? '0',
      regularPrice: json['regular_price']?.toString(),
      salePrice: json['sale_price']?.toString(),
      description: json['description'] ?? '',
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : [],
      image: json['image'],
      stockStatus: json['stock_status'] ?? 'outofstock',
      stockQuantity: json['stock_quantity'],
      onSale: json['on_sale'] ?? false,
      featured: json['featured'] ?? false,
      rating: json['rating']?.toString(),
      ratingCount: json['rating_count'],
    );
  }

  bool get isInStock => stockStatus == 'instock';
}

/// Categoría desde Cloud Functions
class CloudCategory {
  final int id;
  final String name;
  final String slug;
  final int count;
  final String? image;

  CloudCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.count,
    this.image,
  });

  factory CloudCategory.fromJson(Map<String, dynamic> json) {
    return CloudCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      count: json['count'] ?? 0,
      image: json['image'],
    );
  }
}

/// Disponibilidad desde Cloud Functions
class CloudAvailability {
  final bool available;
  final int? stockQuantity;
  final String stockStatus;
  final String name;

  CloudAvailability({
    required this.available,
    this.stockQuantity,
    required this.stockStatus,
    required this.name,
  });

  factory CloudAvailability.fromJson(Map<String, dynamic> json) {
    return CloudAvailability(
      available: json['available'] ?? false,
      stockQuantity: json['stock_quantity'],
      stockStatus: json['stock_status'] ?? 'outofstock',
      name: json['name'] ?? '',
    );
  }
}

/// Curso desde Cloud Functions
class CloudCourse {
  final String id;
  final String name;
  final String description;
  final String? price;
  final String? duration;
  final String? image;
  final String? category;
  final List<String>? topics;
  final String? instructor;
  final DateTime? nextDate;

  CloudCourse({
    required this.id,
    required this.name,
    required this.description,
    this.price,
    this.duration,
    this.image,
    this.category,
    this.topics,
    this.instructor,
    this.nextDate,
  });

  factory CloudCourse.fromJson(Map<String, dynamic> json) {
    return CloudCourse(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toString(),
      duration: json['duration'],
      image: json['image'],
      category: json['category'],
      topics: json['topics'] != null ? List<String>.from(json['topics']) : null,
      instructor: json['instructor'],
      nextDate: json['next_date'] != null
          ? DateTime.tryParse(json['next_date'])
          : null,
    );
  }
}

/// Evento desde Cloud Functions
class CloudEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final String? location;
  final String? type;

  CloudEvent({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    this.location,
    this.type,
  });

  factory CloudEvent.fromJson(Map<String, dynamic> json) {
    return CloudEvent(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      location: json['location'],
      type: json['type'],
    );
  }
}

/// Orden desde Cloud Functions
class CloudOrder {
  final int id;
  final String status;
  final String total;
  final String currency;
  final DateTime dateCreated;
  final List<CloudOrderItem> lineItems;

  CloudOrder({
    required this.id,
    required this.status,
    required this.total,
    required this.currency,
    required this.dateCreated,
    required this.lineItems,
  });

  factory CloudOrder.fromJson(Map<String, dynamic> json) {
    return CloudOrder(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      total: json['total']?.toString() ?? '0',
      currency: json['currency'] ?? 'USD',
      dateCreated:
          DateTime.tryParse(json['dateCreated'] ?? '') ?? DateTime.now(),
      lineItems: json['lineItems'] != null
          ? (json['lineItems'] as List)
              .map((i) => CloudOrderItem.fromJson(i))
              .toList()
          : [],
    );
  }
}

/// Item de orden desde Cloud Functions
class CloudOrderItem {
  final String name;
  final int quantity;
  final String total;

  CloudOrderItem({
    required this.name,
    required this.quantity,
    required this.total,
  });

  factory CloudOrderItem.fromJson(Map<String, dynamic> json) {
    return CloudOrderItem(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      total: json['total']?.toString() ?? '0',
    );
  }
}

/// Item para crear orden
class CloudLineItem {
  final int productId;
  final int quantity;
  final int? variationId;

  CloudLineItem({
    required this.productId,
    required this.quantity,
    this.variationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      if (variationId != null) 'variationId': variationId,
    };
  }
}

/// Resultado de crear orden
class CloudOrderResult {
  final int id;
  final String status;
  final String total;

  CloudOrderResult({
    required this.id,
    required this.status,
    required this.total,
  });

  factory CloudOrderResult.fromJson(Map<String, dynamic> json) {
    return CloudOrderResult(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      total: json['total']?.toString() ?? '0',
    );
  }
}

/// Cliente desde Cloud Functions
class CloudCustomer {
  final int id;
  final String email;
  final String firstName;
  final String lastName;

  CloudCustomer({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory CloudCustomer.fromJson(Map<String, dynamic> json) {
    return CloudCustomer(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}

/// Contacto desde Cloud Functions
class CloudContact {
  final String nombre;
  final String direccion;
  final String telefono;
  final String email;
  final String website;
  final String horario;
  final Map<String, String> redesSociales;

  CloudContact({
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.email,
    required this.website,
    required this.horario,
    required this.redesSociales,
  });

  factory CloudContact.fromJson(Map<String, dynamic> json) {
    return CloudContact(
      nombre: json['nombre'] ?? '',
      direccion: json['direccion'] ?? '',
      telefono: json['telefono'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      horario: json['horario'] ?? '',
      redesSociales: json['redes_sociales'] != null
          ? Map<String, String>.from(json['redes_sociales'])
          : {},
    );
  }
}

// ==================== PROVIDERS ====================

/// Provider del servicio de Cloud Functions
final cloudFunctionsServiceProvider = Provider<CloudFunctionsService>((ref) {
  return CloudFunctionsService.instance;
});

/// Provider para obtener productos
final cloudProductsProvider = FutureProvider.family<
    CloudFunctionsResponse<List<CloudProduct>>,
    ({String? category, String? search, int limit})>((ref, params) async {
  final service = ref.watch(cloudFunctionsServiceProvider);
  return service.getProducts(
    category: params.category,
    search: params.search,
    limit: params.limit,
  );
});

/// Provider para obtener cursos
final cloudCoursesProvider = FutureProvider.family<
    CloudFunctionsResponse<List<CloudCourse>>,
    ({String? category, String? search, int limit})>((ref, params) async {
  final service = ref.watch(cloudFunctionsServiceProvider);
  return service.getCourses(
    category: params.category,
    search: params.search,
    limit: params.limit,
  );
});

/// Provider para obtener categorías
final cloudCategoriesProvider =
    FutureProvider<CloudFunctionsResponse<List<CloudCategory>>>((ref) async {
  final service = ref.watch(cloudFunctionsServiceProvider);
  return service.getCategories();
});

/// Provider para obtener detalle de producto
final cloudProductDetailProvider =
    FutureProvider.family<CloudFunctionsResponse<CloudProduct>, int>(
        (ref, productId) async {
  final service = ref.watch(cloudFunctionsServiceProvider);
  return service.getProductDetail(productId: productId);
});

/// Provider para obtener eventos
final cloudEventsProvider =
    FutureProvider<CloudFunctionsResponse<List<CloudEvent>>>((ref) async {
  final service = ref.watch(cloudFunctionsServiceProvider);
  return service.getUpcomingEvents();
});

/// Provider para obtener contacto
final cloudContactProvider =
    FutureProvider<CloudFunctionsResponse<CloudContact>>((ref) async {
  final service = ref.watch(cloudFunctionsServiceProvider);
  return service.getContactInfo();
});
