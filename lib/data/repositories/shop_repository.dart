import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/woocommerce_service.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

/// Estado para la tienda
class ShopState {
  final List<ProductModel> products;
  final List<ProductModel> featuredProducts;
  final List<ProductModel> saleProducts;
  final List<ProductCategory> categories;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final String? selectedCategory;

  const ShopState({
    this.products = const [],
    this.featuredProducts = const [],
    this.saleProducts = const [],
    this.categories = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
    this.selectedCategory,
  });

  ShopState copyWith({
    List<ProductModel>? products,
    List<ProductModel>? featuredProducts,
    List<ProductModel>? saleProducts,
    List<ProductCategory>? categories,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasMore,
    String? selectedCategory,
  }) {
    return ShopState(
      products: products ?? this.products,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      saleProducts: saleProducts ?? this.saleProducts,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

/// Estado del carrito
class CartState {
  final OrderModel? cart;
  final bool isLoading;
  final String? error;

  const CartState({
    this.cart,
    this.isLoading = false,
    this.error,
  });

  int get itemCount => cart?.lineItems.length ?? 0;

  double get total {
    final totalStr = cart?.total ?? '0';
    return double.tryParse(totalStr) ?? 0.0;
  }

  CartState copyWith({
    OrderModel? cart,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Repositorio de tienda
/// Gestiona productos, categorías y carrito
class ShopRepository extends StateNotifier<ShopState> {
  final WooCommerceService _wcService;
  final int _perPage;

  ShopRepository({
    WooCommerceService? wcService,
    int perPage = 20,
  })  : _wcService = wcService ?? WooCommerceService(),
        _perPage = perPage,
        super(const ShopState());

  /// Carga productos iniciales
  Future<void> loadProducts({
    bool refresh = false,
    String? category,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: refresh ? 1 : state.currentPage,
      products: refresh ? [] : state.products,
      selectedCategory: category,
    );

    try {
      final products = await _wcService.getProducts(
        page: 1,
        perPage: _perPage,
        category: category,
      );

      state = state.copyWith(
        products: products,
        isLoading: false,
        currentPage: 1,
        hasMore: products.length >= _perPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar productos: $e',
      );
    }
  }

  /// Carga más productos (paginación)
  Future<void> loadMoreProducts() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final moreProducts = await _wcService.getProducts(
        page: nextPage,
        perPage: _perPage,
        category: state.selectedCategory,
      );

      state = state.copyWith(
        products: [...state.products, ...moreProducts],
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: moreProducts.length >= _perPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: 'Error al cargar más productos: $e',
      );
    }
  }

  /// Carga productos destacados
  Future<void> loadFeaturedProducts() async {
    try {
      final featured = await _wcService.getFeaturedProducts(limit: 10);
      state = state.copyWith(featuredProducts: featured);
    } catch (e) {
      // Silenciar error
    }
  }

  /// Carga productos en oferta
  Future<void> loadSaleProducts() async {
    try {
      final sale = await _wcService.getSaleProducts(limit: 10);
      state = state.copyWith(saleProducts: sale);
    } catch (e) {
      // Silenciar error
    }
  }

  /// Carga categorías
  Future<void> loadCategories() async {
    try {
      final categories = await _wcService.getCategories();
      state = state.copyWith(categories: categories);
    } catch (e) {
      // Silenciar error
    }
  }

  /// Busca productos
  Future<List<ProductModel>> searchProducts(String query) async {
    if (query.isEmpty) return [];

    try {
      return await _wcService.getProducts(
        search: query,
        perPage: 30,
      );
    } catch (e) {
      return [];
    }
  }

  /// Obtiene un producto por ID
  Future<ProductModel?> getProductById(int id) async {
    // Buscar en caché
    final cached = state.products.where((p) => p.id == id).firstOrNull;
    if (cached != null) return cached;

    try {
      return await _wcService.getProductById(id);
    } catch (e) {
      return null;
    }
  }

  /// Filtra por categoría
  Future<void> filterByCategory(String? categorySlug) async {
    await loadProducts(refresh: true, category: categorySlug);
  }

  /// Refresca productos
  Future<void> refresh() => loadProducts(refresh: true);

  /// Limpia error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Repositorio del carrito
class CartRepository extends StateNotifier<CartState> {
  final WooCommerceService _wcService;
  int? _customerId;

  CartRepository({
    WooCommerceService? wcService,
  })  : _wcService = wcService ?? WooCommerceService(),
        super(const CartState());

  /// ID del cliente actual
  int? get customerId => _customerId;

  /// Inicializa el carrito para un cliente
  Future<void> initCart(int customerId) async {
    _customerId = customerId;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final cart = await _wcService.getOrCreateCart(customerId);
      state = state.copyWith(cart: cart, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar carrito: $e',
      );
    }
  }

  /// Agrega producto al carrito
  Future<bool> addToCart(int productId, {int quantity = 1}) async {
    if (state.cart == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedCart = await _wcService.addToCart(
        orderId: state.cart!.id,
        productId: productId,
        quantity: quantity,
      );

      if (updatedCart != null) {
        state = state.copyWith(cart: updatedCart, isLoading: false);
        return true;
      }

      state = state.copyWith(
        isLoading: false,
        error: 'No se pudo agregar al carrito',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al agregar al carrito: $e',
      );
      return false;
    }
  }

  /// Limpia el carrito
  void clearCart() {
    _customerId = null;
    state = const CartState();
  }

  /// Limpia error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider para ShopRepository
final shopRepositoryProvider =
    StateNotifierProvider<ShopRepository, ShopState>((ref) {
  return ShopRepository();
});

/// Provider para CartRepository
final cartRepositoryProvider =
    StateNotifierProvider<CartRepository, CartState>((ref) {
  return CartRepository();
});

/// Provider para productos
final productsProvider = Provider<List<ProductModel>>((ref) {
  return ref.watch(shopRepositoryProvider).products;
});

/// Provider para productos destacados
final featuredProductsProvider = Provider<List<ProductModel>>((ref) {
  return ref.watch(shopRepositoryProvider).featuredProducts;
});

/// Provider para productos en oferta
final saleProductsProvider = Provider<List<ProductModel>>((ref) {
  return ref.watch(shopRepositoryProvider).saleProducts;
});

/// Provider para categorías
final categoriesProvider = Provider<List<ProductCategory>>((ref) {
  return ref.watch(shopRepositoryProvider).categories;
});

/// Provider para un producto específico
final productByIdProvider =
    FutureProvider.family<ProductModel?, int>((ref, id) async {
  final repository = ref.watch(shopRepositoryProvider.notifier);
  return repository.getProductById(id);
});

/// Provider para búsqueda de productos
final productSearchProvider =
    FutureProvider.family<List<ProductModel>, String>((ref, query) async {
  final repository = ref.watch(shopRepositoryProvider.notifier);
  return repository.searchProducts(query);
});

/// Provider para cantidad de items en carrito
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartRepositoryProvider).itemCount;
});

/// Provider para total del carrito
final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartRepositoryProvider).total;
});
