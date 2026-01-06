import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

/// Pantalla de Tutoriales - Videos y guías de aprendizaje
class TutorialsScreen extends ConsumerStatefulWidget {
  const TutorialsScreen({super.key});

  @override
  ConsumerState<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends ConsumerState<TutorialsScreen> {
  final List<_TutorialCategory> _categories = [
    _TutorialCategory(
      title: 'Primeros Pasos',
      icon: Icons.play_circle_outline,
      color: FibroColors.primaryOrange,
      tutorials: [
        _Tutorial(
          title: 'Bienvenida a Fibroskin Academy',
          duration: '5:30',
          thumbnail: 'welcome',
          description: 'Conoce nuestra academia y lo que aprenderás.',
        ),
        _Tutorial(
          title: 'Cómo navegar la app',
          duration: '3:45',
          thumbnail: 'navigation',
          description: 'Guía rápida de todas las funciones de la aplicación.',
        ),
        _Tutorial(
          title: 'Tu primera compra',
          duration: '4:20',
          thumbnail: 'shopping',
          description: 'Paso a paso para comprar tus primeros productos.',
        ),
      ],
    ),
    _TutorialCategory(
      title: 'Técnicas Básicas',
      icon: Icons.school_outlined,
      color: FibroColors.secondaryTeal,
      tutorials: [
        _Tutorial(
          title: 'Preparación de la piel',
          duration: '8:15',
          thumbnail: 'skin_prep',
          description: 'Limpieza y preparación antes del procedimiento.',
        ),
        _Tutorial(
          title: 'Uso correcto del dermógrafo',
          duration: '12:00',
          thumbnail: 'dermograph',
          description: 'Manejo profesional del equipo de micropigmentación.',
        ),
        _Tutorial(
          title: 'Pigmentos y colorimetría',
          duration: '15:30',
          thumbnail: 'pigments',
          description: 'Selección de colores según el tipo de piel.',
        ),
      ],
    ),
    _TutorialCategory(
      title: 'Técnicas Avanzadas',
      icon: Icons.auto_awesome,
      color: Colors.purple,
      tutorials: [
        _Tutorial(
          title: 'Microblading pelo a pelo',
          duration: '20:00',
          thumbnail: 'microblading',
          description: 'Técnica avanzada para cejas naturales.',
        ),
        _Tutorial(
          title: 'Labios con efecto 3D',
          duration: '18:45',
          thumbnail: 'lips_3d',
          description: 'Creación de volumen y definición en labios.',
        ),
        _Tutorial(
          title: 'Corrección de trabajos',
          duration: '25:00',
          thumbnail: 'correction',
          description: 'Cómo corregir y mejorar trabajos previos.',
        ),
      ],
    ),
    _TutorialCategory(
      title: 'Negocio y Marketing',
      icon: Icons.business_center_outlined,
      color: Colors.amber.shade700,
      tutorials: [
        _Tutorial(
          title: 'Crea tu portafolio',
          duration: '10:00',
          thumbnail: 'portfolio',
          description: 'Fotografía tus trabajos profesionalmente.',
        ),
        _Tutorial(
          title: 'Marketing en redes sociales',
          duration: '14:30',
          thumbnail: 'marketing',
          description: 'Estrategias para atraer más clientes.',
        ),
        _Tutorial(
          title: 'Precios y presupuestos',
          duration: '8:00',
          thumbnail: 'pricing',
          description: 'Cómo establecer tus tarifas competitivamente.',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray50,
        appBar: _buildAppBar(context),
        body: ListView.builder(
          padding: EdgeInsets.all(16.h),
          itemCount: _categories.length,
          itemBuilder: (context, index) => _buildCategory(_categories[index]),
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
      styleType: Style.bgFill,
    );
  }

  Widget _buildCategory(_TutorialCategory category) {
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
                  color: category.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.h),
                ),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 24.h,
                ),
              ),
              SizedBox(width: 12.h),
              Text(
                category.title,
                style: TextStyle(
                  fontSize: 18.fSize,
                  fontWeight: FontWeight.bold,
                  color: appTheme.blueGray80001,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Lista de tutoriales
          ...category.tutorials.map((tutorial) => _buildTutorialCard(
                tutorial,
                category.color,
              )),
        ],
      ),
    );
  }

  Widget _buildTutorialCard(_Tutorial tutorial, Color accentColor) {
    return GestureDetector(
      onTap: () => _playTutorial(context, tutorial),
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
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.play_circle_filled,
                    size: 40.h,
                    color: accentColor,
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

  void _playTutorial(BuildContext context, _Tutorial tutorial) {
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
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_circle_outline,
                                size: 80.h,
                                color: Colors.white70,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Video en desarrollo',
                                style: TextStyle(
                                  fontSize: 16.fSize,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Disponible próximamente',
                                style: TextStyle(
                                  fontSize: 14.fSize,
                                  color: Colors.white54,
                                ),
                              ),
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
                          // Botón de notificarme
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
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
                                    backgroundColor: FibroColors.secondaryTeal,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.notifications_none),
                              label:
                                  const Text('Notificarme cuando esté listo'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: FibroColors.primaryOrange,
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
}

class _TutorialCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<_Tutorial> tutorials;

  _TutorialCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.tutorials,
  });
}

class _Tutorial {
  final String title;
  final String duration;
  final String thumbnail;
  final String description;

  _Tutorial({
    required this.title,
    required this.duration,
    required this.thumbnail,
    required this.description,
  });
}
