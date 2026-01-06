import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/woocommerce_service.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

/// Item del carrito local
class LocalCartItem {
  final ProductModel product;
  final int quantity;

  const LocalCartItem({
    required this.product,
    this.quantity = 1,
  });

  double get subtotal => (double.tryParse(product.price) ?? 0) * quantity;

  LocalCartItem copyWith({int? quantity}) {
    return LocalCartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// Estado del carrito local (sin depender de API)
class LocalCartState {
  final List<LocalCartItem> items;
  final bool isLoading;
  final String? error;

  const LocalCartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get total => items.fold(0.0, (sum, item) => sum + item.subtotal);

  LocalCartState copyWith({
    List<LocalCartItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return LocalCartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Estado para la tienda
class ShopState {
  final List<ProductModel> products;
  final List<ProductModel> featuredProducts;
  final List<ProductModel> saleProducts;
  final List<ProductCategory> categories;
  final List<OrderModel> orders;
  final List<ProductModel> wishlist;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isLoadingOrders;
  final bool isLoadingWishlist;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final String? selectedCategory;

  const ShopState({
    this.products = const [],
    this.featuredProducts = const [],
    this.saleProducts = const [],
    this.categories = const [],
    this.orders = const [],
    this.wishlist = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isLoadingOrders = false,
    this.isLoadingWishlist = false,
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
    List<OrderModel>? orders,
    List<ProductModel>? wishlist,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isLoadingOrders,
    bool? isLoadingWishlist,
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
      orders: orders ?? this.orders,
      wishlist: wishlist ?? this.wishlist,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadingOrders: isLoadingOrders ?? this.isLoadingOrders,
      isLoadingWishlist: isLoadingWishlist ?? this.isLoadingWishlist,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      selectedCategory: selectedCategory ?? this.selectedCategory,
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

  // ============ ORDERS ============

  /// Carga los pedidos del usuario
  Future<void> loadOrders({int? customerId}) async {
    if (state.isLoadingOrders) return;

    state = state.copyWith(isLoadingOrders: true, error: null);

    try {
      final orders = await _wcService.getOrders(customerId: customerId);
      state = state.copyWith(
        orders: orders,
        isLoadingOrders: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingOrders: false,
        error: 'Error al cargar pedidos: $e',
      );
    }
  }

  // ============ WISHLIST ============

  /// Carga la lista de deseos (desde almacenamiento local)
  Future<void> loadWishlist() async {
    if (state.isLoadingWishlist) return;

    state = state.copyWith(isLoadingWishlist: true);

    // La wishlist se maneja localmente, inicializar vacía si no hay datos
    await Future.delayed(const Duration(milliseconds: 100));
    state = state.copyWith(isLoadingWishlist: false);
  }

  /// Agrega un producto a la wishlist
  void addToWishlist(ProductModel product) {
    if (state.wishlist.any((p) => p.id == product.id)) return;

    state = state.copyWith(
      wishlist: [...state.wishlist, product],
    );
  }

  /// Elimina un producto de la wishlist
  void removeFromWishlist(int productId) {
    state = state.copyWith(
      wishlist: state.wishlist.where((p) => p.id != productId).toList(),
    );
  }

  /// Verifica si un producto está en la wishlist
  bool isInWishlist(int productId) {
    return state.wishlist.any((p) => p.id == productId);
  }

  /// Limpia toda la wishlist
  void clearWishlist() {
    state = state.copyWith(wishlist: []);
  }
}

/// Repositorio del carrito LOCAL
/// Maneja el carrito en memoria sin depender de API
class LocalCartRepository extends StateNotifier<LocalCartState> {
  final WooCommerceService _wcService;

  LocalCartRepository({
    WooCommerceService? wcService,
  })  : _wcService = wcService ?? WooCommerceService(),
        super(const LocalCartState());

  /// Agrega producto al carrito
  void addToCart(ProductModel product, {int quantity = 1}) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Producto ya existe, actualizar cantidad
      final updatedItems = List<LocalCartItem>.from(state.items);
      final existing = updatedItems[existingIndex];
      updatedItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      // Nuevo producto
      state = state.copyWith(
        items: [
          ...state.items,
          LocalCartItem(product: product, quantity: quantity)
        ],
      );
    }
  }

  /// Actualiza cantidad de un producto
  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  /// Elimina producto del carrito
  void removeFromCart(int productId) {
    final updatedItems =
        state.items.where((item) => item.product.id != productId).toList();
    state = state.copyWith(items: updatedItems);
  }

  /// Limpia el carrito
  void clearCart() {
    state = const LocalCartState();
  }

  /// Crea orden en WooCommerce para checkout
  Future<OrderModel?> createOrderForCheckout() async {
    if (state.items.isEmpty) return null;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // WooCommerce solo necesita product_id y quantity para crear la orden
      // Los precios son calculados automáticamente por WooCommerce
      final lineItems = state.items
          .map((item) => OrderLineItem(
                id: 0,
                name: item.product.name,
                productId: item.product.id,
                quantity: item.quantity,
                subtotal: '0', // WooCommerce lo calcula
                total: '0', // WooCommerce lo calcula
              ))
          .toList();

      final order = await _wcService.createOrder(
        customerId:
            0, // Guest checkout - WooCommerce asigna por email si existe
        lineItems: lineItems,
      );

      if (order != null) {
        state = state.copyWith(isLoading: false);
        return order;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'No se pudo crear la orden',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al crear orden: $e',
      );
      return null;
    }
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

/// Provider para LocalCartRepository
final localCartProvider =
    StateNotifierProvider<LocalCartRepository, LocalCartState>((ref) {
  return LocalCartRepository();
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
  return ref.watch(localCartProvider).itemCount;
});

/// Provider para total del carrito
final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(localCartProvider).total;
});
