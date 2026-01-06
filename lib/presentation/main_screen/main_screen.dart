import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/app_export.dart';
import '../../core/services/voice_search_service.dart';
import '../../core/services/location_service.dart';
import '../../data/repositories/shop_repository.dart';
import '../home_screen/widgets/fibro_home_content.dart';
import '../cart_screen/cart_screen.dart';
import 'widgets/search_screen.dart';
import 'widgets/account_screen.dart';
import 'widgets/shortcuts_screen.dart';

// Export del searchControllerProvider para que se pueda usar
export 'widgets/search_screen.dart' show searchControllerProvider;

/// Pantalla principal con Bottom Navigation Bar estilo Amazon
/// Incluye: Home, Buscar, Carrito, Cuenta
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _currentLocation = '33166'; // Default zipcode

  // Screens
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Orden: Inicio | Cuenta | Carrito | Accesos Directos
    _screens = [
      const HomeScreenContent(),
      const AccountScreen(),
      const CartScreen(),
      const ShortcutsScreen(),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray50,
      body: Column(
        children: [
          // Top App Bar con búsqueda
          _buildTopAppBar(),
          // Contenido principal
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /// Top App Bar estilo Amazon con búsqueda y ubicación
  Widget _buildTopAppBar() {
    return Container(
      color: appTheme.deepOrange400,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Barra de búsqueda
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
              child: Row(
                children: [
                  // Search field
                  Expanded(
                    child: Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 12.h),
                          Icon(
                            Icons.search,
                            color: appTheme.blueGray600,
                            size: 22.h,
                          ),
                          SizedBox(width: 8.h),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Buscar en Fibro Academy',
                                hintStyle: TextStyle(
                                  color: appTheme.blueGray600,
                                  fontSize: 14.fSize,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(
                                fontSize: 14.fSize,
                                color: appTheme.blueGray80001,
                              ),
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  _performSearch(value);
                                }
                              },
                            ),
                          ),
                          // Botón de búsqueda por voz
                          IconButton(
                            icon: Icon(
                              Icons.mic_none,
                              color: appTheme.blueGray600,
                              size: 22.h,
                            ),
                            onPressed: _startVoiceSearch,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: 40.h,
                              minHeight: 40.h,
                            ),
                          ),
                          // Divisor vertical
                          Container(
                            height: 24.h,
                            width: 1,
                            color: appTheme.blueGray100,
                          ),
                          // Botón de búsqueda por imagen
                          IconButton(
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              color: appTheme.deepOrange400,
                              size: 22.h,
                            ),
                            onPressed: _startImageSearch,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: 40.h,
                              minHeight: 40.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Barra de ubicación
            InkWell(
              onTap: _showLocationPicker,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
                color: appTheme.teal50,
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: appTheme.blueGray80001,
                      size: 18.h,
                    ),
                    SizedBox(width: 4.h),
                    Text(
                      'Entregar a $_currentLocation',
                      style: TextStyle(
                        fontSize: 12.fSize,
                        color: appTheme.blueGray80001,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: appTheme.blueGray80001,
                      size: 18.h,
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

  /// Bottom Navigation Bar estilo Amazon
  Widget _buildBottomNavBar() {
    final cartItemCount = ref.watch(localCartProvider).itemCount;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Inicio',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Cuenta',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.shopping_cart_outlined,
                activeIcon: Icons.shopping_cart,
                label: 'Carrito',
                badge: cartItemCount > 0 ? cartItemCount : null,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view,
                label: 'Accesos',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int? badge,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(8.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected
                      ? appTheme.deepOrange400
                      : appTheme.blueGray600,
                  size: 26.h,
                ),
                if (badge != null)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: EdgeInsets.all(4.h),
                      decoration: BoxDecoration(
                        color: appTheme.deepOrange400,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18.h,
                        minHeight: 18.h,
                      ),
                      child: Text(
                        badge > 99 ? '99+' : badge.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.fSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.fSize,
                color:
                    isSelected ? appTheme.deepOrange400 : appTheme.blueGray600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      // Actualizar el controlador de búsqueda para que SearchScreen lo reciba
      ref.read(searchControllerProvider).setSearchQuery(query);
    }
    // Navegar a la pestaña de búsqueda
    setState(() => _currentIndex = 1);
  }

  void _startVoiceSearch() {
    // Mostrar diálogo de búsqueda por voz
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VoiceSearchDialog(
        hintText: 'Di lo que quieres buscar...',
        onResult: (recognizedText) {
          if (recognizedText.isNotEmpty) {
            _searchController.text = recognizedText;
            _performSearch(recognizedText);
          }
        },
      ),
    );
  }

  Future<void> _startImageSearch() async {
    final ImagePicker picker = ImagePicker();

    // Mostrar opciones: cámara o galería
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
        ),
        padding: EdgeInsets.all(20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.h,
              height: 4.h,
              decoration: BoxDecoration(
                color: appTheme.blueGray100,
                borderRadius: BorderRadius.circular(2.h),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Buscar por imagen',
              style: TextStyle(
                fontSize: 18.fSize,
                fontWeight: FontWeight.bold,
                color: appTheme.blueGray80001,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  icon: Icons.camera_alt,
                  label: 'Cámara',
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  label: 'Galería',
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        // Mostrar indicador de análisis
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Analizando imagen...'),
              ],
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        // Simular análisis de imagen (en producción, enviar a API de visión)
        // Por ahora, navegar a búsqueda con el nombre de la imagen
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          // Extraer palabras clave del nombre del archivo (simulación)
          final fileName = image.name.toLowerCase();
          String searchTerm = 'producto';

          // Detectar palabras clave comunes en nombres de archivos
          if (fileName.contains('skin') || fileName.contains('piel')) {
            searchTerm = 'skincare';
          } else if (fileName.contains('mask') ||
              fileName.contains('mascara')) {
            searchTerm = 'mascarilla';
          } else if (fileName.contains('cream') || fileName.contains('crema')) {
            searchTerm = 'crema';
          } else if (fileName.contains('serum')) {
            searchTerm = 'serum';
          }

          _performSearch(searchTerm);

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Mostrando resultados para: $searchTerm'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al obtener imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.h),
      child: Container(
        width: 100.h,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: appTheme.gray50,
          borderRadius: BorderRadius.circular(16.h),
          border: Border.all(color: appTheme.blueGray100),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40.h,
              color: appTheme.deepOrange400,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.fSize,
                color: appTheme.blueGray80001,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationPicker() {
    showDialog(
      context: context,
      builder: (dialogContext) => LocationPickerDialog(
        initialZipCode: _currentLocation,
        onLocationSelected: (zipCode, city) {
          setState(() {
            _currentLocation = zipCode;
          });

          if (city != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ubicación actualizada: $zipCode, $city'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }
}

/// Contenido del Home sin la navegación (para usar dentro del MainScreen)
class HomeScreenContent extends ConsumerWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usar el nuevo FibroHomeContent que sigue la estructura del sitio web
    return const FibroHomeContent();
  }
}
