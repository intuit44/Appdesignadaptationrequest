import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/app_export.dart';
import '../data/models/product_model.dart';

/// Widget de tarjeta de producto para mostrar productos de WooCommerce
class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const ProductCardWidget({
    super.key,
    required this.product,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 160.h,
        decoration: BoxDecoration(
          color: appTheme.whiteA700,
          borderRadius: BorderRadius.circular(10.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.h)),
              child: _buildProductImage(),
            ),
            // Información del producto
            Padding(
              padding: EdgeInsets.all(10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del producto
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.titleSmallGray90001,
                  ),
                  SizedBox(height: 6.h),
                  // Precio
                  _buildPriceRow(),
                  SizedBox(height: 4.h),
                  // Rating si existe
                  if (product.ratingCount > 0) _buildRating(),
                  // Badge de oferta
                  if (product.onSale) _buildSaleBadge(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    final imageUrl =
        product.images.isNotEmpty ? product.images.first.src : null;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        height: height ?? 140.h,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: height ?? 140.h,
          color: Colors.grey.shade200,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: appTheme.deepOrange400,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: height ?? 140.h,
          color: Colors.grey.shade200,
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 40.h,
            color: Colors.grey.shade400,
          ),
        ),
      );
    }

    return Container(
      height: height ?? 140.h,
      color: Colors.grey.shade200,
      child: Icon(
        Icons.shopping_bag_outlined,
        size: 40.h,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildPriceRow() {
    final hasDiscount = product.onSale &&
        product.regularPrice != null &&
        product.regularPrice!.isNotEmpty;

    return Row(
      children: [
        Text(
          '\$${product.price}',
          style: TextStyle(
            fontSize: 16.fSize,
            fontWeight: FontWeight.bold,
            color: appTheme.deepOrange400,
          ),
        ),
        if (hasDiscount) ...[
          SizedBox(width: 6.h),
          Text(
            '\$${product.regularPrice}',
            style: TextStyle(
              fontSize: 12.fSize,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRating() {
    final rating = double.tryParse(product.averageRating) ?? 0;
    return Row(
      children: [
        Icon(
          Icons.star,
          size: 14.h,
          color: Colors.amber,
        ),
        SizedBox(width: 4.h),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 12.fSize,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          ' (${product.ratingCount})',
          style: TextStyle(
            fontSize: 10.fSize,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildSaleBadge() {
    return Container(
      margin: EdgeInsets.only(top: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(4.h),
      ),
      child: Text(
        'OFERTA',
        style: TextStyle(
          fontSize: 10.fSize,
          color: Colors.red.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Widget compacto para listas horizontales
class ProductCardCompact extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCardCompact({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.h,
        margin: EdgeInsets.only(right: 12.h),
        decoration: BoxDecoration(
          color: appTheme.whiteA700,
          borderRadius: BorderRadius.circular(8.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.h)),
              child: _buildImage(),
            ),
            // Info
            Padding(
              padding: EdgeInsets.all(8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.fSize,
                      fontWeight: FontWeight.w500,
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
  }

  Widget _buildImage() {
    final imageUrl =
        product.images.isNotEmpty ? product.images.first.src : null;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        height: 100.h,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 100.h,
          color: Colors.grey.shade200,
        ),
        errorWidget: (context, url, error) => Container(
          height: 100.h,
          color: Colors.grey.shade200,
          child: Icon(Icons.image, color: Colors.grey.shade400),
        ),
      );
    }

    return Container(
      height: 100.h,
      color: Colors.grey.shade200,
      child: Icon(Icons.shopping_bag, color: Colors.grey.shade400),
    );
  }
}
