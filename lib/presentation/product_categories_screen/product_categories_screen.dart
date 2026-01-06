import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../data/repositories/shop_repository.dart';
import '../../widgets/product_card_widget.dart';

/// Pantalla de todas las categorías de productos
class ProductCategoriesScreen extends ConsumerStatefulWidget {
  final String? initialCategoryId;

  const ProductCategoriesScreen({
    super.key,
    this.initialCategoryId,
  });

  @override
  ConsumerState<ProductCategoriesScreen> createState() =>
      _ProductCategoriesScreenState();
}

class _ProductCategoriesScreenState
    extends ConsumerState<ProductCategoriesScreen> {
  String? _selectedCategoryId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;

    // Cargar productos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shopRepositoryProvider.notifier).loadProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopRepositoryProvider);
    final allProducts = shopState.products;

    // Filtrar productos por categoría si hay una seleccionada
    final filteredProducts = _selectedCategoryId == null
        ? allProducts
        : allProducts.where((p) {
            // Verificar si el producto pertenece a la categoría
            return p.categories.any((c) =>
                c.slug == _selectedCategoryId ||
                c.name.toLowerCase() ==
                    (_getCategoryName(_selectedCategoryId!) ?? '')
                        .toLowerCase());
          }).toList();

    return Scaffold(
      backgroundColor: appTheme.gray50,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Filtro de categorías horizontal
          _buildCategoryFilter(),
          // Lista de productos
          Expanded(
            child: _buildProductsGrid(filteredProducts, shopState.isLoading),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: appTheme.deepOrange400,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        _selectedCategoryId != null
            ? _getCategoryName(_selectedCategoryId!) ?? 'Productos'
            : 'Todas las Categorías',
        style: TextStyle(
          fontSize: 18.fSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // Volver a MainScreen en tab de búsqueda
            Navigator.of(context).pop();
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.cartScreen);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    final categories = FibroProductCategories.categories;

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
              itemCount: categories.length + 1, // +1 para "Todos"
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Opción "Todos"
                  return _buildCategoryChip(
                    id: null,
                    name: 'Todos',
                    icon: Icons.grid_view,
                    color: appTheme.blueGray600,
                    isSelected: _selectedCategoryId == null,
                  );
                }

                final category = categories[index - 1];
                return _buildCategoryChip(
                  id: category.id,
                  name: category.name,
                  icon: category.icon,
                  color: category.color,
                  isSelected: _selectedCategoryId == category.id,
                );
              },
            ),
          ),
          Divider(height: 1, color: appTheme.blueGray100),
        ],
      ),
    );
  }

  Widget _buildCategoryChip({
    required String? id,
    required String name,
    required IconData icon,
    required Color color,
    required bool isSelected,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.h),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.h,
              color: isSelected ? Colors.white : color,
            ),
            SizedBox(width: 6.h),
            Text(
              name,
              style: TextStyle(
                fontSize: 12.fSize,
                color: isSelected ? Colors.white : appTheme.blueGray80001,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        selectedColor: color,
        checkmarkColor: Colors.white,
        showCheckmark: false,
        side: BorderSide(
          color: isSelected ? color : appTheme.blueGray100,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.h),
        ),
        onSelected: (_) {
          setState(() {
            _selectedCategoryId = id;
          });
        },
      ),
    );
  }

  Widget _buildProductsGrid(List products, bool isLoading) {
    if (isLoading && products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: appTheme.deepOrange400,
            ),
            SizedBox(height: 16.h),
            Text(
              'Cargando productos...',
              style: TextStyle(
                color: appTheme.blueGray600,
                fontSize: 14.fSize,
              ),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80.h,
              color: appTheme.blueGray100,
            ),
            SizedBox(height: 16.h),
            Text(
              _selectedCategoryId != null
                  ? 'No hay productos en esta categoría'
                  : 'No hay productos disponibles',
              style: TextStyle(
                fontSize: 16.fSize,
                color: appTheme.blueGray600,
              ),
            ),
            SizedBox(height: 8.h),
            if (_selectedCategoryId != null)
              TextButton(
                onPressed: () {
                  setState(() => _selectedCategoryId = null);
                },
                child: Text(
                  'Ver todos los productos',
                  style: TextStyle(
                    color: appTheme.deepOrange400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.h,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCardWidget(
          product: product,
          onTap: () {
            // Navegar a detalle del producto
            AppRoutes.navigateToProductDetail(context, product);
          },
        );
      },
    );
  }

  String? _getCategoryName(String categoryId) {
    final category = FibroProductCategories.categories
        .where((c) => c.id == categoryId)
        .firstOrNull;
    return category?.name;
  }
}

/// Pantalla de productos filtrados por categoría (acceso directo)
class ProductsByCategoryScreen extends ConsumerWidget {
  final ProductCategoryInfo category;

  const ProductsByCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProductCategoriesScreen(initialCategoryId: category.id);
  }
}
