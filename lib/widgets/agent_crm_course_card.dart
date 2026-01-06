import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../data/models/agent_crm_models.dart';

/// Widget de tarjeta de curso para mostrar cursos de Agent CRM Pro
/// Diseñado para coincidir con el estilo visual de la app Fibroskin
class AgentCRMCourseCard extends StatelessWidget {
  final AgentCRMProduct course;
  final VoidCallback? onTap;
  final bool showDescription;
  final bool compact;

  const AgentCRMCourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.showDescription = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.whiteA700,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: compact ? _buildCompactLayout() : _buildFullLayout(),
      ),
    );
  }

  Widget _buildFullLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen del curso
        _buildCourseImage(),
        // Información del curso
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tipo de curso (badge)
                _buildCourseBadge(),
                SizedBox(height: 8.h),
                // Nombre del curso
                Expanded(
                  child: Text(
                    course.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                // Precio
                _buildPriceSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return Row(
      children: [
        // Imagen pequeña
        ClipRRect(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(12.h)),
          child: SizedBox(
            width: 100.h,
            height: double.infinity,
            child: _buildImageWidget(),
          ),
        ),
        // Info
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCourseBadge(),
                SizedBox(height: 6.h),
                Text(
                  course.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.fSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildPriceSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseImage() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12.h)),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: _buildImageWidget(),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (course.imageUrl != null && course.imageUrl!.isNotEmpty) {
      return ExtendedImage.network(
        course.imageUrl!,
        fit: BoxFit.cover,
        cache: true,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: appTheme.deepOrange400,
                  ),
                ),
              );
            case LoadState.failed:
              return _buildPlaceholderImage();
            case LoadState.completed:
              return null;
          }
        },
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
            appTheme.deepOrange400.withValues(alpha: 0.3),
            appTheme.deepOrange400.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          _getCourseIcon(),
          size: 40.h,
          color: appTheme.deepOrange400,
        ),
      ),
    );
  }

  IconData _getCourseIcon() {
    final nameLower = course.name.toLowerCase();
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

  Widget _buildCourseBadge() {
    String label;
    Color bgColor;
    Color textColor;

    if (course.isMembership) {
      label = 'MEMBRESÍA';
      bgColor = Colors.purple.shade100;
      textColor = Colors.purple.shade700;
    } else if (course.isCourse) {
      label = 'CURSO';
      bgColor = appTheme.deepOrange400.withValues(alpha: 0.15);
      textColor = appTheme.deepOrange400;
    } else {
      label = 'PRODUCTO';
      bgColor = Colors.blue.shade100;
      textColor = Colors.blue.shade700;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.h),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.fSize,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    final price = course.price ?? 0.0;
    final hasPrice = price > 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (hasPrice)
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.bold,
              color: appTheme.deepOrange400,
            ),
          )
        else
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(4.h),
            ),
            child: Text(
              'CONSULTAR',
              style: TextStyle(
                fontSize: 10.fSize,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ),
        // Icono de info
        Icon(
          Icons.arrow_forward_ios,
          size: 14.h,
          color: Colors.grey.shade400,
        ),
      ],
    );
  }
}

/// Widget horizontal para mostrar un curso de forma compacta
class AgentCRMCourseCardHorizontal extends StatelessWidget {
  final AgentCRMProduct course;
  final VoidCallback? onTap;

  const AgentCRMCourseCardHorizontal({
    super.key,
    required this.course,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AgentCRMCourseCard(
      course: course,
      onTap: onTap,
      compact: true,
    );
  }
}
