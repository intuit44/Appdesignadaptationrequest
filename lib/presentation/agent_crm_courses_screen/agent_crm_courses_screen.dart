import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../data/models/agent_crm_models.dart';
import '../../widgets/agent_crm_course_card.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../membership_portal_screen/membership_portal_screen.dart';
import 'agent_crm_course_detail_screen.dart';

/// Pantalla de lista de cursos de Agent CRM Pro
/// Muestra todos los cursos disponibles de Fibroskin Beauty Academy
class AgentCRMCoursesScreen extends ConsumerStatefulWidget {
  const AgentCRMCoursesScreen({super.key});

  @override
  ConsumerState<AgentCRMCoursesScreen> createState() =>
      _AgentCRMCoursesScreenState();
}

class _AgentCRMCoursesScreenState extends ConsumerState<AgentCRMCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Cargar datos de Agent CRM si no están cargados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(agentCRMRepositoryProvider);
      if (state.courses.isEmpty && !state.isLoading) {
        ref.read(agentCRMRepositoryProvider.notifier).initialize();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray50,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildMyCoursesButton(),
            _buildSearchBar(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCoursesList(filterType: 'courses'),
                  _buildCoursesList(filterType: 'memberships'),
                  _buildCoursesList(filterType: 'all'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Botón destacado para abrir el portal de cursos (member.fibrolovers.com)
  Widget _buildMyCoursesButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
      color: appTheme.whiteA700,
      child: ElevatedButton.icon(
        onPressed: _openMembershipPortal,
        icon: const Icon(Icons.play_circle_filled, size: 24),
        label: const Text(
          'Ver Mis Cursos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.deepOrange400,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.h),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  void _openMembershipPortal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MembershipPortalScreen(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeft,
        height: 24.h,
        width: 24.h,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: AppbarTitle(text: "Cursos y Membresías"),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: appTheme.blueGray80001),
          onPressed: () {
            ref.read(agentCRMRepositoryProvider.notifier).initialize();
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16.h),
      color: appTheme.whiteA700,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar cursos...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search, color: appTheme.deepOrange400),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: appTheme.gray50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.h),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: appTheme.whiteA700,
      child: TabBar(
        controller: _tabController,
        labelColor: appTheme.deepOrange400,
        unselectedLabelColor: Colors.grey.shade600,
        indicatorColor: appTheme.deepOrange400,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Cursos'),
          Tab(text: 'Membresías'),
          Tab(text: 'Todos'),
        ],
      ),
    );
  }

  Widget _buildCoursesList({required String filterType}) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(agentCRMRepositoryProvider);

        // Estado de carga
        if (state.isLoading &&
            state.courses.isEmpty &&
            state.memberships.isEmpty) {
          return _buildLoadingState();
        }

        // Estado de error
        if (state.error != null &&
            state.courses.isEmpty &&
            state.memberships.isEmpty) {
          return _buildErrorState(state.error!);
        }

        // Filtrar productos según tab
        List<AgentCRMProduct> items;
        switch (filterType) {
          case 'courses':
            items = state.courses;
            break;
          case 'memberships':
            items = state.memberships;
            break;
          case 'all':
            items = [...state.courses, ...state.memberships];
            break;
          default:
            items = state.courses;
        }

        // Aplicar búsqueda
        if (_searchQuery.isNotEmpty) {
          items = items
              .where((item) =>
                  item.name.toLowerCase().contains(_searchQuery) ||
                  (item.description?.toLowerCase().contains(_searchQuery) ??
                      false))
              .toList();
        }

        // Sin resultados
        if (items.isEmpty) {
          return _buildEmptyState(filterType);
        }

        // Lista de cursos
        return RefreshIndicator(
          color: appTheme.deepOrange400,
          onRefresh: () async {
            await ref.read(agentCRMRepositoryProvider.notifier).initialize();
          },
          child: ListView.builder(
            padding: EdgeInsets.all(16.h),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final course = items[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: SizedBox(
                  height: 120.h,
                  child: AgentCRMCourseCardHorizontal(
                    course: course,
                    onTap: () => _navigateToCourseDetail(course),
                  ),
                ),
              );
            },
          ),
        );
      },
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
            'Cargando cursos...',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14.fSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.h,
              color: Colors.red.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              'Error al cargar cursos',
              style: TextStyle(
                fontSize: 18.fSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.fSize,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(agentCRMRepositoryProvider.notifier).initialize();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.deepOrange400,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String filterType) {
    String message;
    IconData icon;

    switch (filterType) {
      case 'courses':
        message = 'No hay cursos disponibles';
        icon = Icons.school_outlined;
        break;
      case 'memberships':
        message = 'No hay membresías disponibles';
        icon = Icons.card_membership_outlined;
        break;
      default:
        message = 'No se encontraron resultados';
        icon = Icons.search_off_outlined;
    }

    if (_searchQuery.isNotEmpty) {
      message = 'No se encontraron resultados para "$_searchQuery"';
      icon = Icons.search_off_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64.h,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.fSize,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCourseDetail(AgentCRMProduct course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgentCRMCourseDetailScreen(course: course),
      ),
    );
  }
}
