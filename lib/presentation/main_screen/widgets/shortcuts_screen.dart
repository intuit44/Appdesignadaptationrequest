import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../core/providers/auth_state_provider.dart';
import '../../sign_in_dialog/sign_in_dialog.dart';

/// Pantalla de Accesos Directos
/// Proporciona acceso rápido a las funciones principales de la app
class ShortcutsScreen extends ConsumerWidget {
  const ShortcutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: appTheme.gray50,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          _buildHeader(),
          SizedBox(height: 16.h),
          // Accesos rápidos principales
          _buildMainShortcuts(context, ref, authState.isAuthenticated),
          SizedBox(height: 24.h),
          // Categorías de cursos
          _buildCourseShortcuts(context),
          SizedBox(height: 24.h),
          // Categorías de productos
          _buildProductShortcuts(context),
          SizedBox(height: 24.h),
          // Soporte y ayuda
          _buildSupportShortcuts(context),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.h, 20.h, 20.h, 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FibroColors.primaryOrange,
            FibroColors.orangeDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accesos Directos',
            style: TextStyle(
              fontSize: 24.fSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Navega rápidamente a las secciones principales',
            style: TextStyle(
              fontSize: 14.fSize,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainShortcuts(
      BuildContext context, WidgetRef ref, bool isAuthenticated) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accesos Rápidos',
            style: TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.bold,
              color: appTheme.blueGray80001,
            ),
          ),
          SizedBox(height: 12.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.h,
            childAspectRatio: 0.85,
            children: [
              _buildShortcutItem(
                icon: Icons.school_outlined,
                label: 'Cursos',
                color: FibroColors.primaryOrange,
                onTap: () =>
                    NavigatorService.pushNamed(AppRoutes.agentCRMCoursesScreen),
              ),
              _buildShortcutItem(
                icon: Icons.shopping_bag_outlined,
                label: 'Tienda',
                color: FibroColors.secondaryTeal,
                onTap: () => NavigatorService.pushNamed(
                    AppRoutes.productCategoriesScreen),
              ),
              _buildShortcutItem(
                icon: Icons.receipt_long_outlined,
                label: 'Pedidos',
                color: Colors.blue,
                onTap: () => _handleProtectedRoute(
                  context,
                  ref,
                  isAuthenticated,
                  () {
                    NavigatorService.pushNamed(AppRoutes.ordersScreen);
                  },
                ),
              ),
              _buildShortcutItem(
                icon: Icons.favorite_outline,
                label: 'Favoritos',
                color: FibroColors.primaryOrange,
                onTap: () {
                  NavigatorService.pushNamed(AppRoutes.wishlistScreen);
                },
              ),
              _buildShortcutItem(
                icon: Icons.calendar_month_outlined,
                label: 'Citas',
                color: Colors.purple,
                onTap: () => _handleProtectedRoute(
                  context,
                  ref,
                  isAuthenticated,
                  () =>
                      NavigatorService.pushNamed(AppRoutes.appointmentsScreen),
                ),
              ),
              _buildShortcutItem(
                icon: Icons.card_membership,
                label: 'Membresía',
                color: Colors.amber.shade700,
                onTap: () =>
                    NavigatorService.pushNamed(AppRoutes.agentCRMCoursesScreen),
              ),
              _buildShortcutItem(
                icon: Icons.location_on_outlined,
                label: 'Ubicación',
                color: Colors.green,
                onTap: () => _handleProtectedRoute(
                  context,
                  ref,
                  isAuthenticated,
                  () {
                    NavigatorService.pushNamed(AppRoutes.addressesScreen);
                  },
                ),
              ),
              _buildShortcutItem(
                icon: Icons.help_outline,
                label: 'Ayuda',
                color: appTheme.blueGray600,
                onTap: () {
                  NavigatorService.pushNamed(AppRoutes.helpScreen);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.h,
            height: 56.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16.h),
            ),
            child: Icon(
              icon,
              size: 28.h,
              color: color,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.fSize,
              fontWeight: FontWeight.w500,
              color: appTheme.blueGray80001,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCourseShortcuts(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categorías de Cursos',
                style: TextStyle(
                  fontSize: 18.fSize,
                  fontWeight: FontWeight.bold,
                  color: appTheme.blueGray80001,
                ),
              ),
              TextButton(
                onPressed: () =>
                    NavigatorService.pushNamed(AppRoutes.agentCRMCoursesScreen),
                child: Text(
                  'Ver todos',
                  style: TextStyle(
                    fontSize: 14.fSize,
                    color: FibroColors.primaryOrange,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          _buildCategoryRow([
            _CategoryItem('Talleres', Icons.work_outline, Colors.orange),
            _CategoryItem('Corporales', Icons.accessibility_new, Colors.teal),
            _CategoryItem('Estética Médica', Icons.medical_services_outlined,
                Colors.blue),
            _CategoryItem(
                'Cosméticos', Icons.spa_outlined, FibroColors.primaryOrange),
          ]),
        ],
      ),
    );
  }

  Widget _buildProductShortcuts(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categorías de Productos',
                style: TextStyle(
                  fontSize: 18.fSize,
                  fontWeight: FontWeight.bold,
                  color: appTheme.blueGray80001,
                ),
              ),
              TextButton(
                onPressed: () => NavigatorService.pushNamed(
                    AppRoutes.productCategoriesScreen),
                child: Text(
                  'Ver todos',
                  style: TextStyle(
                    fontSize: 14.fSize,
                    color: FibroColors.primaryOrange,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          _buildCategoryRow([
            _CategoryItem('Equipos', Icons.precision_manufacturing_outlined,
                Colors.indigo),
            _CategoryItem('Accesorios', Icons.build_outlined, Colors.brown),
            _CategoryItem('Insumos', Icons.inventory_2_outlined, Colors.green),
            _CategoryItem('Ofertas', Icons.local_offer_outlined, Colors.red),
          ]),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(List<_CategoryItem> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items
          .map((item) => _buildCategoryChip(item.name, item.icon, item.color))
          .toList(),
    );
  }

  Widget _buildCategoryChip(String name, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        // Navegar a la tienda filtrando por categoría
        NavigatorService.pushNamed(AppRoutes.productCategoriesScreen);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.h,
            height: 50.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24.h,
              color: color,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 11.fSize,
              color: appTheme.blueGray80001,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportShortcuts(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Soporte',
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSupportItem(
                  icon: Icons.chat_bubble_outline,
                  title: 'Chat en Vivo',
                  subtitle: 'Habla con un asesor',
                  onTap: () {},
                ),
                Divider(height: 1, indent: 56.h),
                _buildSupportItem(
                  icon: Icons.phone_outlined,
                  title: 'Llamar',
                  subtitle: '+1 (786) 123-4567',
                  onTap: () {},
                ),
                Divider(height: 1, indent: 56.h),
                _buildSupportItem(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: 'info@fibroacademyusa.com',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(12.h),
        child: Row(
          children: [
            Icon(icon, size: 24.h, color: FibroColors.primaryOrange),
            SizedBox(width: 12.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.fSize,
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

  /// Maneja rutas protegidas que requieren autenticación
  void _handleProtectedRoute(
    BuildContext context,
    WidgetRef ref,
    bool isAuthenticated,
    VoidCallback onAuthenticated,
  ) {
    if (isAuthenticated) {
      onAuthenticated();
    } else {
      _showLoginRequired(context);
    }
  }

  /// Muestra diálogo indicando que se requiere login
  void _showLoginRequired(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lock_outline, color: FibroColors.primaryOrange),
            SizedBox(width: 8.h),
            const Text('Iniciar Sesión'),
          ],
        ),
        content: const Text(
          'Necesitas iniciar sesión para acceder a esta sección.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => const Dialog(
                  child: SignInDialog(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FibroColors.primaryOrange,
            ),
            child: const Text('Iniciar Sesión'),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  _CategoryItem(this.name, this.icon, this.color);
}
