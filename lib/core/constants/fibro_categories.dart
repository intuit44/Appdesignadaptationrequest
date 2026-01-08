import 'package:flutter/material.dart';

/// Categorías de Productos de la Tienda Fibro Academy
/// Basado en la estructura de https://fibroacademyusa.com/shop/
class FibroProductCategories {
  // IDs de categorías de WooCommerce (ajustar según los IDs reales)
  static const String fibroSkinJellyMask = 'fibroskin-jelly-mask';
  static const String lineaDmCell = 'dm-cell';
  static const String lineaCO2 = 'co2';
  static const String collagen = 'collagen';
  static const String lendan = 'lendan';
  static const String numbing = 'numbing-cream';
  static const String accesorios = 'accesorios';
  static const String equipos = 'equipos';

  /// Lista de categorías de productos con información visual
  static List<ProductCategoryInfo> get categories => [
        ProductCategoryInfo(
          id: fibroSkinJellyMask,
          name: 'Línea FibroSkin',
          subtitle: 'Jelly Masks',
          icon: Icons.face_retouching_natural,
          color: const Color(0xFFFF6B35), // Naranja Fibro
          imageUrl:
              'https://fibroacademyusa.com/wp-content/uploads/2023/09/FIBROSKIN-LOGO-768x220.png.webp',
        ),
        ProductCategoryInfo(
          id: lineaDmCell,
          name: 'Línea DM.Cell',
          subtitle: 'Skincare Profesional',
          icon: Icons.science_outlined,
          color: const Color(0xFF00BFA5), // Teal
          imageUrl:
              'https://fibroacademyusa.com/wp-content/uploads/elementor/thumbs/c13-oz1s0yqmuyzxguan7vs6moalpdu19jypnyo4r8sgnw.png.webp',
        ),
        ProductCategoryInfo(
          id: lineaCO2,
          name: 'Línea CO2',
          subtitle: 'Carboxiterapia',
          icon: Icons.bubble_chart,
          color: const Color(0xFF26A69A),
          imageUrl:
              'https://fibroacademyusa.com/wp-content/uploads/elementor/thumbs/cbbg2-300x199-oz1sqrf6fab83ktol17l25y0m2ooiidijn7uwmjhwc.jpg',
        ),
        ProductCategoryInfo(
          id: collagen,
          name: 'Colágeno',
          subtitle: 'Hilos y Threads',
          icon: Icons.auto_fix_high,
          color: const Color(0xFFFF8A65),
          imageUrl:
              'https://fibroacademyusa.com/wp-content/uploads/elementor/thumbs/MG_3729-1-e1687579168571-q8f1cxh37f5he7oqqteuxsvqx1eyizzarvd0yaq0kc.jpg',
        ),
        ProductCategoryInfo(
          id: lendan,
          name: 'Lendan',
          subtitle: 'Vitamina C',
          icon: Icons.local_florist,
          color: const Color(0xFFFFB74D),
          imageUrl:
              'https://fibroacademyusa.com/wp-content/uploads/2023/06/AB8A5116-1.jpg.webp',
        ),
        ProductCategoryInfo(
          id: numbing,
          name: 'Anestésicos',
          subtitle: 'Cremas Numbing',
          icon: Icons.medical_services_outlined,
          color: const Color(0xFF7E57C2),
          imageUrl:
              'https://fibroacademyusa.com/wp-content/uploads/elementor/thumbs/c8-oz1s1hjennpnx1jc63wq0jjtl39dji1cejpucs0l7g.png',
        ),
        ProductCategoryInfo(
          id: accesorios,
          name: 'Accesorios',
          subtitle: 'Terapias y Masajes',
          icon: Icons.spa_outlined,
          color: const Color(0xFF4DB6AC),
          imageUrl:
              'https://fibroacademyusa.com/wp-content/uploads/2020/08/CHICA04-1.jpg.webp',
        ),
        ProductCategoryInfo(
          id: equipos,
          name: 'Equipos',
          subtitle: 'Dispositivos Profesionales',
          icon: Icons.precision_manufacturing,
          color: const Color(0xFF5C6BC0),
          imageUrl:
              'https://fibroacademyusa.com/wp-content/uploads/2020/09/CHICA04-01.jpg.webp',
        ),
      ];

  /// Obtener categoría por ID
  static ProductCategoryInfo? getById(String id) {
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Categorías de Cursos/Entrenamientos de Fibro Academy
/// Las categorías son para navegación visual, los cursos vienen del CRM
class FibroCourseCategories {
  // Tipos de productos en Agent CRM
  static const String typeService = 'SERVICE'; // Talleres presenciales
  static const String typeDigital = 'DIGITAL'; // Cursos online
  static const String typeMembership = 'MEMBERSHIP'; // Membresías

  /// Lista de categorías de cursos con información visual
  /// Los cursos reales vienen de Agent CRM, estas son solo las categorías UI
  static List<CourseCategoryInfo> get categories => [
        CourseCategoryInfo(
          id: 'all',
          name: 'Todos los Cursos',
          subtitle: 'Catálogo Completo',
          description: 'Explora todos nuestros cursos y certificaciones',
          icon: Icons.school_outlined,
          color: const Color(0xFFFF6B35),
          imageUrl:
              'https://fibroacademyusa.com/wp-content/uploads/elementor/thumbs/c13-oz1s0yqmuyzxguan7vs6moalpdu19jypnyo4r8sgnw.png.webp',
          productType: null, // Todos
        ),
        CourseCategoryInfo(
          id: 'talleres',
          name: 'Talleres',
          subtitle: 'Workshops Presenciales',
          description: 'Aprende técnicas prácticas en sesiones intensivas',
          icon: Icons.people_outline,
          color: const Color(0xFF00BFA5),
          imageUrl:
              'https://fibroacademyusa.com/wp-content/uploads/elementor/thumbs/ESTETICA-CORPORAL-q97rox78v0f2qcbwpa2cwfgd2dy5ayaewx6wykjn18.png.webp',
          productType: typeService,
        ),
        CourseCategoryInfo(
          id: 'cursos-online',
          name: 'Cursos Online',
          subtitle: 'Aprende desde casa',
          description: 'Formación digital a tu ritmo',
          icon: Icons.play_circle_outline,
          color: const Color(0xFF7E57C2),
          imageUrl:
              'https://fibroacademyusa.com/wp-content/uploads/elementor/thumbs/cbbg2-300x199-oz1sqrf6fab83ktol17l25y0m2ooiidijn7uwmjhwc.jpg',
          productType: typeDigital,
        ),
        CourseCategoryInfo(
          id: 'membresías',
          name: 'Membresías',
          subtitle: 'Acceso Premium',
          description: 'Contenido exclusivo y beneficios especiales',
          icon: Icons.card_membership,
          color: const Color(0xFFFF8A65),
          imageUrl:
              'https://fibroacademyusa.com/wp-content/uploads/elementor/thumbs/c9-oz1s1ds1wbkimloss2a7qkhz7jrwopmf213wfo65wc.png.webp',
          productType: typeMembership,
        ),
      ];

  /// Obtener categoría por ID
  static CourseCategoryInfo? getById(String id) {
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Información de una categoría de producto
class ProductCategoryInfo {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? imageUrl;

  const ProductCategoryInfo({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.imageUrl,
  });
}

/// Información de una categoría de curso
/// productType corresponde al tipo en Agent CRM: SERVICE, DIGITAL, MEMBERSHIP
class CourseCategoryInfo {
  final String id;
  final String name;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final String? imageUrl;
  final String? productType; // Tipo en Agent CRM para filtrar

  const CourseCategoryInfo({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    this.imageUrl,
    this.productType,
  });
}

/// Información de contacto de Fibro Academy
/// Datos reales del CRM Agent CRM Pro (GoHighLevel)
class FibroContactInfo {
  // Datos confirmados de GoHighLevel
  static const String locationId = 'ejCxNhrdgxBxqjpDhGT6';
  static const String domain = 'hub.fibrolovers.com';

  // Contacto
  static const String address = '2684 NW 97th Ave, Doral, FL 33172';
  static const String email = 'info@fibrolovers.com';
  static const String emailSupport = 'hello@fibroacademyusa.com';
  static const String phone1 = '(305) 632-4630';
  static const String phone2 = '+1 (786) 707-7234';
  static const String whatsapp = '+17867077234';
  static const String instagram = 'fibroacademyusa';
  static const String facebook = 'fibroacademyusa';
  static const String youtube = 'UCmHBMKOI-UYcry1TNQa4qjQ';
  static const String website = 'https://fibroacademyusa.com';
  static const String shopUrl = 'https://fibroacademyusa.com/shop/';
  static const String hubUrl = 'https://hub.fibrolovers.com';

  // URLs construidas
  static String get whatsappUrl =>
      'https://wa.me/$whatsapp?text=Hola,%20me%20interesa%20información%20sobre%20Fibro%20Academy';
  static String get instagramUrl => 'https://www.instagram.com/$instagram/';
  static String get facebookUrl => 'https://www.facebook.com/$facebook/';
  static String get youtubeUrl =>
      'https://www.youtube.com/channel/$youtube?app=desktop';

  // Horarios de atención
  static const String scheduleWeekdays = 'Lunes a Viernes: 9:00 AM - 6:00 PM';
  static const String scheduleSaturday = 'Sábado: 10:00 AM - 3:00 PM';
  static const String scheduleSunday = 'Domingo: Cerrado';
}

/// Colores de marca Fibro Academy
class FibroColors {
  // Colores principales
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color secondaryTeal = Color(0xFF00BFA5);

  // Variantes de naranja
  static const Color orangeLight = Color(0xFFFFD4C4);
  static const Color orangeMedium = Color(0xFFFF8A65);
  static const Color orangeDark = Color(0xFFE64A19);

  // Variantes de teal
  static const Color tealLight = Color(0xFFE0F2F1);
  static const Color tealMedium = Color(0xFF26A69A);
  static const Color tealDark = Color(0xFF00897B);

  // Neutros
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFE0E0E0);

  // Estados
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
}
