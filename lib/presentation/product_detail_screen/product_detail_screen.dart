import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/shop_repository.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';

/// Pantalla de detalle de producto WooCommerce
/// Flujo: ProductCard → onTap → ProductDetailScreen(productId) → Carrito → Checkout
class ProductDetailScreen extends ConsumerStatefulWidget {
  final int productId;
  final ProductModel? product; // Opcional: si ya tenemos el producto

  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.product,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  ProductModel? _product;
  bool _isLoading = true;
  String? _error;
  int _quantity = 1;
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _product = widget.product;
      _isLoading = false;
    } else {
      _loadProduct();
    }
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final product = await ref
          .read(shopRepositoryProvider.notifier)
          .getProductById(widget.productId);
      if (mounted) {
        setState(() {
          _product = product;
          _isLoading = false;
          if (product == null) {
            _error = 'Producto no encontrado';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Error al cargar el producto';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: _buildAppBar(context),
        body: _buildBody(),
        bottomNavigationBar: _product != null ? _buildBottomBar() : null,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 20.h),
        onTap: () => Navigator.pop(context),
      ),
      title: AppbarTitle(
        text: _product?.name ?? 'Producto',
        margin: EdgeInsets.only(left: 8.h),
      ),
      styleType: Style.bgFill,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: appTheme.deepOrange400),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60.h, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(_error!, style: TextStyle(color: Colors.grey.shade600)),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadProduct,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_product == null) {
      return const Center(child: Text('Producto no disponible'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageGallery(),
          Padding(
            padding: EdgeInsets.all(16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductInfo(),
                SizedBox(height: 20.h),
                _buildPriceSection(),
                SizedBox(height: 20.h),
                _buildQuantitySelector(),
                SizedBox(height: 20.h),
                _buildDescription(),
                if (_product!.attributes.isNotEmpty) ...[
                  SizedBox(height: 20.h),
                  _buildAttributes(),
                ],
                SizedBox(height: 100.h), // Espacio para bottom bar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = _product!.images;
    if (images.isEmpty) {
      return Container(
        height: 300.h,
        color: Colors.grey.shade200,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 80.h,
            color: Colors.grey.shade400,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Imagen principal
        Container(
          height: 300.h,
          width: double.infinity,
          color: Colors.grey.shade100,
          child: ExtendedImage.network(
            images[_selectedImageIndex].src ?? '',
            fit: BoxFit.contain,
            cache: true,
            loadStateChanged: (state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: appTheme.deepOrange400,
                    ),
                  );
                case LoadState.failed:
                  return Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 60.h,
                      color: Colors.grey.shade400,
                    ),
                  );
                case LoadState.completed:
                  return null;
              }
            },
          ),
        ),
        // Miniaturas
        if (images.length > 1)
          Container(
            height: 80.h,
            margin: EdgeInsets.only(top: 10.h),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedImageIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedImageIndex = index),
                  child: Container(
                    width: 70.h,
                    margin: EdgeInsets.only(right: 8.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? appTheme.deepOrange400
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7.h),
                      child: ExtendedImage.network(
                        images[index].src ?? '',
                        fit: BoxFit.cover,
                        cache: true,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nombre
        Text(
          _product!.name,
          style: TextStyle(
            fontSize: 22.fSize,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        // SKU y Stock
        Row(
          children: [
            if (_product!.sku != null && _product!.sku!.isNotEmpty)
              Text(
                'SKU: ${_product!.sku}',
                style: TextStyle(
                  fontSize: 12.fSize,
                  color: Colors.grey.shade600,
                ),
              ),
            if (_product!.sku != null && _product!.sku!.isNotEmpty)
              SizedBox(width: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
              decoration: BoxDecoration(
                color: _product!.inStock
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(4.h),
              ),
              child: Text(
                _product!.inStock ? 'En Stock' : 'Agotado',
                style: TextStyle(
                  fontSize: 12.fSize,
                  color: _product!.inStock ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        // Rating
        if (_product!.ratingCount > 0) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < _product!.rating.round()
                      ? Icons.star
                      : Icons.star_border,
                  size: 18.h,
                  color: Colors.amber,
                );
              }),
              SizedBox(width: 8.h),
              Text(
                '${_product!.averageRating} (${_product!.ratingCount} reseñas)',
                style: TextStyle(
                  fontSize: 12.fSize,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPriceSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '\$${_product!.price}',
          style: TextStyle(
            fontSize: 28.fSize,
            fontWeight: FontWeight.bold,
            color: appTheme.deepOrange400,
          ),
        ),
        if (_product!.hasDiscount && _product!.regularPrice != null) ...[
          SizedBox(width: 12.h),
          Text(
            '\$${_product!.regularPrice}',
            style: TextStyle(
              fontSize: 18.fSize,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          SizedBox(width: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(4.h),
            ),
            child: Text(
              '-${_product!.discountPercent}%',
              style: TextStyle(
                fontSize: 12.fSize,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        Text(
          'Cantidad:',
          style: TextStyle(
            fontSize: 16.fSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 16.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.h),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed:
                    _quantity > 1 ? () => setState(() => _quantity--) : null,
                color: appTheme.deepOrange400,
              ),
              Container(
                width: 50.h,
                alignment: Alignment.center,
                child: Text(
                  '$_quantity',
                  style: TextStyle(
                    fontSize: 18.fSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => _quantity++),
                color: appTheme.deepOrange400,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    final description = _product!.shortDescription ?? _product!.description;
    if (description == null || description.isEmpty) {
      return const SizedBox.shrink();
    }

    // Remover HTML básico
    final cleanDescription = description
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción',
          style: TextStyle(
            fontSize: 18.fSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          cleanDescription,
          style: TextStyle(
            fontSize: 14.fSize,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAttributes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Especificaciones',
          style: TextStyle(
            fontSize: 18.fSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        ..._product!.attributes.map((attr) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120.h,
                    child: Text(
                      '${attr.name}:',
                      style: TextStyle(
                        fontSize: 14.fSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      attr.options.join(', '),
                      style: TextStyle(
                        fontSize: 14.fSize,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildBottomBar() {
    final cartState = ref.watch(cartRepositoryProvider);
    final isInStock = _product?.inStock ?? false;

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteA700,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Total
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12.fSize,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    '\$${(double.tryParse(_product!.price) ?? 0) * _quantity}',
                    style: TextStyle(
                      fontSize: 20.fSize,
                      fontWeight: FontWeight.bold,
                      color: appTheme.deepOrange400,
                    ),
                  ),
                ],
              ),
            ),
            // Botón agregar al carrito
            Expanded(
              flex: 2,
              child: CustomElevatedButton(
                text: cartState.isLoading
                    ? 'Agregando...'
                    : isInStock
                        ? 'Agregar al Carrito'
                        : 'No Disponible',
                buttonStyle: isInStock
                    ? CustomButtonStyles.fillBlack
                    : CustomButtonStyles.fillWhiteA,
                onPressed: isInStock && !cartState.isLoading
                    ? () => _addToCart()
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart() async {
    if (_product == null) return;

    try {
      await ref.read(cartRepositoryProvider.notifier).addToCart(
            _product!.id,
            quantity: _quantity,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_product!.name} agregado al carrito'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Ver Carrito',
              textColor: Colors.white,
              onPressed: () {
                // TODO: Navegar al carrito
                // NavigatorService.pushNamed(AppRoutes.cartScreen);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al agregar al carrito: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
