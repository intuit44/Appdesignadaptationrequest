import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/woocommerce_service.dart';
import '../models/course_model.dart';

/// Estado para la lista de cursos
class CoursesState {
  final List<CourseModel> courses;
  final List<CourseModel> featuredCourses;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasMore;

  const CoursesState({
    this.courses = const [],
    this.featuredCourses = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  CoursesState copyWith({
    List<CourseModel>? courses,
    List<CourseModel>? featuredCourses,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return CoursesState(
      courses: courses ?? this.courses,
      featuredCourses: featuredCourses ?? this.featuredCourses,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Repositorio de cursos
/// Gestiona la carga y caché de cursos desde WooCommerce
class CourseRepository extends StateNotifier<CoursesState> {
  final WooCommerceService _wcService;
  final int _perPage;

  // Categoría de cursos en WooCommerce (ajustar según configuración)
  static const String coursesCategorySlug = 'cursos';

  CourseRepository({
    WooCommerceService? wcService,
    int perPage = 20,
  })  : _wcService = wcService ?? WooCommerceService(),
        _perPage = perPage,
        super(const CoursesState());

  /// Carga los cursos iniciales
  Future<void> loadCourses({bool refresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: refresh ? 1 : state.currentPage,
      courses: refresh ? [] : state.courses,
    );

    try {
      final courses = await _wcService.getCourses(
        page: 1,
        perPage: _perPage,
        categorySlug: coursesCategorySlug,
      );

      state = state.copyWith(
        courses: courses,
        isLoading: false,
        currentPage: 1,
        hasMore: courses.length >= _perPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar cursos: $e',
      );
    }
  }

  /// Carga más cursos (paginación)
  Future<void> loadMoreCourses() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final moreCourses = await _wcService.getCourses(
        page: nextPage,
        perPage: _perPage,
        categorySlug: coursesCategorySlug,
      );

      state = state.copyWith(
        courses: [...state.courses, ...moreCourses],
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: moreCourses.length >= _perPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: 'Error al cargar más cursos: $e',
      );
    }
  }

  /// Carga cursos destacados
  Future<void> loadFeaturedCourses() async {
    try {
      final featured = await _wcService.getFeaturedCourses(limit: 5);
      state = state.copyWith(featuredCourses: featured);
    } catch (e) {
      // Silenciar error de destacados
    }
  }

  /// Busca cursos
  Future<List<CourseModel>> searchCourses(String query) async {
    if (query.isEmpty) return [];

    try {
      return await _wcService.getCourses(
        search: query,
        perPage: 20,
      );
    } catch (e) {
      return [];
    }
  }

  /// Obtiene un curso por ID
  Future<CourseModel?> getCourseById(int id) async {
    // Primero buscar en caché local
    final cached = state.courses.where((c) => c.id == id).firstOrNull;
    if (cached != null) return cached;

    // Si no está en caché, cargar desde API
    try {
      return await _wcService.getCourseById(id);
    } catch (e) {
      return null;
    }
  }

  /// Filtra cursos por categoría
  Future<List<CourseModel>> getCoursesByCategory(String categorySlug) async {
    try {
      return await _wcService.getCourses(
        categorySlug: categorySlug,
        perPage: 50,
      );
    } catch (e) {
      return [];
    }
  }

  /// Refresca los cursos
  Future<void> refresh() => loadCourses(refresh: true);

  /// Limpia el error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider para CourseRepository
final courseRepositoryProvider =
    StateNotifierProvider<CourseRepository, CoursesState>((ref) {
  return CourseRepository();
});

/// Provider para lista de cursos
final coursesProvider = Provider<List<CourseModel>>((ref) {
  return ref.watch(courseRepositoryProvider).courses;
});

/// Provider para cursos destacados
final featuredCoursesProvider = Provider<List<CourseModel>>((ref) {
  return ref.watch(courseRepositoryProvider).featuredCourses;
});

/// Provider para un curso específico
final courseByIdProvider =
    FutureProvider.family<CourseModel?, int>((ref, id) async {
  final repository = ref.watch(courseRepositoryProvider.notifier);
  return repository.getCourseById(id);
});

/// Provider para búsqueda de cursos
final courseSearchProvider =
    FutureProvider.family<List<CourseModel>, String>((ref, query) async {
  final repository = ref.watch(courseRepositoryProvider.notifier);
  return repository.searchCourses(query);
});
