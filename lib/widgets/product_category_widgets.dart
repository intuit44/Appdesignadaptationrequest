import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

import '../core/app_export.dart';

/// Widget que muestra una categoría de producto en formato de tarjeta
class ProductCategoryCard extends StatelessWidget {
  final ProductCategoryInfo category;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const ProductCategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 140.h,
        height: height ?? 160.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.h),
          boxShadow: [
            BoxShadow(
              color: category.color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.h),
          child: Stack(
            children: [
              // Imagen de fondo o gradiente
              Positioned.fill(
                child: category.imageUrl != null
                    ? ExtendedImage.network(
                        category.imageUrl!,
                        fit: BoxFit.cover,
                        cache: true,
                        loadStateChanged: (ExtendedImageState state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              return Container(
                                color: category.color.withValues(alpha: 0.1),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: category.color,
                                  ),
                                ),
                              );
                            case LoadState.failed:
                              return Container(
                                color: category.color.withValues(alpha: 0.1),
                                child: Icon(
                                  category.icon,
                                  size: 40.h,
                                  color: category.color,
                                ),
                              );
                            case LoadState.completed:
                              return null;
                          }
                        },
                      )
                    : Container(
                        color: category.color.withValues(alpha: 0.1),
                      ),
              ),
              // Overlay para legibilidad
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // Contenido
              Positioned(
                left: 12.h,
                right: 12.h,
                bottom: 12.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icono pequeño
                    Container(
                      width: 32.h,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: category.color,
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                      child: Icon(
                        category.icon,
                        size: 18.h,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Nombre de la categoría
                    Text(
                      category.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.fSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // Subtítulo
                    Text(
                      category.subtitle,
                      style: TextStyle(
                        fontSize: 11.fSize,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget que muestra una lista horizontal de categorías de productos
class ProductCategoriesRow extends StatelessWidget {
  final List<ProductCategoryInfo>? categories;
  final Function(ProductCategoryInfo)? onCategoryTap;
  final String? title;

  const ProductCategoriesRow({
    super.key,
    this.categories,
    this.onCategoryTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final items = categories ?? FibroProductCategories.categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 18.fSize,
                    fontWeight: FontWeight.bold,
                    color: appTheme.blueGray80001,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navegar a pantalla de todas las categorías
                    Navigator.pushNamed(
                        context, AppRoutes.productCategoriesScreen);
                  },
                  child: Text(
                    'Ver todo',
                    style: TextStyle(
                      fontSize: 14.fSize,
                      color: appTheme.deepOrange400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        SizedBox(
          height: 170.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.h),
            itemBuilder: (context, index) {
              final category = items[index];
              return ProductCategoryCard(
                category: category,
                onTap: () => onCategoryTap?.call(category),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Widget compacto de categoría de producto (para grid)
class ProductCategoryChip extends StatelessWidget {
  final ProductCategoryInfo category;
  final bool isSelected;
  final VoidCallback? onTap;

  const ProductCategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color
              : category.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20.h),
          border: Border.all(
            color: category.color.withValues(alpha: isSelected ? 1 : 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 18.h,
              color: isSelected ? Colors.white : category.color,
            ),
            SizedBox(width: 8.h),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 13.fSize,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : appTheme.blueGray80001,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid de categorías de productos
class ProductCategoriesGrid extends StatelessWidget {
  final List<ProductCategoryInfo>? categories;
  final Function(ProductCategoryInfo)? onCategoryTap;
  final String? selectedCategoryId;

  const ProductCategoriesGrid({
    super.key,
    this.categories,
    this.onCategoryTap,
    this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    final items = categories ?? FibroProductCategories.categories;

    return GridView.builder(
      padding: EdgeInsets.all(16.h),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.h,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final category = items[index];
        return ProductCategoryCard(
          category: category,
          onTap: () => onCategoryTap?.call(category),
        );
      },
    );
  }
}
