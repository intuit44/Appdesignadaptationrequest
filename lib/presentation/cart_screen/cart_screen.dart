import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../data/repositories/shop_repository.dart';
import '../checkout_screen/checkout_screen.dart';

/// Pantalla del carrito de compras
/// Muestra los productos agregados y permite proceder al checkout
class CartScreen extends ConsumerStatefulWidget {
  /// Si es true, muestra el AppBar (para navegación standalone)
  /// Si es false, oculta el AppBar (cuando está embebido en MainScreen)
  final bool showAppBar;

  const CartScreen({
    super.key,
    this.showAppBar = false,
  });

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(localCartProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray50,
        appBar: widget.showAppBar ? _buildAppBar() : null,
        body: Column(
          children: [
            // Header cuando no hay AppBar (embebido en MainScreen)
            if (!widget.showAppBar) _buildEmbeddedHeader(),
            // Contenido principal
            Expanded(
              child: cartState.isLoading
                  ? _buildLoadingState()
                  : cartState.items.isEmpty
                      ? _buildEmptyCart()
                      : _buildCartContent(cartState),
            ),
          ],
        ),
        bottomNavigationBar:
            cartState.items.isNotEmpty ? _buildBottomBar(cartState) : null,
      ),
    );
  }

  /// Header para cuando el CartScreen está embebido en MainScreen
  Widget _buildEmbeddedHeader() {
    final hasItems = ref.watch(localCartProvider).items.isNotEmpty;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
      decoration: BoxDecoration(
        color: appTheme.whiteA700,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.shopping_cart,
            color: appTheme.deepOrange400,
            size: 24.h,
          ),
          SizedBox(width: 12.h),
          Text(
            'Mi Carrito',
            style: TextStyle(
              color: appTheme.blueGray80001,
              fontSize: 20.fSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (hasItems)
            TextButton.icon(
              onPressed: _clearCart,
              icon: Icon(Icons.delete_outline,
                  color: Colors.red.shade400, size: 18.h),
              label: Text(
                'Vaciar',
                style:
                    TextStyle(color: Colors.red.shade400, fontSize: 12.fSize),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.h),
              ),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final hasItems = ref.watch(localCartProvider).items.isNotEmpty;
    return AppBar(
      backgroundColor: appTheme.whiteA700,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: appTheme.blueGray80001),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Mi Carrito',
        style: TextStyle(
          color: appTheme.blueGray80001,
          fontSize: 18.fSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        if (hasItems)
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
            onPressed: _clearCart,
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: appTheme.deepOrange400),
          SizedBox(height: 16.h),
          Text(
            'Cargando carrito...',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.h),
              decoration: BoxDecoration(
                color: appTheme.gray10001,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 64.h,
                color: appTheme.blueGray600,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Tu carrito está vacío',
              style: TextStyle(
                fontSize: 20.fSize,
                fontWeight: FontWeight.w600,
                color: appTheme.blueGray80001,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Explora nuestra tienda y encuentra\nproductos increíbles',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.fSize,
                color: appTheme.blueGray600,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: 200.h,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  // Intentar navegar al tab 0 (Home con productos) si estamos en MainScreen
                  // Si no, hacer pop para volver a la pantalla anterior
                  final navigator = Navigator.of(context);
                  if (navigator.canPop()) {
                    navigator.pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.deepOrange400,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.h),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.store_outlined, size: 20.h),
                    SizedBox(width: 8.h),
                    Text(
                      'Explorar Tienda',
                      style: TextStyle(
                        fontSize: 16.fSize,
                        fontWeight: FontWeight.w600,
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

  Widget _buildCartContent(LocalCartState cartState) {
    return ListView.builder(
      padding: EdgeInsets.all(16.h),
      itemCount: cartState.items.length,
      itemBuilder: (context, index) {
        final item = cartState.items[index];
        return _buildCartItem(item);
      },
    );
  }

  Widget _buildCartItem(LocalCartItem item) {
    final product = item.product;
    final imageUrl =
        product.images.isNotEmpty ? product.images.first.src : null;
    final price = double.tryParse(product.price) ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: appTheme.whiteA700,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          ClipRRect(
            borderRadius: BorderRadius.circular(8.h),
            child: SizedBox(
              width: 80.h,
              height: 80.h,
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? ExtendedImage.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      cache: true,
                      loadStateChanged: (state) {
                        if (state.extendedImageLoadState == LoadState.loading) {
                          return Container(
                            color: appTheme.gray10001,
                            child: Center(
                              child: SizedBox(
                                width: 20.h,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: appTheme.deepOrange400,
                                ),
                              ),
                            ),
                          );
                        }
                        if (state.extendedImageLoadState == LoadState.failed) {
                          return _buildPlaceholderImage();
                        }
                        return null;
                      },
                    )
                  : _buildPlaceholderImage(),
            ),
          ),
          SizedBox(width: 12.h),
          // Info del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.fSize,
                    fontWeight: FontWeight.w600,
                    color: appTheme.blueGray80001,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.bold,
                    color: appTheme.deepOrange400,
                  ),
                ),
                SizedBox(height: 8.h),
                // Controles de cantidad
                Row(
                  children: [
                    _buildQuantityButton(
                      icon: Icons.remove,
                      onPressed: () {
                        if (item.quantity > 1) {
                          ref.read(localCartProvider.notifier).updateQuantity(
                                product.id,
                                item.quantity - 1,
                              );
                        }
                      },
                      enabled: item.quantity > 1,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.h),
                      child: Text(
                        '${item.quantity}',
                        style: TextStyle(
                          fontSize: 16.fSize,
                          fontWeight: FontWeight.w600,
                          color: appTheme.blueGray80001,
                        ),
                      ),
                    ),
                    _buildQuantityButton(
                      icon: Icons.add,
                      onPressed: () {
                        ref.read(localCartProvider.notifier).updateQuantity(
                              product.id,
                              item.quantity + 1,
                            );
                      },
                    ),
                    const Spacer(),
                    // Botón eliminar
                    IconButton(
                      onPressed: () => _removeItem(product.id, product.name),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red.shade400,
                        size: 22.h,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(6.h),
      child: Container(
        width: 32.h,
        height: 32.h,
        decoration: BoxDecoration(
          color: enabled
              ? appTheme.gray10001
              : appTheme.gray10001.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(6.h),
        ),
        child: Icon(
          icon,
          size: 18.h,
          color: enabled ? appTheme.blueGray80001 : appTheme.blueGray600,
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade200,
      child: Icon(
        Icons.shopping_bag_outlined,
        size: 30.h,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildBottomBar(LocalCartState cartState) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteA700,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Resumen
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal (${cartState.itemCount} items)',
                  style: TextStyle(
                    fontSize: 14.fSize,
                    color: appTheme.blueGray600,
                  ),
                ),
                Text(
                  '\$${cartState.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14.fSize,
                    color: appTheme.blueGray80001,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18.fSize,
                    fontWeight: FontWeight.bold,
                    color: appTheme.blueGray80001,
                  ),
                ),
                Text(
                  '\$${cartState.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20.fSize,
                    fontWeight: FontWeight.bold,
                    color: appTheme.deepOrange400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Botón checkout
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: _goToCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.deepOrange400,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.h),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 20.h),
                    SizedBox(width: 8.h),
                    Text(
                      'Proceder al Pago',
                      style: TextStyle(
                        fontSize: 16.fSize,
                        fontWeight: FontWeight.w600,
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

  void _removeItem(int productId, String productName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Eliminar "$productName" del carrito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(localCartProvider.notifier).removeFromCart(productId);
            },
            child: Text(
              'Eliminar',
              style: TextStyle(color: Colors.red.shade400),
            ),
          ),
        ],
      ),
    );
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vaciar carrito'),
        content: const Text('¿Estás seguro de que deseas vaciar el carrito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(localCartProvider.notifier).clearCart();
            },
            child: Text(
              'Vaciar',
              style: TextStyle(color: Colors.red.shade400),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goToCheckout() async {
    final cartState = ref.read(localCartProvider);

    if (cartState.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El carrito está vacío'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Navegar al checkout con los items del carrito
    // WooCommerce manejará el pago directamente en su sitio
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          cartItems: cartState.items,
          total: cartState.total,
        ),
      ),
    );
  }
}
