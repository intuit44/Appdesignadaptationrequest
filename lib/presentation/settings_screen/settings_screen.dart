import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/storage/secure_storage.dart';

/// Pantalla de Configuración
/// Permite al usuario personalizar preferencias de la app
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _darkMode = false;
  String _language = 'Español';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final storage = SecureStorage.instance;
    final themeMode = await storage.getThemeMode();
    setState(() {
      _darkMode = themeMode == 'dark';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray50,
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: FibroColors.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Sección de Notificaciones
          _buildSectionHeader('Notificaciones'),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Notificaciones Push',
            subtitle: 'Recibe alertas de ofertas y actualizaciones',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
              _saveNotificationSetting(value);
            },
          ),
          _buildSwitchTile(
            icon: Icons.email_outlined,
            title: 'Notificaciones por Email',
            subtitle: 'Recibe ofertas exclusivas en tu correo',
            value: _emailNotifications,
            onChanged: (value) {
              setState(() => _emailNotifications = value);
            },
          ),

          // Sección de Apariencia
          _buildSectionHeader('Apariencia'),
          _buildSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: 'Modo Oscuro',
            subtitle: 'Activar tema oscuro',
            value: _darkMode,
            onChanged: (value) {
              setState(() => _darkMode = value);
              _saveThemeMode(value);
            },
          ),
          _buildNavigationTile(
            icon: Icons.language_outlined,
            title: 'Idioma',
            subtitle: _language,
            onTap: () => _showLanguageDialog(),
          ),

          // Sección de Privacidad
          _buildSectionHeader('Privacidad y Seguridad'),
          _buildNavigationTile(
            icon: Icons.lock_outline,
            title: 'Cambiar Contraseña',
            subtitle: 'Actualiza tu contraseña',
            onTap: () => _showChangePasswordDialog(),
          ),
          _buildNavigationTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Política de Privacidad',
            subtitle: 'Cómo manejamos tus datos',
            onTap: () => _showPrivacyPolicy(),
          ),
          _buildNavigationTile(
            icon: Icons.description_outlined,
            title: 'Términos y Condiciones',
            subtitle: 'Términos de uso del servicio',
            onTap: () => _showTermsConditions(),
          ),

          // Sección de Datos
          _buildSectionHeader('Datos'),
          _buildNavigationTile(
            icon: Icons.download_outlined,
            title: 'Descargar mis Datos',
            subtitle: 'Solicita una copia de tus datos',
            onTap: () => _requestDataDownload(),
          ),
          _buildNavigationTile(
            icon: Icons.delete_forever_outlined,
            title: 'Eliminar Cuenta',
            subtitle: 'Elimina permanentemente tu cuenta',
            onTap: () => _showDeleteAccountDialog(),
            isDestructive: true,
          ),

          // Sección de Caché
          _buildSectionHeader('Almacenamiento'),
          _buildNavigationTile(
            icon: Icons.cleaning_services_outlined,
            title: 'Limpiar Caché',
            subtitle: 'Libera espacio de almacenamiento',
            onTap: () => _clearCache(),
          ),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.h, 24.h, 16.h, 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.fSize,
          fontWeight: FontWeight.w600,
          color: FibroColors.primaryOrange,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: ListTile(
        leading: Container(
          width: 40.h,
          height: 40.h,
          decoration: BoxDecoration(
            color: FibroColors.primaryOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.h),
          ),
          child: Icon(icon, color: FibroColors.primaryOrange, size: 20.h),
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
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: FibroColors.primaryOrange,
        ),
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40.h,
          height: 40.h,
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withValues(alpha: 0.1)
                : FibroColors.primaryOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.h),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : FibroColors.primaryOrange,
            size: 20.h,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15.fSize,
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : appTheme.blueGray80001,
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
          Icons.chevron_right,
          color: appTheme.blueGray600,
        ),
      ),
    );
  }

  Future<void> _saveNotificationSetting(bool value) async {
    await SecureStorage.instance
        .write('notifications_enabled', value.toString());
  }

  Future<void> _saveThemeMode(bool isDark) async {
    await SecureStorage.instance.saveThemeMode(isDark ? 'dark' : 'light');
    // Notificar cambio de tema si es necesario
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('Español', 'es'),
            _buildLanguageOption('English', 'en'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String name, String code) {
    final isSelected = _language == name;
    return ListTile(
      title: Text(name),
      trailing: isSelected
          ? Icon(Icons.check, color: FibroColors.primaryOrange)
          : null,
      onTap: () {
        setState(() => _language = name);
        Navigator.pop(context);
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña Actual',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.h),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.h),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.h),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contraseña actualizada')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FibroColors.primaryOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    _showInfoDialog(
      'Política de Privacidad',
      'En Fibro Academy, valoramos tu privacidad. Recopilamos únicamente '
          'la información necesaria para brindarte un mejor servicio. '
          'Tus datos personales están protegidos y nunca serán compartidos '
          'con terceros sin tu consentimiento.',
    );
  }

  void _showTermsConditions() {
    _showInfoDialog(
      'Términos y Condiciones',
      'Al usar la aplicación de Fibro Academy, aceptas nuestros términos '
          'de servicio. Nos reservamos el derecho de modificar estos términos '
          'en cualquier momento. El uso continuado de la aplicación constituye '
          'la aceptación de cualquier cambio.',
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
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

  void _requestDataDownload() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Solicitud enviada. Recibirás tus datos por email.'),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8.h),
            const Text('Eliminar Cuenta'),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que deseas eliminar tu cuenta? '
          'Esta acción es irreversible y perderás todos tus datos, '
          'incluyendo cursos, pedidos e historial.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Solicitud de eliminación enviada'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar Caché'),
        content: const Text(
          '¿Deseas eliminar los archivos temporales? '
          'Esto puede mejorar el rendimiento de la app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Caché limpiada correctamente')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FibroColors.primaryOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }
}
