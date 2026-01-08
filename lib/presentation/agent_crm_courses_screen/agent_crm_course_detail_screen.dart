import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import '../../core/services/share_service.dart';
import '../../data/models/agent_crm_models.dart';
import '../../widgets/custom_elevated_button.dart';
import '../membership_portal_screen/membership_portal_screen.dart';

/// Pantalla de detalles de un curso de Agent CRM Pro
/// Muestra información detallada del curso, precio, y opciones de inscripción
class AgentCRMCourseDetailScreen extends ConsumerStatefulWidget {
  final AgentCRMProduct course;

  const AgentCRMCourseDetailScreen({
    super.key,
    required this.course,
  });

  @override
  ConsumerState<AgentCRMCourseDetailScreen> createState() =>
      _AgentCRMCourseDetailScreenState();
}

class _AgentCRMCourseDetailScreenState
    extends ConsumerState<AgentCRMCourseDetailScreen> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray50,
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: _buildContent(),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250.h,
      pinned: true,
      backgroundColor: appTheme.deepOrange400,
      leading: Container(
        margin: EdgeInsets.all(8.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.h),
          color: appTheme.deepOrange400,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(8.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.share, size: 20.h),
            color: appTheme.deepOrange400,
            onPressed: _shareCourse,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeaderImage(),
      ),
    );
  }

  Widget _buildHeaderImage() {
    if (widget.course.imageUrl != null && widget.course.imageUrl!.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          ExtendedImage.network(
            widget.course.imageUrl!,
            fit: BoxFit.cover,
            cache: true,
            loadStateChanged: (state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return Container(
                    color: appTheme.deepOrange400.withValues(alpha: 0.3),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  );
                case LoadState.failed:
                  return _buildPlaceholderImage();
                case LoadState.completed:
                  return null;
              }
            },
          ),
          // Gradient overlay para mejorar legibilidad
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appTheme.deepOrange400,
            appTheme.deepOrange400.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          _getCourseIcon(),
          size: 80.h,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  IconData _getCourseIcon() {
    final nameLower = widget.course.name.toLowerCase();
    if (nameLower.contains('dermaplanning') ||
        nameLower.contains('facial') ||
        nameLower.contains('hydrafacial')) {
      return Icons.face_retouching_natural;
    } else if (nameLower.contains('laser') || nameLower.contains('lash')) {
      return Icons.auto_fix_high;
    } else if (nameLower.contains('biopen') || nameLower.contains('micro')) {
      return Icons.medical_services_outlined;
    } else if (nameLower.contains('membership') ||
        nameLower.contains('membresía')) {
      return Icons.card_membership;
    } else if (nameLower.contains('consent') ||
        nameLower.contains('consentimiento')) {
      return Icons.description_outlined;
    }
    return Icons.school_outlined;
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.all(20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge de tipo
          _buildTypeBadge(),
          SizedBox(height: 12.h),
          // Nombre del curso
          Text(
            widget.course.name,
            style: TextStyle(
              fontSize: 24.fSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          // Precio destacado
          _buildPriceCard(),
          SizedBox(height: 24.h),
          // Descripción
          if (widget.course.description != null &&
              widget.course.description!.isNotEmpty)
            _buildDescriptionSection(),
          // Información adicional
          _buildInfoSection(),
          SizedBox(height: 24.h),
          // Beneficios del curso
          _buildBenefitsSection(),
          SizedBox(height: 100.h), // Espacio para el botón flotante
        ],
      ),
    );
  }

  Widget _buildTypeBadge() {
    String label;
    Color bgColor;
    Color textColor;
    IconData icon;

    if (widget.course.isMembership) {
      label = 'MEMBRESÍA';
      bgColor = Colors.purple.shade100;
      textColor = Colors.purple.shade700;
      icon = Icons.card_membership;
    } else if (widget.course.isCourse) {
      label = 'CURSO PROFESIONAL';
      bgColor = appTheme.deepOrange400.withValues(alpha: 0.15);
      textColor = appTheme.deepOrange400;
      icon = Icons.school;
    } else {
      label = 'PRODUCTO';
      bgColor = Colors.blue.shade100;
      textColor = Colors.blue.shade700;
      icon = Icons.inventory_2_outlined;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.h),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.h, color: textColor),
          SizedBox(width: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.fSize,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard() {
    final price = widget.course.price ?? 0.0;
    final hasPrice = price > 0;

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteA700,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Precio',
                style: TextStyle(
                  fontSize: 12.fSize,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 4.h),
              if (hasPrice)
                Text(
                  '\$${price.toStringAsFixed(2)} USD',
                  style: TextStyle(
                    fontSize: 28.fSize,
                    fontWeight: FontWeight.bold,
                    color: appTheme.deepOrange400,
                  ),
                )
              else
                Text(
                  'Consultar precio',
                  style: TextStyle(
                    fontSize: 20.fSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
            ],
          ),
          if (widget.course.isMembership)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(20.h),
              ),
              child: Text(
                'ACCESO COMPLETO',
                style: TextStyle(
                  fontSize: 10.fSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    final description = widget.course.description ?? '';
    final shouldTruncate = description.length > 200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción',
          style: TextStyle(
            fontSize: 18.fSize,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          shouldTruncate && !_isExpanded
              ? '${description.substring(0, 200)}...'
              : description,
          style: TextStyle(
            fontSize: 14.fSize,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
        if (shouldTruncate)
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Ver menos' : 'Ver más',
              style: TextStyle(
                color: appTheme.deepOrange400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteA700,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.business,
            title: 'Proveedor',
            value: 'Fibro Academy USA',
          ),
          Divider(height: 24.h),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            title: 'Ubicación',
            value: 'Doral, FL',
          ),
          Divider(height: 24.h),
          _buildInfoRow(
            icon: Icons.verified_outlined,
            title: 'Certificación',
            value: 'Incluida',
          ),
          if (widget.course.productType.isNotEmpty) ...[
            Divider(height: 24.h),
            _buildInfoRow(
              icon: Icons.category_outlined,
              title: 'Tipo',
              value: widget.course.productType,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.h),
          decoration: BoxDecoration(
            color: appTheme.deepOrange400.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.h),
          ),
          child: Icon(icon, size: 20.h, color: appTheme.deepOrange400),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.fSize,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.fSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsSection() {
    final benefits = _getCourseBenefits();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lo que incluye',
          style: TextStyle(
            fontSize: 18.fSize,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        ...benefits.map((benefit) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.h),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 16.h,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(width: 12.h),
                  Expanded(
                    child: Text(
                      benefit,
                      style: TextStyle(
                        fontSize: 14.fSize,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  List<String> _getCourseBenefits() {
    if (widget.course.isMembership) {
      return [
        'Acceso ilimitado a todos los cursos',
        'Material de estudio digital',
        'Soporte prioritario',
        'Actualizaciones incluidas',
        'Comunidad exclusiva',
      ];
    }

    return [
      'Certificado de finalización',
      'Material de estudio incluido',
      'Acceso a instructores',
      'Práctica supervisada',
      'Soporte post-curso',
    ];
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteA700,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Botón de contacto
            Expanded(
              flex: 1,
              child: OutlinedButton.icon(
                onPressed: _contactUs,
                icon: const Icon(Icons.chat_outlined),
                label: const Text('Consultar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: appTheme.deepOrange400,
                  side: BorderSide(color: appTheme.deepOrange400),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.h),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.h),
            // Botón de inscripción
            Expanded(
              flex: 2,
              child: CustomElevatedButton(
                text:
                    widget.course.isMembership ? 'Suscribirse' : 'Inscribirse',
                onPressed: _enrollCourse,
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.deepOrange400,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.h),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareCourse() {
    // Compartir curso usando el servicio de compartir
    // Generar URL del curso (basada en el sitio web de Fibro Academy)
    final courseUrl = 'https://fibroacademy.com/cursos/${widget.course.id}';

    ShareService.shareCourse(
      courseName: widget.course.name,
      courseDescription: widget.course.description,
      courseUrl: courseUrl,
      price: widget.course.price?.toStringAsFixed(2),
      sharePositionOrigin: ShareService.getSharePositionFromContext(context),
    );
  }

  void _contactUs() async {
    // Abrir WhatsApp o email
    final Uri whatsappUrl = Uri.parse(
        'https://wa.me/17869194699?text=Hola, me interesa el curso: ${Uri.encodeComponent(widget.course.name)}');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir WhatsApp'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _enrollCourse() async {
    // Abrir portal de membresía directamente en la app
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MembershipPortalScreen(),
      ),
    );
  }
}
