/// Modelo de Producto para WooCommerce
/// Usado para productos de la tienda (no cursos)
class ProductModel {
  final int id;
  final String name;
  final String slug;
  final String? permalink;
  final String type; // simple, variable, grouped, external
  final String status; // publish, draft, pending, private
  final bool featured;
  final String? catalogVisibility; // visible, catalog, search, hidden
  final String? description;
  final String? shortDescription;
  final String? sku;
  final String price;
  final String? regularPrice;
  final String? salePrice;
  final bool onSale;
  final bool purchasable;
  final int? totalSales;
  final bool virtual;
  final bool downloadable;
  final String? externalUrl;
  final String? buttonText;
  final String taxStatus; // taxable, shipping, none
  final String? taxClass;
  final bool manageStock;
  final int? stockQuantity;
  final String stockStatus; // instock, outofstock, onbackorder
  final String? backorders; // no, notify, yes
  final bool backordersAllowed;
  final bool backordered;
  final bool soldIndividually;
  final String? weight;
  final ProductDimensions? dimensions;
  final bool shippingRequired;
  final bool shippingTaxable;
  final String? shippingClass;
  final int? shippingClassId;
  final bool reviewsAllowed;
  final String averageRating;
  final int ratingCount;
  final List<int> relatedIds;
  final List<int> upsellIds;
  final List<int> crossSellIds;
  final int? parentId;
  final String purchaseNote;
  final List<ProductCategory> categories;
  final List<ProductTag> tags;
  final List<ProductImage> images;
  final List<ProductAttribute> attributes;
  final List<int> variations;
  final int? menuOrder;
  final DateTime? dateCreated;
  final DateTime? dateModified;

  ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    this.permalink,
    this.type = 'simple',
    this.status = 'publish',
    this.featured = false,
    this.catalogVisibility,
    this.description,
    this.shortDescription,
    this.sku,
    required this.price,
    this.regularPrice,
    this.salePrice,
    this.onSale = false,
    this.purchasable = true,
    this.totalSales,
    this.virtual = false,
    this.downloadable = false,
    this.externalUrl,
    this.buttonText,
    this.taxStatus = 'taxable',
    this.taxClass,
    this.manageStock = false,
    this.stockQuantity,
    this.stockStatus = 'instock',
    this.backorders,
    this.backordersAllowed = false,
    this.backordered = false,
    this.soldIndividually = false,
    this.weight,
    this.dimensions,
    this.shippingRequired = true,
    this.shippingTaxable = true,
    this.shippingClass,
    this.shippingClassId,
    this.reviewsAllowed = true,
    this.averageRating = '0',
    this.ratingCount = 0,
    this.relatedIds = const [],
    this.upsellIds = const [],
    this.crossSellIds = const [],
    this.parentId,
    this.purchaseNote = '',
    this.categories = const [],
    this.tags = const [],
    this.images = const [],
    this.attributes = const [],
    this.variations = const [],
    this.menuOrder,
    this.dateCreated,
    this.dateModified,
  });

  /// URL de la imagen principal
  String? get mainImage => images.isNotEmpty ? images.first.src : null;

  /// Precio formateado
  String get formattedPrice => '\$$price';

  /// Tiene descuento?
  bool get hasDiscount => onSale && salePrice != null && salePrice!.isNotEmpty;

  /// Porcentaje de descuento
  int get discountPercent {
    if (!hasDiscount || regularPrice == null) return 0;
    final regular = double.tryParse(regularPrice!) ?? 0;
    final sale = double.tryParse(salePrice!) ?? 0;
    if (regular == 0) return 0;
    return ((regular - sale) / regular * 100).round();
  }

  /// Está en stock?
  bool get inStock => stockStatus == 'instock';

  /// Rating como double
  double get rating => double.tryParse(averageRating) ?? 0.0;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      permalink: json['permalink'],
      type: json['type'] ?? 'simple',
      status: json['status'] ?? 'publish',
      featured: json['featured'] ?? false,
      catalogVisibility: json['catalog_visibility'],
      description: json['description'],
      shortDescription: json['short_description'],
      sku: json['sku'],
      price: json['price']?.toString() ?? '0',
      regularPrice: json['regular_price']?.toString(),
      salePrice: json['sale_price']?.toString(),
      onSale: json['on_sale'] ?? false,
      purchasable: json['purchasable'] ?? true,
      totalSales: json['total_sales'],
      virtual: json['virtual'] ?? false,
      downloadable: json['downloadable'] ?? false,
      externalUrl: json['external_url'],
      buttonText: json['button_text'],
      taxStatus: json['tax_status'] ?? 'taxable',
      taxClass: json['tax_class'],
      manageStock: json['manage_stock'] ?? false,
      stockQuantity: json['stock_quantity'],
      stockStatus: json['stock_status'] ?? 'instock',
      backorders: json['backorders'],
      backordersAllowed: json['backorders_allowed'] ?? false,
      backordered: json['backordered'] ?? false,
      soldIndividually: json['sold_individually'] ?? false,
      weight: json['weight'],
      dimensions: json['dimensions'] != null
          ? ProductDimensions.fromJson(json['dimensions'])
          : null,
      shippingRequired: json['shipping_required'] ?? true,
      shippingTaxable: json['shipping_taxable'] ?? true,
      shippingClass: json['shipping_class'],
      shippingClassId: json['shipping_class_id'],
      reviewsAllowed: json['reviews_allowed'] ?? true,
      averageRating: json['average_rating']?.toString() ?? '0',
      ratingCount: json['rating_count'] ?? 0,
      relatedIds:
          (json['related_ids'] as List?)?.map((e) => e as int).toList() ?? [],
      upsellIds:
          (json['upsell_ids'] as List?)?.map((e) => e as int).toList() ?? [],
      crossSellIds:
          (json['cross_sell_ids'] as List?)?.map((e) => e as int).toList() ??
              [],
      parentId: json['parent_id'],
      purchaseNote: json['purchase_note'] ?? '',
      categories: (json['categories'] as List?)
              ?.map((e) => ProductCategory.fromJson(e))
              .toList() ??
          [],
      tags: (json['tags'] as List?)
              ?.map((e) => ProductTag.fromJson(e))
              .toList() ??
          [],
      images: (json['images'] as List?)
              ?.map((e) => ProductImage.fromJson(e))
              .toList() ??
          [],
      attributes: (json['attributes'] as List?)
              ?.map((e) => ProductAttribute.fromJson(e))
              .toList() ??
          [],
      variations:
          (json['variations'] as List?)?.map((e) => e as int).toList() ?? [],
      menuOrder: json['menu_order'],
      dateCreated: json['date_created'] != null
          ? DateTime.tryParse(json['date_created'])
          : null,
      dateModified: json['date_modified'] != null
          ? DateTime.tryParse(json['date_modified'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'type': type,
      'status': status,
      'featured': featured,
      'description': description,
      'short_description': shortDescription,
      'sku': sku,
      'regular_price': regularPrice,
      'sale_price': salePrice,
      'categories': categories.map((c) => c.toJson()).toList(),
      'tags': tags.map((t) => t.toJson()).toList(),
      'images': images.map((i) => i.toJson()).toList(),
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? price,
    String? regularPrice,
    String? salePrice,
    bool? onSale,
    bool? featured,
    String? description,
    List<ProductImage>? images,
    List<ProductCategory>? categories,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      regularPrice: regularPrice ?? this.regularPrice,
      salePrice: salePrice ?? this.salePrice,
      onSale: onSale ?? this.onSale,
      featured: featured ?? this.featured,
      description: description ?? this.description,
      images: images ?? this.images,
      categories: categories ?? this.categories,
      permalink: permalink,
      type: type,
      status: status,
      shortDescription: shortDescription,
      sku: sku,
    );
  }
}

/// Dimensiones del producto
class ProductDimensions {
  final String? length;
  final String? width;
  final String? height;

  ProductDimensions({this.length, this.width, this.height});

  factory ProductDimensions.fromJson(Map<String, dynamic> json) {
    return ProductDimensions(
      length: json['length'],
      width: json['width'],
      height: json['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'width': width,
      'height': height,
    };
  }
}

/// Categoría del producto
class ProductCategory {
  final int id;
  final String name;
  final String? slug;

  ProductCategory({required this.id, required this.name, this.slug});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'slug': slug};
  }
}

/// Tag del producto
class ProductTag {
  final int id;
  final String name;
  final String? slug;

  ProductTag({required this.id, required this.name, this.slug});

  factory ProductTag.fromJson(Map<String, dynamic> json) {
    return ProductTag(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'slug': slug};
  }
}

/// Imagen del producto
class ProductImage {
  final int id;
  final String? src;
  final String? name;
  final String? alt;

  ProductImage({required this.id, this.src, this.name, this.alt});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? 0,
      src: json['src'],
      name: json['name'],
      alt: json['alt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'src': src, 'name': name, 'alt': alt};
  }
}

/// Atributo del producto
class ProductAttribute {
  final int id;
  final String name;
  final int position;
  final bool visible;
  final bool variation;
  final List<String> options;

  ProductAttribute({
    required this.id,
    required this.name,
    this.position = 0,
    this.visible = true,
    this.variation = false,
    this.options = const [],
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      position: json['position'] ?? 0,
      visible: json['visible'] ?? true,
      variation: json['variation'] ?? false,
      options:
          (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'visible': visible,
      'variation': variation,
      'options': options,
    };
  }
}
