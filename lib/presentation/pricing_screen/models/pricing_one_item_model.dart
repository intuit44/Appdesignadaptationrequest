import '../../../data/models/agent_crm_models.dart';

/// This class is used in the [pricing_one_item_widget] screen.
/// Ahora soporta datos del CRM de GoHighLevel

// ignore_for_file: must_be_immutable
class PricingOneItemModel {
  PricingOneItemModel({
    this.basicpackOne,
    this.hdvideo,
    this.officialexam,
    this.practice,
    this.duration,
    this.freebook,
    this.practicequizes,
    this.indepth,
    this.personal,
    this.id,
    this.price,
    this.currency,
    this.description,
    this.imageUrl,
    this.recurring,
    this.interval,
  }) {
    basicpackOne = basicpackOne ?? "Basic Pack";
    hdvideo = hdvideo ?? "3 HD video lessons & tutorials";
    officialexam = officialexam ?? "1 Official exam";
    practice = practice ?? "100 Practice questions";
    duration = duration ?? "1 Month subscriptions";
    freebook = freebook ?? "1 Free book";
    practicequizes = practicequizes ?? "Practice quizes & assignments";
    indepth = indepth ?? "In depth explanations";
    personal = personal ?? "Personal instructor Assitance";
    id = id ?? "";
  }

  String? basicpackOne;
  String? hdvideo;
  String? officialexam;
  String? practice;
  String? duration;
  String? freebook;
  String? practicequizes;
  String? indepth;
  String? personal;
  String? id;
  double? price;
  String? currency;
  String? description;
  String? imageUrl;
  bool? recurring;
  String? interval;

  /// Factory para crear desde un producto del CRM (membresía)
  factory PricingOneItemModel.fromCRMProduct(AgentCRMProduct product) {
    final benefits = _extractBenefits(product.description ?? '');

    return PricingOneItemModel(
      id: product.id,
      basicpackOne: product.name,
      price: product.price,
      currency: product.currency ?? 'USD',
      description: product.description,
      imageUrl: product.imageUrl,
      recurring: product.recurring,
      interval: product.interval,
      hdvideo: benefits['videos'] ?? _getDefaultVideos(product.price),
      officialexam: benefits['exams'] ?? _getDefaultExams(product.price),
      practice: benefits['practice'] ?? _getDefaultPractice(product.price),
      duration: _formatDuration(product.interval, product.recurring),
      freebook: benefits['books'] ?? _getDefaultBooks(product.price),
      practicequizes: benefits['quizzes'] ?? 'Quizzes y asignaciones',
      indepth: benefits['explanations'] ?? 'Explicaciones detalladas',
      personal: benefits['assistance'] ?? _getDefaultAssistance(product.price),
    );
  }

  static Map<String, String> _extractBenefits(String description) {
    final benefits = <String, String>{};
    final desc = description.toLowerCase();

    if (desc.contains('video')) {
      final match = RegExp(r'(\d+)\s*video').firstMatch(desc);
      if (match != null) {
        benefits['videos'] = '${match.group(1)} Video lecciones HD';
      }
    }

    if (desc.contains('certificad') || desc.contains('diploma')) {
      benefits['exams'] = 'Certificación oficial incluida';
    }

    if (desc.contains('soporte') ||
        desc.contains('asistencia') ||
        desc.contains('mentor')) {
      benefits['assistance'] = 'Asistencia personalizada de instructor';
    }

    return benefits;
  }

  static String _getDefaultVideos(double? price) {
    if (price == null) return '3 Video lecciones HD';
    if (price > 500) return 'Videos ilimitados HD';
    if (price > 200) return '10+ Video lecciones HD';
    return '3 Video lecciones HD';
  }

  static String _getDefaultExams(double? price) {
    if (price == null) return '1 Examen oficial';
    if (price > 500) return 'Certificación oficial incluida';
    if (price > 200) return '2 Exámenes oficiales';
    return '1 Examen oficial';
  }

  static String _getDefaultPractice(double? price) {
    if (price == null) return '50 Preguntas de práctica';
    if (price > 500) return 'Práctica ilimitada';
    if (price > 200) return '200 Preguntas de práctica';
    return '100 Preguntas de práctica';
  }

  static String _getDefaultBooks(double? price) {
    if (price == null) return '1 Material digital';
    if (price > 500) return 'Biblioteca completa de materiales';
    if (price > 200) return '3 Materiales digitales';
    return '1 Material digital gratis';
  }

  static String _getDefaultAssistance(double? price) {
    if (price == null) return 'Soporte por email';
    if (price > 500) return 'Mentoría 1-a-1 personalizada';
    if (price > 200) return 'Soporte prioritario 24/7';
    return 'Asistencia de instructor por email';
  }

  static String _formatDuration(String? interval, bool? recurring) {
    if (interval == null) return 'Acceso de por vida';

    switch (interval.toLowerCase()) {
      case 'month':
      case 'monthly':
        return recurring == true ? 'Suscripción mensual' : '1 Mes de acceso';
      case 'year':
      case 'yearly':
      case 'annual':
        return recurring == true ? 'Suscripción anual' : '1 Año de acceso';
      case 'week':
      case 'weekly':
        return recurring == true ? 'Suscripción semanal' : '1 Semana de acceso';
      case 'lifetime':
        return 'Acceso de por vida';
      default:
        return interval;
    }
  }
}
