/// Modelo de Orden de WooCommerce
/// Representa una compra/suscripción a un curso
class OrderModel {
  final int id;
  final int? parentId;
  final String orderNumber;
  final String status;
  final String currency;
  final String total;
  final String? totalTax;
  final String? shippingTotal;
  final String? discountTotal;
  final DateTime? dateCreated;
  final DateTime? datePaid;
  final DateTime? dateCompleted;
  final int? customerId;
  final String? customerNote;
  final List<OrderLineItem> lineItems;
  final String paymentMethod;
  final String? paymentMethodTitle;
  final String? transactionId;
  final String? paymentUrl; // URL de pago de WooCommerce/Stripe

  OrderModel({
    required this.id,
    this.parentId,
    required this.orderNumber,
    required this.status,
    this.currency = 'USD',
    required this.total,
    this.totalTax,
    this.shippingTotal,
    this.discountTotal,
    this.dateCreated,
    this.datePaid,
    this.dateCompleted,
    this.customerId,
    this.customerNote,
    this.lineItems = const [],
    this.paymentMethod = '',
    this.paymentMethodTitle,
    this.transactionId,
    this.paymentUrl,
  });

  /// La orden está completada y pagada
  bool get isCompleted => status == 'completed';

  /// La orden está pendiente de pago
  bool get isPending => status == 'pending' || status == 'on-hold';

  /// La orden fue cancelada/reembolsada
  bool get isCancelled => status == 'cancelled' || status == 'refunded';

  /// Obtener los IDs de cursos comprados
  List<int> get purchasedCourseIds =>
      lineItems.map((item) => item.productId).toList();

  /// Total formateado
  String get formattedTotal => '\$$total $currency';

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      parentId: json['parent_id'],
      orderNumber: json['number']?.toString() ?? json['id'].toString(),
      status: json['status'] ?? 'pending',
      currency: json['currency'] ?? 'USD',
      total: json['total']?.toString() ?? '0',
      totalTax: json['total_tax']?.toString(),
      shippingTotal: json['shipping_total']?.toString(),
      discountTotal: json['discount_total']?.toString(),
      dateCreated: json['date_created'] != null
          ? DateTime.tryParse(json['date_created'])
          : null,
      datePaid: json['date_paid'] != null
          ? DateTime.tryParse(json['date_paid'])
          : null,
      dateCompleted: json['date_completed'] != null
          ? DateTime.tryParse(json['date_completed'])
          : null,
      customerId: json['customer_id'],
      customerNote: json['customer_note'],
      lineItems: (json['line_items'] as List<dynamic>?)
              ?.map((e) => OrderLineItem.fromJson(e))
              .toList() ??
          [],
      paymentMethod: json['payment_method'] ?? '',
      paymentMethodTitle: json['payment_method_title'],
      transactionId: json['transaction_id'],
      paymentUrl: json['payment_url'], // URL para completar el pago
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'number': orderNumber,
      'status': status,
      'currency': currency,
      'total': total,
      'customer_id': customerId,
      'line_items': lineItems.map((e) => e.toJson()).toList(),
      'payment_method': paymentMethod,
    };
  }
}

/// Línea de item dentro de una orden
class OrderLineItem {
  final int id;
  final String name;
  final int productId;
  final int? variationId;
  final int quantity;
  final String subtotal;
  final String total;
  final String? sku;
  final String? image;

  OrderLineItem({
    required this.id,
    required this.name,
    required this.productId,
    this.variationId,
    this.quantity = 1,
    required this.subtotal,
    required this.total,
    this.sku,
    this.image,
  });

  factory OrderLineItem.fromJson(Map<String, dynamic> json) {
    return OrderLineItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      productId: json['product_id'] ?? 0,
      variationId: json['variation_id'],
      quantity: json['quantity'] ?? 1,
      subtotal: json['subtotal']?.toString() ?? '0',
      total: json['total']?.toString() ?? '0',
      sku: json['sku'],
      image: json['image']?['src'],
    );
  }

  Map<String, dynamic> toJson() {
    // Para crear órdenes, WooCommerce solo necesita product_id y quantity
    // Los demás campos son opcionales y WooCommerce los calcula
    final json = <String, dynamic>{
      'product_id': productId,
      'quantity': quantity,
    };

    // Solo incluir variation_id si existe
    if (variationId != null && variationId! > 0) {
      json['variation_id'] = variationId;
    }

    return json;
  }
}

/// Estado de orden para filtros
enum OrderStatus {
  pending('pending', 'Pendiente'),
  processing('processing', 'Procesando'),
  onHold('on-hold', 'En espera'),
  completed('completed', 'Completado'),
  cancelled('cancelled', 'Cancelado'),
  refunded('refunded', 'Reembolsado'),
  failed('failed', 'Fallido');

  final String value;
  final String label;

  const OrderStatus(this.value, this.label);

  static OrderStatus fromString(String status) {
    return OrderStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => OrderStatus.pending,
    );
  }
}
