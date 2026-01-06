import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

import '../core/app_export.dart';

/// Widget que muestra una categoría de curso en formato de tarjeta grande
class CourseCategoryCard extends StatelessWidget {
  final CourseCategoryInfo category;
  final VoidCallback? onTap;
  final bool showCourseCount;

  const CourseCategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.showCourseCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.h),
          boxShadow: [
            BoxShadow(
              color: category.color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.h),
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
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      category.color,
                                      category.color.withValues(alpha: 0.8),
                                    ],
                                  ),
                                ),
                              );
                            case LoadState.failed:
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      category.color,
                                      category.color.withValues(alpha: 0.8),
                                    ],
                                  ),
                                ),
                              );
                            case LoadState.completed:
                              return null; // Usa la imagen cargada
                          }
                        },
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              category.color,
                              category.color.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                      ),
              ),
              // Overlay oscuro para legibilidad
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
              ),
              // Contenido
              Padding(
                padding: EdgeInsets.all(20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Icono
                    Container(
                      width: 50.h,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: category.color.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12.h),
                      ),
                      child: Icon(
                        category.icon,
                        size: 28.h,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Nombre
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 18.fSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Subtítulo
                    Text(
                      category.subtitle,
                      style: TextStyle(
                        fontSize: 13.fSize,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const Spacer(),
                    // Contador de cursos y flecha
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (showCourseCount)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.h,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20.h),
                            ),
                            child: Text(
                              '${category.courses.length} cursos',
                              style: TextStyle(
                                fontSize: 12.fSize,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        Container(
                          width: 36.h,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 18.h,
                            color: category.color,
                          ),
                        ),
                      ],
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

/// Widget que muestra una lista horizontal de categorías de cursos
class CourseCategoriesCarousel extends StatelessWidget {
  final List<CourseCategoryInfo>? categories;
  final Function(CourseCategoryInfo)? onCategoryTap;
  final String? title;
  final String? subtitle;

  const CourseCategoriesCarousel({
    super.key,
    this.categories,
    this.onCategoryTap,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final items = categories ?? FibroCourseCategories.categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 22.fSize,
                    fontWeight: FontWeight.bold,
                    color: appTheme.blueGray80001,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14.fSize,
                      color: appTheme.blueGray600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 200.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(width: 8.h),
            itemBuilder: (context, index) {
              final category = items[index];
              return SizedBox(
                width: 260.h,
                child: CourseCategoryCard(
                  category: category,
                  onTap: () => onCategoryTap?.call(category),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Widget de categoría de curso compacto (para lista vertical)
class CourseCategoryListTile extends StatelessWidget {
  final CourseCategoryInfo category;
  final VoidCallback? onTap;

  const CourseCategoryListTile({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.h),
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: appTheme.whiteA700,
          borderRadius: BorderRadius.circular(16.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icono con fondo de color
            Container(
              width: 56.h,
              height: 56.h,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.h),
              ),
              child: Icon(
                category.icon,
                size: 28.h,
                color: category.color,
              ),
            ),
            SizedBox(width: 16.h),
            // Información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 16.fSize,
                      fontWeight: FontWeight.w600,
                      color: appTheme.blueGray80001,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    category.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.fSize,
                      color: appTheme.blueGray600,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Cursos disponibles
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 16.h,
                        color: category.color,
                      ),
                      SizedBox(width: 4.h),
                      Text(
                        '${category.courses.length} cursos disponibles',
                        style: TextStyle(
                          fontSize: 12.fSize,
                          color: category.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Flecha
            Icon(
              Icons.chevron_right,
              size: 24.h,
              color: appTheme.blueGray600,
            ),
          ],
        ),
      ),
    );
  }
}

/// Lista vertical de categorías de cursos
class CourseCategoriesList extends StatelessWidget {
  final List<CourseCategoryInfo>? categories;
  final Function(CourseCategoryInfo)? onCategoryTap;
  final String? title;

  const CourseCategoriesList({
    super.key,
    this.categories,
    this.onCategoryTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final items = categories ?? FibroCourseCategories.categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
            child: Text(
              title!,
              style: TextStyle(
                fontSize: 20.fSize,
                fontWeight: FontWeight.bold,
                color: appTheme.blueGray80001,
              ),
            ),
          ),
        ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final category = items[index];
            return CourseCategoryListTile(
              category: category,
              onTap: () => onCategoryTap?.call(category),
            );
          },
        ),
      ],
    );
  }
}

/// Banner promocional de cursos
class CoursePromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onButtonTap;
  final Color? backgroundColor;

  const CoursePromoBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonText = 'Comenzar ahora',
    this.onButtonTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? FibroColors.primaryOrange;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            bgColor,
            bgColor.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(24.h),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24.fSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.fSize,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: onButtonTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: bgColor,
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.h),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 14.fSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8.h),
                const Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
