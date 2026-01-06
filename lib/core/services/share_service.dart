import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// Servicio para compartir contenido de la aplicación
class ShareService {
  /// Comparte un curso
  static Future<void> shareCourse({
    required String courseName,
    required String? courseDescription,
    required String? courseUrl,
    required String? price,
    Rect? sharePositionOrigin,
  }) async {
    final buffer = StringBuffer();

    // Título
    buffer.writeln('🎓 $courseName');
    buffer.writeln();

    // Descripción (limitada)
    if (courseDescription != null && courseDescription.isNotEmpty) {
      final shortDescription = courseDescription.length > 150
          ? '${courseDescription.substring(0, 150)}...'
          : courseDescription;
      buffer.writeln(shortDescription);
      buffer.writeln();
    }

    // Precio
    if (price != null && price.isNotEmpty) {
      buffer.writeln('💰 Precio: $price');
      buffer.writeln();
    }

    // URL del curso o tienda
    if (courseUrl != null && courseUrl.isNotEmpty) {
      buffer.writeln('🔗 Ver más: $courseUrl');
    } else {
      buffer.writeln('🔗 Visita: https://fibroacademyusa.com/courses/');
    }

    buffer.writeln();
    buffer.writeln(
        '📱 Descarga la app de Fibro Academy para más cursos y productos.');

    await Share.share(
      buffer.toString(),
      subject: 'Curso: $courseName - Fibro Academy',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Comparte un producto
  static Future<void> shareProduct({
    required String productName,
    required String? productDescription,
    required String? productUrl,
    required String? price,
    required String? salePrice,
    Rect? sharePositionOrigin,
  }) async {
    final buffer = StringBuffer();

    // Título
    buffer.writeln('🛍️ $productName');
    buffer.writeln();

    // Descripción (limitada)
    if (productDescription != null && productDescription.isNotEmpty) {
      // Limpiar HTML si existe
      final cleanDescription = _stripHtml(productDescription);
      final shortDescription = cleanDescription.length > 150
          ? '${cleanDescription.substring(0, 150)}...'
          : cleanDescription;
      buffer.writeln(shortDescription);
      buffer.writeln();
    }

    // Precio (mostrar oferta si existe)
    if (salePrice != null && salePrice.isNotEmpty) {
      buffer.writeln('💰 Oferta: $salePrice (antes $price)');
    } else if (price != null && price.isNotEmpty) {
      buffer.writeln('💰 Precio: $price');
    }
    buffer.writeln();

    // URL del producto o tienda
    if (productUrl != null && productUrl.isNotEmpty) {
      buffer.writeln('🔗 Ver producto: $productUrl');
    } else {
      buffer.writeln(
          '🔗 Visita nuestra tienda: https://fibroacademyusa.com/shop/');
    }

    buffer.writeln();
    buffer.writeln(
        '📱 Descarga la app de Fibro Academy para más ofertas exclusivas.');

    await Share.share(
      buffer.toString(),
      subject: 'Producto: $productName - Fibro Academy',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Comparte el enlace de la aplicación
  static Future<void> shareApp({
    Rect? sharePositionOrigin,
  }) async {
    const message = '''
🌟 ¡Descubre Fibro Academy!

La mejor aplicación para profesionales de la estética y belleza.

✨ Cursos certificados
🛍️ Productos profesionales
📚 Materiales exclusivos

Descarga la app ahora:
📱 Android: https://play.google.com/store/apps/details?id=com.fibroacademy.app
🍎 iOS: https://apps.apple.com/app/fibro-academy/id123456789

🌐 Web: https://fibroacademyusa.com
''';

    await Share.share(
      message,
      subject: 'Fibro Academy - Tu academia de estética',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Comparte una promoción
  static Future<void> sharePromotion({
    required String title,
    required String description,
    required String? promoCode,
    required String? discountPercent,
    Rect? sharePositionOrigin,
  }) async {
    final buffer = StringBuffer();

    buffer.writeln('🎉 ¡PROMOCIÓN ESPECIAL!');
    buffer.writeln();
    buffer.writeln('🏷️ $title');
    buffer.writeln();
    buffer.writeln(description);
    buffer.writeln();

    if (discountPercent != null) {
      buffer.writeln('💥 $discountPercent% DE DESCUENTO');
    }

    if (promoCode != null && promoCode.isNotEmpty) {
      buffer.writeln('🎫 Código: $promoCode');
    }

    buffer.writeln();
    buffer.writeln('🛒 Compra ahora: https://fibroacademyusa.com/shop/');
    buffer.writeln();
    buffer.writeln('📱 Fibro Academy');

    await Share.share(
      buffer.toString(),
      subject: 'Promoción: $title - Fibro Academy',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Comparte un enlace genérico
  static Future<void> shareLink({
    required String title,
    required String url,
    String? description,
    Rect? sharePositionOrigin,
  }) async {
    final buffer = StringBuffer();

    buffer.writeln(title);
    if (description != null && description.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(description);
    }
    buffer.writeln();
    buffer.writeln('🔗 $url');
    buffer.writeln();
    buffer.writeln('📱 Fibro Academy');

    await Share.share(
      buffer.toString(),
      subject: title,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Comparte imagen con texto
  static Future<void> shareImage({
    required XFile imageFile,
    required String title,
    String? description,
    Rect? sharePositionOrigin,
  }) async {
    final text = description != null
        ? '$title\n\n$description\n\n📱 Fibro Academy'
        : '$title\n\n📱 Fibro Academy';

    await Share.shareXFiles(
      [imageFile],
      text: text,
      subject: title,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Obtiene el Rect para compartir desde un widget (útil para iPad)
  static Rect? getSharePositionFromContext(BuildContext context) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      return box.localToGlobal(Offset.zero) & box.size;
    }
    return null;
  }

  /// Limpia etiquetas HTML de un texto
  static String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }
}
