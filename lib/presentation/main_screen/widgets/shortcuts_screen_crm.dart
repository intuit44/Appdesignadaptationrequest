import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';
import '../../../core/providers/auth_state_provider.dart';
import '../../../data/models/agent_crm_models.dart';
import '../../../data/repositories/agent_crm_repository.dart';
import '../../sign_in_dialog/sign_in_dialog.dart';

/// Pantalla de Accesos Directos - CONECTADA AL CRM
/// Todos los datos vienen de Agent CRM Pro (GoHighLevel)
class ShortcutsScreenCRM extends ConsumerStatefulWidget {
  const ShortcutsScreenCRM({super.key});

  @override
  ConsumerState<ShortcutsScreenCRM> createState() => _ShortcutsScreenCRMState();
}

class _ShortcutsScreenCRMState extends ConsumerState<ShortcutsScreenCRM> {
  @override
  void initState() {
    super.initState();
    // Inicializar CRM al cargar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(agentCRMRepositoryProvider);
      if (state.location == null && !state.isLoading) {
        ref.read(agentCRMRepositoryProvider.notifier).initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final crmState = ref.watch(agentCRMRepositoryProvider);

    return Scaffold(
      backgroundColor: appTheme.gray50,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(agentCRMRepositoryProvider.notifier).initialize();
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header con datos del CRM
            _buildHeader(crmState.location),
            SizedBox(height: 16.h),
            // Accesos rápidos principales
            _buildMainShortcuts(context, ref, authState.isAuthenticated),
            SizedBox(height: 24.h),
            // Cursos del CRM
            _buildCRMCourses(crmState),
            SizedBox(height: 24.h),
            // Membresías del CRM
            _buildCRMMemberships(crmState),
            SizedBox(height: 24.h),
            // Soporte con datos del CRM Location
            _buildSupportFromCRM(context, crmState.location),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AgentCRMLocation? location) {
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
            location?.name ?? 'Fibro Academy',
            style: TextStyle(
              fontSize: 24.fSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Accesos Directos',
            style: TextStyle(
              fontSize: 16.fSize,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          if (location?.address != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.white70, size: 16.h),
                SizedBox(width: 4.h),
                Expanded(
                  child: Text(
                    '${location!.address}, ${location.city ?? ''} ${location.state ?? ''}',
                    style: TextStyle(
                      fontSize: 12.fSize,
                      color: Colors.white70,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
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
                  () => NavigatorService.pushNamed(AppRoutes.ordersScreen),
                ),
              ),
              _buildShortcutItem(
                icon: Icons.favorite_outline,
                label: 'Favoritos',
                color: FibroColors.primaryOrange,
                onTap: () =>
                    NavigatorService.pushNamed(AppRoutes.wishlistScreen),
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
                    NavigatorService.pushNamed(AppRoutes.pricingScreen),
              ),
              _buildShortcutItem(
                icon: Icons.people_outline,
                label: 'Mentores',
                color: Colors.indigo,
                onTap: () =>
                    NavigatorService.pushNamed(AppRoutes.mentorsScreen),
              ),
              _buildShortcutItem(
                icon: Icons.help_outline,
                label: 'Ayuda',
                color: appTheme.blueGray600,
                onTap: () => NavigatorService.pushNamed(AppRoutes.helpScreen),
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
            child: Icon(icon, size: 28.h, color: color),
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

  /// Cursos del CRM
  Widget _buildCRMCourses(AgentCRMState crmState) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cursos Disponibles',
                style: TextStyle(
                  fontSize: 18.fSize,
                  fontWeight: FontWeight.bold,
                  color: appTheme.blueGray80001,
                ),
              ),
              if (crmState.courses.isNotEmpty)
                TextButton(
                  onPressed: () => NavigatorService.pushNamed(
                      AppRoutes.agentCRMCoursesScreen),
                  child: Text(
                    'Ver todos (${crmState.courses.length})',
                    style: TextStyle(
                      fontSize: 14.fSize,
                      color: FibroColors.primaryOrange,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          if (crmState.isLoading)
            _buildLoadingIndicator()
          else if (crmState.courses.isEmpty)
            _buildEmptyState('No hay cursos disponibles', Icons.school_outlined)
          else
            SizedBox(
              height: 120.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: crmState.courses.take(5).length,
                itemBuilder: (context, index) {
                  final course = crmState.courses[index];
                  return _buildCourseCard(course);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(AgentCRMProduct course) {
    return GestureDetector(
      onTap: () {
        // Navegar al detalle del curso
        NavigatorService.pushNamed(AppRoutes.agentCRMCoursesScreen);
      },
      child: Container(
        width: 180.h,
        margin: EdgeInsets.only(right: 12.h),
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                    color: FibroColors.primaryOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Icon(
                    Icons.school,
                    color: FibroColors.primaryOrange,
                    size: 20.h,
                  ),
                ),
                const Spacer(),
                if (course.price != null)
                  Text(
                    '\$${course.price!.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.bold,
                      color: FibroColors.secondaryTeal,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              course.name,
              style: TextStyle(
                fontSize: 13.fSize,
                fontWeight: FontWeight.w600,
                color: appTheme.blueGray80001,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (course.description != null)
              Text(
                course.description!,
                style: TextStyle(
                  fontSize: 11.fSize,
                  color: appTheme.blueGray600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  /// Membresías del CRM
  Widget _buildCRMMemberships(AgentCRMState crmState) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Membresías',
                style: TextStyle(
                  fontSize: 18.fSize,
                  fontWeight: FontWeight.bold,
                  color: appTheme.blueGray80001,
                ),
              ),
              if (crmState.memberships.isNotEmpty)
                TextButton(
                  onPressed: () =>
                      NavigatorService.pushNamed(AppRoutes.pricingScreen),
                  child: Text(
                    'Ver todas',
                    style: TextStyle(
                      fontSize: 14.fSize,
                      color: FibroColors.primaryOrange,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          if (crmState.isLoading)
            _buildLoadingIndicator()
          else if (crmState.memberships.isEmpty)
            _buildEmptyState(
                'No hay membresías disponibles', Icons.card_membership)
          else
            SizedBox(
              height: 100.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: crmState.memberships.length,
                itemBuilder: (context, index) {
                  final membership = crmState.memberships[index];
                  return _buildMembershipCard(membership);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMembershipCard(AgentCRMProduct membership) {
    return GestureDetector(
      onTap: () => NavigatorService.pushNamed(AppRoutes.pricingScreen),
      child: Container(
        width: 160.h,
        margin: EdgeInsets.only(right: 12.h),
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amber.shade600,
              Colors.amber.shade800,
            ],
          ),
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.white, size: 20.h),
                SizedBox(width: 4.h),
                Expanded(
                  child: Text(
                    membership.name,
                    style: TextStyle(
                      fontSize: 13.fSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (membership.price != null)
              Text(
                '\$${membership.price!.toStringAsFixed(0)}/mes',
                style: TextStyle(
                  fontSize: 18.fSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Soporte con datos del CRM Location
  Widget _buildSupportFromCRM(
      BuildContext context, AgentCRMLocation? location) {
    // Usar datos del CRM si están disponibles, sino fallback
    final phone = location?.phone ?? FibroContactInfo.phone1;
    final email = location?.email ?? FibroContactInfo.email;
    final website = location?.website ?? FibroContactInfo.website;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contacto',
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
                  onTap: () =>
                      NavigatorService.pushNamed(AppRoutes.chatbotScreen),
                ),
                Divider(height: 1, indent: 56.h),
                _buildSupportItem(
                  icon: Icons.phone_outlined,
                  title: 'Llamar',
                  subtitle: phone,
                  onTap: () => _launchPhone(phone),
                ),
                Divider(height: 1, indent: 56.h),
                _buildSupportItem(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: email,
                  onTap: () => _launchEmail(email),
                ),
                Divider(height: 1, indent: 56.h),
                _buildSupportItem(
                  icon: Icons.language_outlined,
                  title: 'Sitio Web',
                  subtitle: website,
                  onTap: () => _launchUrl(website),
                ),
                Divider(height: 1, indent: 56.h),
                _buildSupportItem(
                  icon: Icons.people_outline,
                  title: 'Nuestros Mentores',
                  subtitle: 'Conoce al equipo de instructores',
                  onTap: () =>
                      NavigatorService.pushNamed(AppRoutes.mentorsScreen),
                ),
                Divider(height: 1, indent: 56.h),
                _buildSupportItem(
                  icon: Icons.help_outline,
                  title: 'Centro de Ayuda',
                  subtitle: 'Preguntas frecuentes',
                  onTap: () => NavigatorService.pushNamed(AppRoutes.helpScreen),
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
            Icon(Icons.chevron_right, color: appTheme.blueGray600),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.h),
        child: CircularProgressIndicator(color: FibroColors.primaryOrange),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: EdgeInsets.all(24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Row(
        children: [
          Icon(icon, color: appTheme.blueGray600, size: 32.h),
          SizedBox(width: 12.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 14.fSize,
              color: appTheme.blueGray600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

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
                builder: (context) => const Dialog(child: SignInDialog()),
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
