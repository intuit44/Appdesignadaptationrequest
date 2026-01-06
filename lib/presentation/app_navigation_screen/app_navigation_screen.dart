import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../sign_in_dialog/sign_in_dialog.dart';
import '../sign_up_dialog/sign_up_dialog.dart';

/// Pantalla de navegación para acceder a todas las pantallas de la app
/// Adaptada al contexto de Fibro Academy USA
class AppNavigationScreen extends ConsumerStatefulWidget {
  const AppNavigationScreen({super.key});

  @override
  AppNavigationScreenState createState() => AppNavigationScreenState();
}

class AppNavigationScreenState extends ConsumerState<AppNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray50,
      appBar: AppBar(
        backgroundColor: FibroColors.primaryOrange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Navegación Fibro Academy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.fSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección Principal
            _buildSectionHeader('Pantalla Principal'),
            _buildNavigationCard(
              icon: Icons.home,
              title: 'Inicio',
              subtitle: 'Pantalla principal con productos y cursos',
              color: FibroColors.primaryOrange,
              onTap: () => onTapScreenTitle(AppRoutes.mainScreen),
            ),

            SizedBox(height: 24.h),

            // Sección de Cursos
            _buildSectionHeader('Cursos y Capacitación'),
            _buildNavigationCard(
              icon: Icons.school,
              title: 'Cursos Agent CRM',
              subtitle: 'Talleres y certificaciones profesionales',
              color: FibroColors.secondaryTeal,
              onTap: () => onTapScreenTitle(AppRoutes.agentCRMCoursesScreen),
            ),
            _buildNavigationCard(
              icon: Icons.calendar_month,
              title: 'Citas y Calendarios',
              subtitle: 'Programa tus citas y capacitaciones',
              color: const Color(0xFF9C27B0),
              onTap: () => onTapScreenTitle(AppRoutes.appointmentsScreen),
            ),
            _buildNavigationCard(
              icon: Icons.play_circle_outline,
              title: 'Detalle de Curso',
              subtitle: 'Vista detallada de un curso',
              color: const Color(0xFF7E57C2),
              onTap: () => onTapScreenTitle(AppRoutes.fibroCourseDetailsScreen),
            ),
            _buildNavigationCard(
              icon: Icons.attach_money,
              title: 'Precios de Cursos',
              subtitle: 'Planes y precios disponibles',
              color: const Color(0xFF26A69A),
              onTap: () => onTapScreenTitle(AppRoutes.pricingScreen),
            ),

            SizedBox(height: 24.h),

            // Sección de Productos
            _buildSectionHeader('Tienda de Productos'),
            _buildNavigationCard(
              icon: Icons.category,
              title: 'Categorías de Productos',
              subtitle: 'FibroSkin, DM.Cell, CO2, Colágeno...',
              color: FibroColors.primaryOrange,
              onTap: () => onTapScreenTitle(AppRoutes.productCategoriesScreen),
            ),
            _buildNavigationCard(
              icon: Icons.shopping_bag,
              title: 'Tienda Online',
              subtitle: 'Catálogo completo de productos',
              color: const Color(0xFFFF7043),
              onTap: () => onTapScreenTitle(AppRoutes.fibroShopMainScreen),
            ),
            _buildNavigationCard(
              icon: Icons.storefront,
              title: 'Tienda (Vista 2)',
              subtitle: 'Vista alternativa de la tienda',
              color: const Color(0xFFEC407A),
              onTap: () => onTapScreenTitle(AppRoutes.fibroShopScreen),
            ),
            _buildNavigationCard(
              icon: Icons.shopping_cart,
              title: 'Carrito de Compras',
              subtitle: 'Ver productos agregados',
              color: const Color(0xFF42A5F5),
              onTap: () => onTapScreenTitle(AppRoutes.cartScreen),
            ),

            SizedBox(height: 24.h),

            // Sección de Instructores
            _buildSectionHeader('Instructores y Mentores'),
            _buildNavigationCard(
              icon: Icons.person_add,
              title: 'Ser Instructor',
              subtitle: 'Únete al equipo de Fibro Academy',
              color: const Color(0xFF5C6BC0),
              onTap: () => onTapScreenTitle(AppRoutes.becomeAnInstructorScreen),
            ),
            _buildNavigationCard(
              icon: Icons.groups,
              title: 'Nuestros Mentores',
              subtitle: 'Conoce a nuestro equipo',
              color: const Color(0xFF26C6DA),
              onTap: () => onTapScreenTitle(AppRoutes.mentorsScreen),
            ),
            _buildNavigationCard(
              icon: Icons.person,
              title: 'Perfil de Mentor',
              subtitle: 'Detalle de un instructor',
              color: const Color(0xFF66BB6A),
              onTap: () => onTapScreenTitle(AppRoutes.mentorProfileScreen),
            ),

            SizedBox(height: 24.h),

            // Sección de Cuenta
            _buildSectionHeader('Cuenta de Usuario'),
            _buildNavigationCard(
              icon: Icons.login,
              title: 'Iniciar Sesión',
              subtitle: 'Accede a tu cuenta',
              color: FibroColors.secondaryTeal,
              onTap: () => onTapDialogTitle(context, const SignInDialog()),
            ),
            _buildNavigationCard(
              icon: Icons.person_add_alt,
              title: 'Registrarse',
              subtitle: 'Crea una cuenta nueva',
              color: FibroColors.primaryOrange,
              onTap: () => onTapDialogTitle(context, const SignUpDialog()),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.fSize,
          fontWeight: FontWeight.bold,
          color: appTheme.blueGray80001,
        ),
      ),
    );
  }

  Widget _buildNavigationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.h),
        side: BorderSide(color: appTheme.gray200),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44.h,
          height: 44.h,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.h),
          ),
          child: Icon(icon, color: color, size: 24.h),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15.fSize,
            fontWeight: FontWeight.w600,
            color: appTheme.blueGray80001,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12.fSize,
            color: appTheme.blueGray600,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.h,
          color: appTheme.blueGray100,
        ),
      ),
    );
  }

  /// Common click event for dialog
  void onTapDialogTitle(BuildContext context, Widget className) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.h),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: SingleChildScrollView(
              child: className,
            ),
          ),
          backgroundColor: Colors.transparent,
        );
      },
    );
  }

  /// Common click event
  void onTapScreenTitle(String routeName) {
    Navigator.pushNamed(context, routeName);
  }
}
