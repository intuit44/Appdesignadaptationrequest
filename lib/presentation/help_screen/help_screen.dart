import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_export.dart';

/// Pantalla de Ayuda y Soporte
/// Centro de ayuda para usuarios
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray50,
      appBar: AppBar(
        title: const Text('Ayuda y Soporte'),
        backgroundColor: FibroColors.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Header de soporte
          _buildSupportHeader(),
          SizedBox(height: 24.h),

          // Opciones de contacto rápido
          _buildQuickContactSection(context),
          SizedBox(height: 24.h),

          // Preguntas frecuentes
          _buildFAQSection(context),
          SizedBox(height: 24.h),

          // Recursos adicionales
          _buildResourcesSection(context),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildSupportHeader() {
    return Container(
      padding: EdgeInsets.all(24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FibroColors.secondaryTeal,
            FibroColors.tealDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.support_agent,
            size: 60.h,
            color: Colors.white,
          ),
          SizedBox(height: 16.h),
          Text(
            '¿Cómo podemos ayudarte?',
            style: TextStyle(
              fontSize: 22.fSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Estamos aquí para resolver tus dudas',
            style: TextStyle(
              fontSize: 14.fSize,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickContactSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contacto Rápido',
            style: TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.bold,
              color: appTheme.blueGray80001,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildContactCard(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: 'info@fibroacademy.com',
                  color: Colors.blue,
                  onTap: () => _launchEmail(context),
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: _buildContactCard(
                  icon: Icons.phone_outlined,
                  title: 'Teléfono',
                  subtitle: '+1 (786) 555-0123',
                  color: Colors.green,
                  onTap: () => _launchPhone(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildContactCard(
                  icon: Icons.chat_outlined,
                  title: 'WhatsApp',
                  subtitle: 'Chat en vivo',
                  color: const Color(0xFF25D366),
                  onTap: () => _launchWhatsApp(context),
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: _buildContactCard(
                  icon: Icons.schedule_outlined,
                  title: 'Horario',
                  subtitle: 'Lun-Vie 9am-6pm',
                  color: FibroColors.primaryOrange,
                  onTap: () => _showScheduleInfo(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48.h,
              height: 48.h,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.h),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.fSize,
                fontWeight: FontWeight.w600,
                color: appTheme.blueGray80001,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.fSize,
                color: appTheme.blueGray600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final faqs = [
      {
        'question': '¿Cómo compro un curso?',
        'answer':
            'Puedes comprar cursos desde la sección de Tienda. Selecciona el curso que deseas, agrégalo al carrito y procede al pago con tarjeta o PayPal.',
      },
      {
        'question': '¿Cómo accedo a mis cursos comprados?',
        'answer':
            'Ve a la sección "Mi Cuenta" y selecciona "Mis Cursos". Ahí encontrarás todos los cursos que has adquirido.',
      },
      {
        'question': '¿Puedo cancelar un pedido?',
        'answer':
            'Puedes solicitar cancelación dentro de las primeras 24 horas después de la compra. Contacta a soporte para más información.',
      },
      {
        'question': '¿Cómo programo una cita?',
        'answer':
            'Desde la sección "Citas", selecciona el servicio deseado, elige fecha y hora disponible, y confirma tu reserva.',
      },
      {
        'question': '¿Ofrecen certificados?',
        'answer':
            'Sí, al completar nuestros cursos recibirás un certificado digital avalado por Fibro Academy USA.',
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preguntas Frecuentes',
            style: TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.bold,
              color: appTheme.blueGray80001,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.h),
            ),
            child: Column(
              children: faqs.map((faq) {
                return _FAQTile(
                  question: faq['question']!,
                  answer: faq['answer']!,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recursos',
            style: TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.bold,
              color: appTheme.blueGray80001,
            ),
          ),
          SizedBox(height: 12.h),
          _buildResourceTile(
            icon: Icons.play_circle_outline,
            title: 'Tutoriales',
            subtitle: 'Aprende a usar la app',
            onTap: () => _showTutorials(context),
          ),
          SizedBox(height: 8.h),
          _buildResourceTile(
            icon: Icons.public_outlined,
            title: 'Visitar Sitio Web',
            subtitle: 'fibroacademyusa.com',
            onTap: () => _launchWebsite(context),
          ),
          SizedBox(height: 8.h),
          _buildResourceTile(
            icon: Icons.facebook_outlined,
            title: 'Síguenos en Redes',
            subtitle: '@fibroacademyusa',
            onTap: () => _launchSocialMedia(context),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Row(
          children: [
            Container(
              width: 44.h,
              height: 44.h,
              decoration: BoxDecoration(
                color: FibroColors.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.h),
              ),
              child: Icon(
                icon,
                color: FibroColors.primaryOrange,
                size: 22.h,
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.fSize,
                      fontWeight: FontWeight.w600,
                      color: appTheme.blueGray80001,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.fSize,
                      color: appTheme.blueGray600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: appTheme.blueGray600,
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail(BuildContext context) async {
    final uri = Uri.parse('mailto:info@fibroacademy.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        _showCopyDialog(context, 'Email', 'info@fibroacademy.com');
      }
    }
  }

  void _launchPhone(BuildContext context) async {
    final uri = Uri.parse('tel:+17865550123');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        _showCopyDialog(context, 'Teléfono', '+1 (786) 555-0123');
      }
    }
  }

  void _launchWhatsApp(BuildContext context) async {
    final uri = Uri.parse('https://wa.me/17865550123');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir WhatsApp')),
        );
      }
    }
  }

  void _showScheduleInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Horario de Atención'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScheduleRow('Lunes - Viernes', '9:00 AM - 6:00 PM'),
            _buildScheduleRow('Sábado', '10:00 AM - 2:00 PM'),
            _buildScheduleRow('Domingo', 'Cerrado'),
            SizedBox(height: 12.h),
            Text(
              'Zona horaria: EST (Miami, FL)',
              style: TextStyle(
                fontSize: 12.fSize,
                color: appTheme.blueGray600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: FibroColors.primaryOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(String day, String hours) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day),
          Text(
            hours,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showCopyDialog(BuildContext context, String label, String value) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(label),
        content: SelectableText(value),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: FibroColors.primaryOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showTutorials(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.tutorialsScreen);
  }

  void _launchWebsite(BuildContext context) async {
    final uri = Uri.parse('https://fibroacademyusa.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _launchSocialMedia(BuildContext context) async {
    final uri = Uri.parse('https://instagram.com/fibroacademyusa');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _FAQTile extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQTile({
    required this.question,
    required this.answer,
  });

  @override
  State<_FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<_FAQTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            widget.question,
            style: TextStyle(
              fontSize: 14.fSize,
              fontWeight: FontWeight.w600,
              color: appTheme.blueGray80001,
            ),
          ),
          trailing: Icon(
            _isExpanded ? Icons.expand_less : Icons.expand_more,
            color: FibroColors.primaryOrange,
          ),
          onTap: () => setState(() => _isExpanded = !_isExpanded),
        ),
        if (_isExpanded)
          Padding(
            padding: EdgeInsets.fromLTRB(16.h, 0, 16.h, 16.h),
            child: Text(
              widget.answer,
              style: TextStyle(
                fontSize: 13.fSize,
                color: appTheme.blueGray600,
              ),
            ),
          ),
        Divider(height: 1, indent: 16.h, endIndent: 16.h),
      ],
    );
  }
}
