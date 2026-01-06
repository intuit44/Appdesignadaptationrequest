import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../data/repositories/shop_repository.dart';

/// Controller para manejar búsquedas desde fuera del widget
class SearchController extends ChangeNotifier {
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}

/// Provider para el controller de búsqueda
final searchControllerProvider =
    ChangeNotifierProvider<SearchController>((ref) {
  return SearchController();
});

/// Pantalla de búsqueda de productos
class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;

  const SearchScreen({
    super.key,
    this.initialQuery,
  });

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late String _searchQuery;
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  final List<String> _recentSearches = [
    'Plasma Fibroblast',
    'Nanosoft',
    'Metaloterapia',
    'BioPen',
    'Cursos online',
  ];

  final List<String> _popularCategories = [
    'Equipos',
    'Cursos',
    'Tratamientos',
    'Membresías',
    'Accesorios',
  ];

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.initialQuery ?? '';
    _searchTextController.text = _searchQuery;
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios externos en la búsqueda
    final searchController = ref.watch(searchControllerProvider);
    if (searchController.searchQuery.isNotEmpty &&
        searchController.searchQuery != _searchQuery) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _searchQuery = searchController.searchQuery;
          _searchTextController.text = _searchQuery;
        });
        // Limpiar después de usar
        ref.read(searchControllerProvider).clearSearch();
      });
    }

    final shopState = ref.watch(shopRepositoryProvider);
    final products = shopState.products;

    // Filtrar productos por búsqueda
    final filteredProducts = _searchQuery.isEmpty
        ? products
        : products
            .where((p) =>
                p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                (p.description
                        ?.toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ??
                    false))
            .toList();

    return Scaffold(
      backgroundColor: appTheme.gray50,
      body: Column(
        children: [
          // Barra de búsqueda integrada
          _buildSearchBar(),
          // Contenido
          Expanded(
            child: _searchQuery.isEmpty && filteredProducts.isEmpty
                ? _buildSearchSuggestions()
                : _buildSearchResults(filteredProducts),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
      color: Colors.white,
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: appTheme.gray50,
          borderRadius: BorderRadius.circular(8.h),
          border: Border.all(color: appTheme.blueGray100),
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
                controller: _searchTextController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Buscar productos, cursos...',
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
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty && !_recentSearches.contains(value)) {
                    setState(() {
                      _recentSearches.insert(0, value);
                      if (_recentSearches.length > 10) {
                        _recentSearches.removeLast();
                      }
                    });
                  }
                },
              ),
            ),
            if (_searchQuery.isNotEmpty)
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: appTheme.blueGray600,
                  size: 20.h,
                ),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _searchTextController.clear();
                  });
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: 40.h,
                  minHeight: 40.h,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Búsquedas recientes
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Búsquedas recientes',
                  style: TextStyle(
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.bold,
                    color: appTheme.blueGray80001,
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _recentSearches.clear()),
                  child: Text(
                    'Limpiar',
                    style: TextStyle(
                      color: appTheme.deepOrange400,
                      fontSize: 14.fSize,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.h,
              runSpacing: 8.h,
              children: _recentSearches
                  .map((search) => _buildSearchChip(search, Icons.history))
                  .toList(),
            ),
            SizedBox(height: 24.h),
          ],

          // Categorías populares
          Text(
            'Categorías populares',
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.bold,
              color: appTheme.blueGray80001,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.h,
            runSpacing: 8.h,
            children: _popularCategories
                .map((category) =>
                    _buildSearchChip(category, Icons.category_outlined))
                .toList(),
          ),
          SizedBox(height: 24.h),

          // Ofertas destacadas
          Text(
            'Ofertas destacadas',
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.bold,
              color: appTheme.blueGray80001,
            ),
          ),
          SizedBox(height: 12.h),
          _buildFeaturedDeals(),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String label, IconData icon) {
    return InkWell(
      onTap: () => setState(() => _searchQuery = label),
      borderRadius: BorderRadius.circular(20.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.h),
          border: Border.all(color: appTheme.blueGray100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.h, color: appTheme.blueGray600),
            SizedBox(width: 6.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.fSize,
                color: appTheme.blueGray80001,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedDeals() {
    final shopState = ref.watch(shopRepositoryProvider);
    final saleProducts =
        shopState.products.where((p) => p.onSale).take(4).toList();

    if (saleProducts.isEmpty) {
      return Container(
        padding: EdgeInsets.all(32.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Center(
          child: Text(
            'No hay ofertas disponibles',
            style: TextStyle(
              color: appTheme.blueGray600,
              fontSize: 14.fSize,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 180.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: saleProducts.length,
        itemBuilder: (context, index) {
          final product = saleProducts[index];
          final imageUrl =
              product.images.isNotEmpty ? product.images.first.src : null;

          return GestureDetector(
            onTap: () {
              // Navegar a detalle del producto
              AppRoutes.navigateToProductDetail(context, product);
            },
            child: Container(
              width: 140.h,
              margin: EdgeInsets.only(right: 12.h),
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
                  // Badge de descuento
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12.h)),
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                height: 100.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                      ),
                      Positioned(
                        top: 8.h,
                        left: 8.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.h, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4.h),
                          ),
                          child: Text(
                            'OFERTA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.fSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.fSize,
                            color: appTheme.blueGray80001,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '\$${product.price}',
                          style: TextStyle(
                            fontSize: 14.fSize,
                            fontWeight: FontWeight.bold,
                            color: appTheme.deepOrange400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 100.h,
      color: appTheme.gray100,
      child: Icon(
        Icons.image_outlined,
        size: 40.h,
        color: appTheme.blueGray100,
      ),
    );
  }

  Widget _buildSearchResults(List<dynamic> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64.h,
              color: appTheme.blueGray100,
            ),
            SizedBox(height: 16.h),
            Text(
              'No se encontraron resultados',
              style: TextStyle(
                fontSize: 16.fSize,
                color: appTheme.blueGray600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Intenta con otra búsqueda',
              style: TextStyle(
                fontSize: 14.fSize,
                color: appTheme.blueGray100,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(12.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.h,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.7,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(dynamic product) {
    final imageUrl =
        product.images.isNotEmpty ? product.images.first.src : null;

    return InkWell(
      onTap: () {
        // Navegar a detalle del producto
        AppRoutes.navigateToProductDetail(context, product);
      },
      borderRadius: BorderRadius.circular(12.h),
      child: Container(
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
            // Imagen
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.h)),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.fSize,
                        color: appTheme.blueGray80001,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${product.price}',
                      style: TextStyle(
                        fontSize: 16.fSize,
                        fontWeight: FontWeight.bold,
                        color: appTheme.deepOrange400,
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
