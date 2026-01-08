import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import '../../data/services/woocommerce_service.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

/// Provider para tutoriales
final tutorialsProvider =
    FutureProvider.autoDispose<List<TutorialCategory>>((ref) async {
  final wcService = ref.read(wooCommerceServiceProvider);
  return wcService.getTutorials();
});

/// Pantalla de Tutoriales - Videos y guías de aprendizaje
/// Conectada a Cloud Functions para datos reales
class TutorialsScreen extends ConsumerStatefulWidget {
  const TutorialsScreen({super.key});

  @override
  ConsumerState<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends ConsumerState<TutorialsScreen> {
  @override
  Widget build(BuildContext context) {
    final tutorialsAsync = ref.watch(tutorialsProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray50,
        appBar: _buildAppBar(context),
        body: tutorialsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: FibroColors.primaryOrange,
            ),
          ),
          error: (error, stack) => _buildErrorState(error),
          data: (categories) => categories.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(tutorialsProvider);
                  },
                  color: FibroColors.primaryOrange,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.h),
                    itemCount: categories.length,
                    itemBuilder: (context, index) =>
                        _buildCategory(categories[index]),
                  ),
                ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () => NavigatorService.goBack(),
      ),
      title: AppbarTitle(
        text: 'Tutoriales',
        margin: EdgeInsets.only(left: 8.h),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: appTheme.blueGray80001),
          onPressed: () {
            ref.invalidate(tutorialsProvider);
          },
        ),
      ],
      styleType: Style.bgFill,
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.h,
              color: Colors.red.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              'Error al cargar tutoriales',
              style: TextStyle(
                fontSize: 18.fSize,
                fontWeight: FontWeight.bold,
                color: appTheme.blueGray80001,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.fSize,
                color: appTheme.blueGray600,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(tutorialsProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: FibroColors.primaryOrange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64.h,
              color: appTheme.blueGray600,
            ),
            SizedBox(height: 16.h),
            Text(
              'No hay tutoriales disponibles',
              style: TextStyle(
                fontSize: 18.fSize,
                fontWeight: FontWeight.bold,
                color: appTheme.blueGray80001,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Los tutoriales estarán disponibles próximamente',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.fSize,
                color: appTheme.blueGray600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(TutorialCategory category) {
    final color = _parseColor(category.color);

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de categoría
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.h),
                ),
                child: Icon(
                  _getIconData(category.icon),
                  color: color,
                  size: 24.h,
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: TextStyle(
                        fontSize: 18.fSize,
                        fontWeight: FontWeight.bold,
                        color: appTheme.blueGray80001,
                      ),
                    ),
                    Text(
                      '${category.tutorials.length} video${category.tutorials.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12.fSize,
                        color: appTheme.blueGray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Lista de tutoriales
          ...category.tutorials
              .map((tutorial) => _buildTutorialCard(tutorial, color)),
        ],
      ),
    );
  }

  Widget _buildTutorialCard(Tutorial tutorial, Color accentColor) {
    return GestureDetector(
      onTap: () => _playTutorial(context, tutorial, accentColor),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
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
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 100.h,
              height: 80.h,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(12.h),
                ),
                image: tutorial.thumbnailUrl != null
                    ? DecorationImage(
                        image: NetworkImage(tutorial.thumbnailUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    tutorial.isAvailable
                        ? Icons.play_circle_filled
                        : Icons.lock_outline,
                    size: 40.h,
                    color: tutorial.thumbnailUrl != null
                        ? Colors.white
                        : accentColor,
                  ),
                  // Duración
                  Positioned(
                    bottom: 4.h,
                    right: 4.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.h,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4.h),
                      ),
                      child: Text(
                        tutorial.duration,
                        style: TextStyle(
                          fontSize: 10.fSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tutorial.title,
                      style: TextStyle(
                        fontSize: 14.fSize,
                        fontWeight: FontWeight.w600,
                        color: appTheme.blueGray80001,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      tutorial.description,
                      style: TextStyle(
                        fontSize: 12.fSize,
                        color: appTheme.blueGray600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Arrow
            Padding(
              padding: EdgeInsets.only(right: 12.h),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16.h,
                color: appTheme.blueGray600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playTutorial(
      BuildContext context, Tutorial tutorial, Color accentColor) {
    // Si tiene URL de video, intentar abrirlo
    if (tutorial.videoUrl != null && tutorial.isAvailable) {
      _openVideo(tutorial.videoUrl!);
      return;
    }

    // Mostrar modal con información del tutorial
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              width: 40.h,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.h),
              ),
            ),
            // Video placeholder
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.h),
                child: Column(
                  children: [
                    // Video area
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(12.h),
                          image: tutorial.thumbnailUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(tutorial.thumbnailUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                tutorial.isAvailable
                                    ? Icons.play_circle_outline
                                    : Icons.lock_outline,
                                size: 80.h,
                                color: Colors.white70,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                tutorial.isAvailable
                                    ? 'Reproducir video'
                                    : 'Video no disponible',
                                style: TextStyle(
                                  fontSize: 16.fSize,
                                  color: Colors.white70,
                                ),
                              ),
                              if (!tutorial.isAvailable) ...[
                                SizedBox(height: 8.h),
                                Text(
                                  'Disponible próximamente',
                                  style: TextStyle(
                                    fontSize: 14.fSize,
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Info
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tutorial.title,
                            style: TextStyle(
                              fontSize: 18.fSize,
                              fontWeight: FontWeight.bold,
                              color: appTheme.blueGray80001,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16.h,
                                color: appTheme.blueGray600,
                              ),
                              SizedBox(width: 4.h),
                              Text(
                                tutorial.duration,
                                style: TextStyle(
                                  fontSize: 14.fSize,
                                  color: appTheme.blueGray600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            tutorial.description,
                            style: TextStyle(
                              fontSize: 14.fSize,
                              color: appTheme.blueGray80001,
                            ),
                          ),
                          const Spacer(),
                          // Botón de acción
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                if (tutorial.videoUrl != null &&
                                    tutorial.isAvailable) {
                                  _openVideo(tutorial.videoUrl!);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          const Icon(
                                            Icons.notifications_active,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8.h),
                                          const Text(
                                            'Te notificaremos cuando esté disponible',
                                          ),
                                        ],
                                      ),
                                      backgroundColor:
                                          FibroColors.secondaryTeal,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              icon: Icon(
                                tutorial.isAvailable
                                    ? Icons.play_arrow
                                    : Icons.notifications_none,
                              ),
                              label: Text(
                                tutorial.isAvailable
                                    ? 'Ver tutorial'
                                    : 'Notificarme cuando esté listo',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se puede abrir el video: $url'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _parseColor(String colorStr) {
    try {
      if (colorStr.startsWith('#')) {
        return Color(int.parse(colorStr.substring(1), radix: 16) + 0xFF000000);
      }
      return FibroColors.primaryOrange;
    } catch (_) {
      return FibroColors.primaryOrange;
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'play_circle_outline':
        return Icons.play_circle_outline;
      case 'school_outlined':
        return Icons.school_outlined;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'business_center_outlined':
        return Icons.business_center_outlined;
      case 'star_outline':
        return Icons.star_outline;
      default:
        return Icons.play_circle_outline;
    }
  }
}
