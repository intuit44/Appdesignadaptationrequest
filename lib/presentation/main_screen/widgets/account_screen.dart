import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../core/providers/auth_state_provider.dart';
import '../../sign_in_dialog/sign_in_dialog.dart';

/// Pantalla de cuenta/perfil del usuario
/// Reacciona al estado de autenticación global
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: appTheme.gray50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con perfil - cambia según autenticación
            authState.isAuthenticated
                ? _buildAuthenticatedHeader(context, ref, authState)
                : _buildGuestHeader(context),
            SizedBox(height: 16.h),
            // Secciones de menú
            _buildMenuSection(context, authState.isAuthenticated),
          ],
        ),
      ),
    );
  }

  /// Header cuando el usuario está autenticado
  Widget _buildAuthenticatedHeader(
      BuildContext context, WidgetRef ref, GlobalAuthState authState) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.h),
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
          // Avatar con foto o iniciales
          Container(
            width: 80.h,
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              image: authState.photoUrl != null
                  ? DecorationImage(
                      image: NetworkImage(authState.photoUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: authState.photoUrl == null
                ? Center(
                    child: Text(
                      _getInitials(authState.displayName),
                      style: TextStyle(
                        fontSize: 28.fSize,
                        fontWeight: FontWeight.bold,
                        color: FibroColors.secondaryTeal,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(height: 12.h),
          Text(
            '¡Hola, ${authState.displayName.split(' ').first}!',
            style: TextStyle(
              fontSize: 22.fSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (authState.email != null) ...[
            SizedBox(height: 4.h),
            Text(
              authState.email!,
              style: TextStyle(
                fontSize: 14.fSize,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
          SizedBox(height: 16.h),
          // Botón de cerrar sesión
          OutlinedButton.icon(
            onPressed: () => _showLogoutConfirmation(context, ref),
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Cerrar Sesión'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 2),
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Obtiene iniciales del nombre
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  /// Muestra confirmación de logout
  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authStateProvider.notifier).signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FibroColors.primaryOrange,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  /// Header cuando el usuario NO está autenticado (invitado)
  Widget _buildGuestHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appTheme.deepOrange400,
            appTheme.deepOrange400.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80.h,
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Icon(
              Icons.person,
              size: 50.h,
              color: appTheme.deepOrange400,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Bienvenido',
            style: TextStyle(
              fontSize: 22.fSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Inicia sesión para ver tu cuenta',
            style: TextStyle(
              fontSize: 14.fSize,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: 16.h),
          // Botones de acción
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Mostrar diálogo de inicio de sesión
                    showDialog(
                      context: context,
                      builder: (context) => const Dialog(
                        child: SignInDialog(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: appTheme.deepOrange400,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                  ),
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Mostrar diálogo de inicio de sesión (mismo diálogo)
                    showDialog(
                      context: context,
                      builder: (context) => const Dialog(
                        child: SignInDialog(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                  ),
                  child: Text(
                    'Registrarse',
                    style: TextStyle(
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, bool isAuthenticated) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
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
          _buildMenuItem(
            icon: Icons.school_outlined,
            title: 'Mis Cursos',
            subtitle: isAuthenticated
                ? 'Ver cursos adquiridos'
                : 'Inicia sesión para ver tus cursos',
            onTap: () =>
                NavigatorService.pushNamed(AppRoutes.agentCRMCoursesScreen),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Mis Pedidos',
            subtitle: isAuthenticated
                ? 'Historial de compras'
                : 'Inicia sesión para ver pedidos',
            onTap: () => _handleProtectedRoute(context, isAuthenticated, () {
              NavigatorService.pushNamed(AppRoutes.ordersScreen);
            }),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.favorite_outline,
            title: 'Lista de Deseos',
            subtitle: 'Productos guardados',
            onTap: () {
              NavigatorService.pushNamed(AppRoutes.wishlistScreen);
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.location_on_outlined,
            title: 'Direcciones',
            subtitle: isAuthenticated
                ? 'Gestionar direcciones de envío'
                : 'Inicia sesión para gestionar',
            onTap: () => _handleProtectedRoute(context, isAuthenticated, () {
              NavigatorService.pushNamed(AppRoutes.addressesScreen);
            }),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.credit_card_outlined,
            title: 'Métodos de Pago',
            subtitle: isAuthenticated
                ? 'Tarjetas guardadas'
                : 'Inicia sesión para gestionar',
            onTap: () => _handleProtectedRoute(context, isAuthenticated, () {
              NavigatorService.pushNamed(AppRoutes.paymentMethodsScreen);
            }),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: 'Configuración',
            subtitle: 'Preferencias de la app',
            onTap: () {
              NavigatorService.pushNamed(AppRoutes.settingsScreen);
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Ayuda y Soporte',
            subtitle: 'Centro de ayuda',
            onTap: () {
              NavigatorService.pushNamed(AppRoutes.helpScreen);
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'Acerca de',
            subtitle: 'Información de la app',
            onTap: () {
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  /// Maneja rutas protegidas que requieren autenticación
  void _handleProtectedRoute(
    BuildContext context,
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

  /// Muestra diálogo Acerca de
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 40.h,
              height: 40.h,
              errorBuilder: (_, __, ___) => Icon(
                Icons.spa,
                size: 40.h,
                color: FibroColors.primaryOrange,
              ),
            ),
            SizedBox(width: 12.h),
            const Text('Fibro Academy'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Versión 1.0.0',
              style: TextStyle(
                fontSize: 14.fSize,
                color: appTheme.blueGray600,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'La academia líder en formación de estética y belleza en USA.',
              style: TextStyle(fontSize: 14.fSize),
            ),
            SizedBox(height: 8.h),
            Text(
              '© 2026 Fibro Academy USA',
              style: TextStyle(
                fontSize: 12.fSize,
                color: appTheme.blueGray600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 44.h,
              height: 44.h,
              decoration: BoxDecoration(
                color: appTheme.deepOrange400.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.h),
              ),
              child: Icon(
                icon,
                color: appTheme.deepOrange400,
                size: 24.h,
              ),
            ),
            SizedBox(width: 14.h),
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
                  SizedBox(height: 2.h),
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
              size: 24.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 74.h,
      endIndent: 16.h,
      color: appTheme.gray100,
    );
  }
}
