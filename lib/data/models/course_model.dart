/// Modelo de Curso basado en WooCommerce Product
/// Los cursos en fibroacademyusa.com son productos de WooCommerce
class CourseModel {
  final int id;
  final String name;
  final String slug;
  final String? permalink;
  final String? description;
  final String? shortDescription;
  final String? sku;
  final String price;
  final String? regularPrice;
  final String? salePrice;
  final bool onSale;
  final String status; // publish, draft, pending
  final bool featured;
  final List<CourseImage> images;
  final List<CourseCategory> categories;
  final DateTime? dateCreated;
  final DateTime? dateModified;

  // Metadatos específicos de cursos
  final String? duration;
  final String? level; // beginner, intermediate, advanced
  final int? lessonsCount;
  final double? rating;
  final int? reviewsCount;
  final String? instructor;
  final List<String>? whatYouLearn;
  final String? videoPreviewUrl;

  CourseModel({
    required this.id,
    required this.name,
    required this.slug,
    this.permalink,
    this.description,
    this.shortDescription,
    this.sku,
    required this.price,
    this.regularPrice,
    this.salePrice,
    this.onSale = false,
    this.status = 'publish',
    this.featured = false,
    this.images = const [],
    this.categories = const [],
    this.dateCreated,
    this.dateModified,
    this.duration,
    this.level,
    this.lessonsCount,
    this.rating,
    this.reviewsCount,
    this.instructor,
    this.whatYouLearn,
    this.videoPreviewUrl,
  });

  /// URL de la imagen principal del curso
  String? get mainImage => images.isNotEmpty ? images.first.src : null;

  /// Precio formateado con símbolo
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

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      permalink: json['permalink'],
      description: json['description'],
      shortDescription: json['short_description'],
      sku: json['sku'],
      price: json['price']?.toString() ?? '0',
      regularPrice: json['regular_price']?.toString(),
      salePrice: json['sale_price']?.toString(),
      onSale: json['on_sale'] ?? false,
      status: json['status'] ?? 'publish',
      featured: json['featured'] ?? false,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => CourseImage.fromJson(e))
              .toList() ??
          [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => CourseCategory.fromJson(e))
              .toList() ??
          [],
      dateCreated: json['date_created'] != null
          ? DateTime.tryParse(json['date_created'])
          : null,
      dateModified: json['date_modified'] != null
          ? DateTime.tryParse(json['date_modified'])
          : null,
      // Metadatos personalizados (pueden venir en meta_data)
      duration: _extractMeta(json['meta_data'], '_course_duration'),
      level: _extractMeta(json['meta_data'], '_course_level'),
      lessonsCount:
          int.tryParse(_extractMeta(json['meta_data'], '_lessons_count') ?? ''),
      rating: double.tryParse(json['average_rating']?.toString() ?? ''),
      reviewsCount: json['rating_count'],
      instructor: _extractMeta(json['meta_data'], '_instructor_name'),
      videoPreviewUrl: _extractMeta(json['meta_data'], '_video_preview'),
    );
  }

  /// Factory para datos de Cloud Functions (formato simplificado)
  factory CourseModel.fromCloudFunction(Map<String, dynamic> json) {
    return CourseModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ??
          json['name']?.toString().toLowerCase().replaceAll(' ', '-') ??
          '',
      price: json['price']?.toString() ?? '0',
      description: json['description'] ?? '',
      shortDescription: json['description'] ?? '',
      duration: json['duration'],
      instructor: json['instructor'],
      rating: double.tryParse(json['rating']?.toString() ?? ''),
      images: json['image'] != null
          ? [CourseImage(id: 0, src: json['image'], name: '', alt: '')]
          : [],
      categories: json['category'] != null
          ? [
              CourseCategory(
                  id: 0,
                  name: json['category'],
                  slug: json['category'].toString().toLowerCase())
            ]
          : [],
      whatYouLearn:
          json['topics'] != null ? List<String>.from(json['topics']) : null,
    );
  }

  static String? _extractMeta(List<dynamic>? metaData, String key) {
    if (metaData == null) return null;
    final meta = metaData.firstWhere(
      (m) => m['key'] == key,
      orElse: () => null,
    );
    return meta?['value']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'permalink': permalink,
      'description': description,
      'short_description': shortDescription,
      'price': price,
      'regular_price': regularPrice,
      'sale_price': salePrice,
      'on_sale': onSale,
      'status': status,
      'featured': featured,
      'images': images.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }
}

class CourseImage {
  final int id;
  final String src;
  final String? name;
  final String? alt;

  CourseImage({
    required this.id,
    required this.src,
    this.name,
    this.alt,
  });

  factory CourseImage.fromJson(Map<String, dynamic> json) {
    return CourseImage(
      id: json['id'] ?? 0,
      src: json['src'] ?? '',
      name: json['name'],
      alt: json['alt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'src': src,
      'name': name,
      'alt': alt,
    };
  }
}

class CourseCategory {
  final int id;
  final String name;
  final String slug;

  CourseCategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory CourseCategory.fromJson(Map<String, dynamic> json) {
    return CourseCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}
