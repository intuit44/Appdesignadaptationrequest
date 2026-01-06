import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../data/repositories/shop_repository.dart';
import '../../data/models/product_model.dart';

/// Pantalla de Lista de Deseos / Favoritos
/// Muestra los productos guardados por el usuario
class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shopRepositoryProvider.notifier).loadWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopRepositoryProvider);
    final wishlist = shopState.wishlist;

    return Scaffold(
      backgroundColor: appTheme.gray50,
      appBar: AppBar(
        title: const Text('Lista de Deseos'),
        backgroundColor: FibroColors.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (wishlist.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => _showClearDialog(context),
            ),
        ],
      ),
      body: shopState.isLoadingWishlist
          ? const Center(child: CircularProgressIndicator())
          : wishlist.isEmpty
              ? _buildEmptyState()
              : _buildWishlistGrid(wishlist),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 80.h,
            color: appTheme.blueGray600,
          ),
          SizedBox(height: 16.h),
          Text(
            'Tu lista de deseos está vacía',
            style: TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.w600,
              color: appTheme.blueGray80001,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Guarda productos que te interesen',
            style: TextStyle(
              fontSize: 14.fSize,
              color: appTheme.blueGray600,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              NavigatorService.pushNamed(AppRoutes.productCategoriesScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FibroColors.primaryOrange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 12.h),
            ),
            child: const Text('Explorar Productos'),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistGrid(List<ProductModel> wishlist) {
    return GridView.builder(
      padding: EdgeInsets.all(16.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.h,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.7,
      ),
      itemCount: wishlist.length,
      itemBuilder: (context, index) {
        return _WishlistCard(
          product: wishlist[index],
          onRemove: () => _removeFromWishlist(wishlist[index]),
          onTap: () => _navigateToProduct(wishlist[index]),
        );
      },
    );
  }

  void _removeFromWishlist(ProductModel product) {
    ref.read(shopRepositoryProvider.notifier).removeFromWishlist(product.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} eliminado de favoritos'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            ref.read(shopRepositoryProvider.notifier).addToWishlist(product);
          },
        ),
      ),
    );
  }

  void _navigateToProduct(ProductModel product) {
    AppRoutes.navigateToProductDetail(context, product);
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vaciar Lista'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar todos los productos de tu lista de deseos?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(shopRepositoryProvider.notifier).clearWishlist();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar Todo'),
          ),
        ],
      ),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _WishlistCard({
    required this.product,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen con botón de eliminar
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12.h)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: product.mainImage != null &&
                            product.mainImage!.isNotEmpty
                        ? Image.network(
                            product.mainImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: appTheme.gray100,
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 40.h,
                                color: appTheme.blueGray600,
                              ),
                            ),
                          )
                        : Container(
                            color: appTheme.gray100,
                            child: Icon(
                              Icons.image_outlined,
                              size: 40.h,
                              color: appTheme.blueGray600,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.h,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      padding: EdgeInsets.all(6.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 18.h,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Info del producto
            Padding(
              padding: EdgeInsets.all(10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 13.fSize,
                      fontWeight: FontWeight.w600,
                      color: appTheme.blueGray80001,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      fontSize: 15.fSize,
                      fontWeight: FontWeight.bold,
                      color: FibroColors.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
