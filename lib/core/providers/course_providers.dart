/// Providers de conveniencia para cursos
/// Los providers principales se definen en course_repository.dart
/// Este archivo re-exporta y agrega providers adicionales de conveniencia.
library;

// Re-exportar los providers del repositorio
export '../../data/repositories/course_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/course_model.dart';
import '../../data/services/woocommerce_service.dart';
import '../../data/repositories/course_repository.dart';

/// Provider para cursos por categoría (adicional)
final coursesByCategoryProvider =
    FutureProvider.family<List<CourseModel>, String>((ref, categorySlug) async {
  final wcService = WooCommerceService();
  return await wcService.getCourses(categorySlug: categorySlug, perPage: 50);
});

/// Provider para verificar si está cargando cursos
final isLoadingCoursesProvider = Provider<bool>((ref) {
  return ref.watch(courseRepositoryProvider).isLoading;
});

/// Provider para verificar si hay más cursos
final hasMoreCoursesProvider = Provider<bool>((ref) {
  return ref.watch(courseRepositoryProvider).hasMore;
});

/// Provider para el error de cursos
final coursesErrorProvider = Provider<String?>((ref) {
  return ref.watch(courseRepositoryProvider).error;
});
