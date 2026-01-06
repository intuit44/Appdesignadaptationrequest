import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';
import '../../../data/repositories/shop_repository.dart';
import '../../../widgets/course_category_widgets.dart';
import '../../../widgets/product_category_widgets.dart';
import '../../../widgets/product_card_widget.dart';
import '../../../widgets/crm_course_widgets.dart';
import '../../../widgets/crm_calendar_widgets.dart';
import '../../../widgets/crm_tags_forms_widgets.dart';
import '../../product_categories_screen/product_categories_screen.dart';

/// Contenido del Home siguiendo la estructura de fibroacademyusa.com
/// Secciones:
/// 1. Banner principal "Empieza a emprender hoy"
/// 2. Categorías de Cursos (Talleres, Corporales, Estética Médica, Cosméticos)
/// 3. Línea de Productos
/// 4. Testimonios
/// 5. Por qué estudiar en Fibro Academy
/// 6. Contacto/Footer
class FibroHomeContent extends ConsumerStatefulWidget {
  const FibroHomeContent({super.key});

  @override
  ConsumerState<FibroHomeContent> createState() => _FibroHomeContentState();
}

class _FibroHomeContentState extends ConsumerState<FibroHomeContent> {
  @override
  void initState() {
    super.initState();
    // Cargar datos al iniciar usando microtask para no bloquear UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cargar en microtask para evitar bloquear el hilo principal
      Future.microtask(() async {
        // Cargar productos de WooCommerce (legacy)
        ref.read(shopRepositoryProvider.notifier).loadProducts();
        ref.read(shopRepositoryProvider.notifier).loadFeaturedProducts();
      });

      // Inicializar datos del CRM (cursos, tags, calendarios) - separado
      Future.microtask(() {
        ref.read(agentCRMRepositoryProvider.notifier).initialize();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Banner Principal
          _buildHeroBanner(),
          SizedBox(height: 24.h),

          // 2. Categorías de Cursos (estáticas)
          CourseCategoriesCarousel(
            title: 'Nuestros Cursos',
            subtitle:
                'Amplía tus conocimientos y lleva tu negocio al siguiente nivel',
            onCategoryTap: (category) {
              _onCourseCategoryTap(category);
            },
          ),
          SizedBox(height: 32.h),

          // 2.5. Cursos del CRM (dinámicos - 56 productos)
          CRMCoursesCarousel(
            title: 'Cursos Disponibles',
            subtitle: 'Explora nuestro catálogo completo de formación',
            maxItems: 8,
            onCourseTap: (course) {
              _onCRMCourseTap(course);
            },
          ),
          SizedBox(height: 32.h),

          // 3. Banner "Luce una piel más saludable"
          _buildSkinBanner(),
          SizedBox(height: 32.h),

          // 3.5. Calendarios y Eventos del CRM
          CRMCalendarSection(
            title: 'Próximos Eventos',
          ),
          SizedBox(height: 32.h),

          // 4. Categorías de Productos
          ProductCategoriesRow(
            title: 'Nuestra Línea de Productos',
            onCategoryTap: (category) {
              _onProductCategoryTap(category);
            },
          ),
          SizedBox(height: 24.h),

          // 5. Productos Destacados
          _buildFeaturedProducts(),
          SizedBox(height: 32.h),

          // 6. Por qué estudiar en Fibro Academy
          _buildWhyFibroSection(),
          SizedBox(height: 32.h),

          // 7. Banner de Certificación
          _buildCertificationBanner(),
          SizedBox(height: 32.h),

          // 8. Formulario de Contacto del CRM
          _buildCRMContactForm(),
          SizedBox(height: 32.h),

          // 9. Contacto y Redes Sociales
          _buildContactSection(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  /// Maneja tap en curso del CRM
  void _onCRMCourseTap(dynamic course) {
    // Navegar a detalle del curso del CRM
    Navigator.pushNamed(
      context,
      AppRoutes.agentCRMCoursesScreen,
      arguments: {'courseId': course.id},
    );
  }

  /// Sección de formulario de contacto usando Forms del CRM
  Widget _buildCRMContactForm() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            FibroColors.secondaryTeal.withValues(alpha: 0.1),
            FibroColors.tealLight,
          ],
        ),
        borderRadius: BorderRadius.circular(20.h),
        border: Border.all(
          color: FibroColors.secondaryTeal.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.contact_mail_outlined,
                color: FibroColors.secondaryTeal,
                size: 28.h,
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Tienes dudas?',
                      style: TextStyle(
                        fontSize: 18.fSize,
                        fontWeight: FontWeight.bold,
                        color: FibroColors.tealDark,
                      ),
                    ),
                    Text(
                      'Contáctanos y te ayudamos',
                      style: TextStyle(
                        fontSize: 13.fSize,
                        color: FibroColors.tealDark.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          CRMFormButton(
            formId: 'contact-general',
            label: 'Solicitar Información',
            icon: Icons.send_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      margin: EdgeInsets.all(16.h),
      height: 200.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            FibroColors.primaryOrange,
            FibroColors.orangeDark,
          ],
        ),
        borderRadius: BorderRadius.circular(24.h),
        boxShadow: [
          BoxShadow(
            color: FibroColors.primaryOrange.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Patrón decorativo
          Positioned(
            right: -40.h,
            top: -40.h,
            child: Container(
              width: 160.h,
              height: 160.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            left: -20.h,
            bottom: -20.h,
            child: Container(
              width: 100.h,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          // Contenido
          Padding(
            padding: EdgeInsets.all(24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¡Empieza a emprender\nhoy y crece tu negocio!',
                  style: TextStyle(
                    fontSize: 22.fSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    // Navegar a cursos
                    Navigator.pushNamed(
                        context, AppRoutes.agentCRMCoursesScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: FibroColors.primaryOrange,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.h, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.h),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Comienza ahora',
                    style: TextStyle(
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkinBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: FibroColors.tealLight,
        borderRadius: BorderRadius.circular(20.h),
        border: Border.all(
          color: FibroColors.secondaryTeal.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Icono
          Container(
            width: 60.h,
            height: 60.h,
            decoration: BoxDecoration(
              color: FibroColors.secondaryTeal.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.spa,
              size: 32.h,
              color: FibroColors.secondaryTeal,
            ),
          ),
          SizedBox(width: 16.h),
          // Texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LUCE UNA PIEL MÁS SALUDABLE',
                  style: TextStyle(
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.bold,
                    color: FibroColors.tealDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Conoce nuestros productos en estética',
                  style: TextStyle(
                    fontSize: 13.fSize,
                    color: FibroColors.tealDark.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          // Flecha
          IconButton(
            onPressed: () {
              // Navegar a tienda de productos
              Navigator.pushNamed(context, AppRoutes.productCategoriesScreen);
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: FibroColors.secondaryTeal,
              size: 20.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProducts() {
    final shopState = ref.watch(shopRepositoryProvider);
    final featuredProducts = shopState.featuredProducts.isNotEmpty
        ? shopState.featuredProducts
        : shopState.products.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Productos Destacados',
                style: TextStyle(
                  fontSize: 18.fSize,
                  fontWeight: FontWeight.bold,
                  color: appTheme.blueGray80001,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Ver todos los productos
                  Navigator.pushNamed(
                      context, AppRoutes.productCategoriesScreen);
                },
                child: Text(
                  'Ver todos',
                  style: TextStyle(
                    fontSize: 14.fSize,
                    color: appTheme.deepOrange400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        if (shopState.isLoading)
          SizedBox(
            height: 200.h,
            child: Center(
              child: CircularProgressIndicator(
                color: appTheme.deepOrange400,
              ),
            ),
          )
        else if (featuredProducts.isEmpty)
          SizedBox(
            height: 150.h,
            child: Center(
              child: Text(
                'No hay productos disponibles',
                style: TextStyle(color: appTheme.blueGray600),
              ),
            ),
          )
        else
          SizedBox(
            height: 280.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              scrollDirection: Axis.horizontal,
              itemCount: featuredProducts.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.h),
              itemBuilder: (context, index) {
                final product = featuredProducts[index];
                return SizedBox(
                  width: 160.h,
                  child: ProductCardWidget(
                    product: product,
                    onTap: () {
                      // Navegar a detalle del producto
                      AppRoutes.navigateToProductDetail(context, product);
                    },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildWhyFibroSection() {
    final reasons = [
      {
        'icon': Icons.check_circle_outline,
        'title': 'Aplicamos lo que enseñamos',
        'color': FibroColors.primaryOrange,
      },
      {
        'icon': Icons.layers_outlined,
        'title': 'Módulos por nivel',
        'color': FibroColors.secondaryTeal,
      },
      {
        'icon': Icons.person_outline,
        'title': 'Facilitadores con alta experiencia',
        'color': const Color(0xFF7E57C2),
      },
      {
        'icon': Icons.card_membership_outlined,
        'title': 'Te certificamos',
        'color': const Color(0xFF4DB6AC),
      },
      {
        'icon': Icons.groups_outlined,
        'title': 'Forma parte de nuestra familia',
        'color': const Color(0xFFFF8A65),
      },
      {
        'icon': Icons.science_outlined,
        'title': 'Teoría y práctica en estudio',
        'color': const Color(0xFF5C6BC0),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Text(
            '¿Por qué estudiar en Fibro Academy?',
            style: TextStyle(
              fontSize: 20.fSize,
              fontWeight: FontWeight.bold,
              color: appTheme.blueGray80001,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            scrollDirection: Axis.horizontal,
            itemCount: reasons.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.h),
            itemBuilder: (context, index) {
              final reason = reasons[index];
              return Container(
                width: 140.h,
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: (reason['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.h),
                  border: Border.all(
                    color: (reason['color'] as Color).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      reason['icon'] as IconData,
                      size: 32.h,
                      color: reason['color'] as Color,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      reason['title'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.fSize,
                        fontWeight: FontWeight.w600,
                        color: appTheme.blueGray80001,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCertificationBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF7E57C2),
            const Color(0xFF5E35B1),
          ],
        ),
        borderRadius: BorderRadius.circular(20.h),
      ),
      child: Row(
        children: [
          // Icono de certificado
          Container(
            width: 70.h,
            height: 70.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium,
              size: 40.h,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16.h),
          // Texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recibirás tu Diploma',
                  style: TextStyle(
                    fontSize: 18.fSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Al terminar la certificación será entregado de manera física',
                  style: TextStyle(
                    fontSize: 13.fSize,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(24.h),
      decoration: BoxDecoration(
        color: appTheme.gray10001,
        borderRadius: BorderRadius.circular(20.h),
      ),
      child: Column(
        children: [
          Text(
            '¡No esperes más!',
            style: TextStyle(
              fontSize: 20.fSize,
              fontWeight: FontWeight.bold,
              color: appTheme.blueGray80001,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Comienza hoy mismo a estudiar y crece tu negocio',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.fSize,
              color: appTheme.blueGray600,
            ),
          ),
          SizedBox(height: 20.h),
          // Redes sociales
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                icon: Icons.phone,
                color: FibroColors.primaryOrange,
                onTap: () => _launchUrl('tel:${FibroContactInfo.phone1}'),
              ),
              SizedBox(width: 12.h),
              _buildSocialButton(
                icon: Icons.email_outlined,
                color: FibroColors.secondaryTeal,
                onTap: () => _launchUrl('mailto:${FibroContactInfo.email}'),
              ),
              SizedBox(width: 12.h),
              _buildSocialButton(
                icon: Icons.chat,
                color: const Color(0xFF25D366), // WhatsApp green
                onTap: () => _launchUrl(FibroContactInfo.whatsappUrl),
              ),
              SizedBox(width: 12.h),
              _buildSocialButton(
                icon: Icons.camera_alt_outlined,
                color: const Color(0xFFE1306C), // Instagram
                onTap: () => _launchUrl(FibroContactInfo.instagramUrl),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Botón principal
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.agentCRMCoursesScreen);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FibroColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.h),
                ),
                elevation: 0,
              ),
              child: Text(
                '¡QUIERO INSCRIBIRME!',
                style: TextStyle(
                  fontSize: 14.fSize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.h),
      child: Container(
        width: 48.h,
        height: 48.h,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Icon(
          icon,
          color: color,
          size: 24.h,
        ),
      ),
    );
  }

  void _onCourseCategoryTap(CourseCategoryInfo category) {
    // Navegar a los cursos de Agent CRM con filtro de categoría
    Navigator.pushNamed(context, AppRoutes.agentCRMCoursesScreen);
  }

  void _onProductCategoryTap(ProductCategoryInfo category) {
    // Navegar a la pantalla de categorías con el filtro de la categoría seleccionada
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductCategoriesScreen(
          initialCategoryId: category.id,
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo abrir: $url'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
