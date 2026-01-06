/// Widgets para mostrar productos/cursos del CRM en la UI
/// Conecta los providers de Agent CRM con la presentación
library;

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

import '../core/app_export.dart';
import '../data/models/agent_crm_models.dart';
import '../data/services/hybrid_auth_service.dart';
import '../presentation/sign_in_dialog/sign_in_dialog.dart';

/// Widget que muestra un curso del CRM en formato tarjeta
class CRMCourseCard extends StatelessWidget {
  final AgentCRMProduct course;
  final VoidCallback? onTap;
  final bool showPrice;

  const CRMCourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.showPrice = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180.h,
        margin: EdgeInsets.symmetric(horizontal: 6.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagen
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.h)),
              child: SizedBox(
                height: 100.h,
                width: double.infinity,
                child: _buildImage(),
              ),
            ),
            // Contenido compacto
            Padding(
              padding: EdgeInsets.all(10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tipo badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.h,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor().withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6.h),
                    ),
                    child: Text(
                      _getTypeLabel(),
                      style: TextStyle(
                        fontSize: 9.fSize,
                        fontWeight: FontWeight.w600,
                        color: _getTypeColor(),
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  // Nombre
                  Text(
                    course.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.fSize,
                      fontWeight: FontWeight.w600,
                      color: appTheme.blueGray80001,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  // Precio
                  if (showPrice && course.price != null)
                    Text(
                      '\$${course.price!.toStringAsFixed(0)} ${course.currency ?? 'USD'}',
                      style: TextStyle(
                        fontSize: 14.fSize,
                        fontWeight: FontWeight.bold,
                        color: FibroColors.primaryOrange,
                      ),
                    )
                  else
                    Text(
                      'Consultar',
                      style: TextStyle(
                        fontSize: 12.fSize,
                        color: appTheme.blueGray600,
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
    if (course.imageUrl != null && course.imageUrl!.isNotEmpty) {
      return ExtendedImage.network(
        course.imageUrl!,
        fit: BoxFit.cover,
        cache: true,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return _buildPlaceholder();
            case LoadState.failed:
              return _buildPlaceholder();
            case LoadState.completed:
              return null;
          }
        },
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getTypeColor().withValues(alpha: 0.3),
            _getTypeColor().withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Icon(
        _getTypeIcon(),
        size: 40.h,
        color: _getTypeColor().withValues(alpha: 0.5),
      ),
    );
  }

  Color _getTypeColor() {
    if (course.isMembership) return FibroColors.secondaryTeal;
    if (course.productType == 'DIGITAL') return FibroColors.primaryOrange;
    return appTheme.blueGray700;
  }

  String _getTypeLabel() {
    if (course.isMembership) return 'Membresía';
    if (course.productType == 'DIGITAL') return 'Curso Online';
    if (course.productType == 'SERVICE') return 'Taller';
    return 'Producto';
  }

  IconData _getTypeIcon() {
    if (course.isMembership) return Icons.card_membership;
    if (course.productType == 'DIGITAL') return Icons.play_circle_outline;
    if (course.productType == 'SERVICE') return Icons.school_outlined;
    return Icons.inventory_2_outlined;
  }
}

/// Widget que muestra una lista horizontal de cursos del CRM
class CRMCoursesCarousel extends ConsumerWidget {
  final String? title;
  final String? subtitle;
  final int maxItems;
  final Function(AgentCRMProduct)? onCourseTap;

  const CRMCoursesCarousel({
    super.key,
    this.title,
    this.subtitle,
    this.maxItems = 10,
    this.onCourseTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(crmCoursesProvider);

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
          height: 210.h, // Ajustado para el nuevo tamaño de card
          child: coursesAsync.when(
            data: (courses) {
              if (courses.isEmpty) {
                return _buildEmptyState();
              }
              final items = courses.take(maxItems).toList();
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 10.h),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 2),
                itemBuilder: (context, index) {
                  return CRMCourseCard(
                    course: items[index],
                    onTap: () => onCourseTap?.call(items[index]),
                  );
                },
              );
            },
            loading: () => _buildLoadingState(),
            error: (error, _) => _buildErrorState(error.toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (_, __) => SizedBox(width: 4.h),
      itemBuilder: (context, index) {
        return Container(
          width: 200.h,
          margin: EdgeInsets.symmetric(horizontal: 8.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16.h),
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: FibroColors.primaryOrange,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 48.h,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 8.h),
          Text(
            'No hay cursos disponibles',
            style: TextStyle(
              fontSize: 14.fSize,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.h,
            color: Colors.red.shade300,
          ),
          SizedBox(height: 8.h),
          Text(
            'Error al cargar cursos',
            style: TextStyle(
              fontSize: 14.fSize,
              color: Colors.red.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget que muestra todos los cursos del CRM en grid
class CRMCoursesGrid extends ConsumerWidget {
  final Function(AgentCRMProduct)? onCourseTap;
  final String? searchQuery;
  final bool showMemberships;

  const CRMCoursesGrid({
    super.key,
    this.onCourseTap,
    this.searchQuery,
    this.showMemberships = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = showMemberships
        ? ref.watch(crmMembershipsProvider)
        : ref.watch(crmCoursesProvider);

    return coursesAsync.when(
      data: (courses) {
        var filtered = courses;

        // Filtrar por búsqueda
        if (searchQuery != null && searchQuery!.isNotEmpty) {
          final query = searchQuery!.toLowerCase();
          filtered = courses
              .where((c) =>
                  c.name.toLowerCase().contains(query) ||
                  (c.description?.toLowerCase().contains(query) ?? false))
              .toList();
        }

        if (filtered.isEmpty) {
          return _buildEmptyState();
        }

        return GridView.builder(
          padding: EdgeInsets.all(16.h),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12.h,
            mainAxisSpacing: 12.h,
          ),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            return CRMCourseCard(
              course: filtered[index],
              onTap: () => onCourseTap?.call(filtered[index]),
            );
          },
        );
      },
      loading: () => _buildLoadingGrid(),
      error: (error, _) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16.h),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12.h,
        mainAxisSpacing: 12.h,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16.h),
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: FibroColors.primaryOrange,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(48.h),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64.h,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16.h),
            Text(
              'No se encontraron cursos',
              style: TextStyle(
                fontSize: 16.fSize,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(48.h),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64.h,
              color: Colors.red.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              'Error al cargar',
              style: TextStyle(
                fontSize: 16.fSize,
                color: Colors.red.shade500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error,
              style: TextStyle(
                fontSize: 12.fSize,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget de acción para registrar interés en un curso
class CourseInterestButton extends ConsumerStatefulWidget {
  final AgentCRMProduct course;
  final Widget? child;

  const CourseInterestButton({
    super.key,
    required this.course,
    this.child,
  });

  @override
  ConsumerState<CourseInterestButton> createState() =>
      _CourseInterestButtonState();
}

class _CourseInterestButtonState extends ConsumerState<CourseInterestButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(isHybridAuthenticatedProvider);
    final hasInterest =
        ref.watch(userHasTagProvider('interested-${widget.course.id}'));

    if (hasInterest) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
        decoration: BoxDecoration(
          color: FibroColors.secondaryTeal.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 18.h,
              color: FibroColors.secondaryTeal,
            ),
            SizedBox(width: 8.h),
            Text(
              'Interesado',
              style: TextStyle(
                fontSize: 14.fSize,
                fontWeight: FontWeight.w600,
                color: FibroColors.secondaryTeal,
              ),
            ),
          ],
        ),
      );
    }

    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () async {
              if (!isAuthenticated) {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.h),
                    ),
                    child: const SignInDialog(),
                  ),
                );
                return;
              }

              setState(() => _isLoading = true);

              final messenger = ScaffoldMessenger.of(context);
              final success = await ref
                  .read(hybridAuthProvider.notifier)
                  .registerCourseInterest(
                    widget.course.id,
                    widget.course.name,
                  );

              if (!mounted) return;

              setState(() => _isLoading = false);

              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? '¡Interés registrado! Te contactaremos pronto.'
                        : 'Error al registrar interés',
                  ),
                  backgroundColor:
                      success ? FibroColors.secondaryTeal : Colors.red,
                ),
              );
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: FibroColors.primaryOrange,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
      ),
      child: _isLoading
          ? SizedBox(
              width: 20.h,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : widget.child ??
              Text(
                'Me interesa',
                style: TextStyle(
                  fontSize: 14.fSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
    );
  }
}
