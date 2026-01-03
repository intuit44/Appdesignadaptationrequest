import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/app_export.dart';
import '../../data/models/course_model.dart';

/// Widget de tarjeta de curso para mostrar cursos de WooCommerce
class CourseCardWidget extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onTap;

  const CourseCardWidget({
    super.key,
    required this.course,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _navigateToCourseDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.whiteA700,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.black90001.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del curso
            _buildCourseImage(),

            // Contenido
            Padding(
              padding: EdgeInsets.all(12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoría
                  if (course.categories.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.h,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: appTheme.deepOrange400.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.h),
                      ),
                      child: Text(
                        course.categories.first.name,
                        style: CustomTextStyles.titleSmallDeeporange400,
                      ),
                    ),

                  SizedBox(height: 8.h),

                  // Título
                  Text(
                    course.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.titleMediumGray90001_1,
                  ),

                  SizedBox(height: 8.h),

                  // Precio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPrice(),
                      _buildRating(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseImage() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12.h)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: course.images.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: course.images.first.src,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: appTheme.gray200,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        appTheme.deepOrange400,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: appTheme.gray200,
                  child: Icon(
                    Icons.school_outlined,
                    size: 40.h,
                    color: appTheme.gray700,
                  ),
                ),
              )
            : Container(
                color: appTheme.gray200,
                child: Icon(
                  Icons.school_outlined,
                  size: 40.h,
                  color: appTheme.gray700,
                ),
              ),
      ),
    );
  }

  Widget _buildPrice() {
    final hasDiscount = course.salePrice != null &&
        course.salePrice!.isNotEmpty &&
        course.salePrice != course.regularPrice;

    return Row(
      children: [
        Text(
          '\$${course.price}',
          style: CustomTextStyles.titleMediumDeeporange400,
        ),
        if (hasDiscount) ...[
          SizedBox(width: 8.h),
          Text(
            '\$${course.regularPrice}',
            style: theme.textTheme.bodySmall?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: appTheme.gray700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        Icon(
          Icons.star,
          size: 16.h,
          color: Colors.amber,
        ),
        SizedBox(width: 4.h),
        Text(
          course.rating?.toStringAsFixed(1) ?? '0.0',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  void _navigateToCourseDetails(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.eduviCourseDetailsScreen,
      arguments: {'courseId': course.id},
    );
  }
}

/// Widget compacto para lista horizontal
class CourseCardCompact extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onTap;

  const CourseCardCompact({
    super.key,
    required this.course,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200.h,
        decoration: BoxDecoration(
          color: appTheme.whiteA700,
          borderRadius: BorderRadius.circular(10.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.black90001.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagen
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.h)),
              child: course.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: course.images.first.src,
                      height: 100.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 100.h,
                        color: appTheme.gray200,
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 100.h,
                        color: appTheme.gray200,
                        child: Icon(Icons.school, color: appTheme.gray700),
                      ),
                    )
                  : Container(
                      height: 100.h,
                      color: appTheme.gray200,
                      child: Icon(Icons.school, color: appTheme.gray700),
                    ),
            ),

            // Contenido
            Padding(
              padding: EdgeInsets.all(10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '\$${course.price}',
                    style: CustomTextStyles.titleSmallDeeporange400,
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
