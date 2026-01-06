/// Providers centralizados para Agent CRM Pro
/// Arquitectura híbrida: Agent CRM como backend central + Firebase para soporte UX
///
/// Orden de precedencia:
/// 1. Agent CRM → Datos de negocio (productos, contactos, calendarios, tags)
/// 2. Firebase Auth → Autenticación del usuario
/// 3. Firebase (Push, Analytics) → Soporte UX
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/agent_crm_models.dart';
import '../../data/repositories/agent_crm_repository.dart';
import '../../data/services/agent_crm_service.dart';

// ==================== Re-exports ====================
// Re-exportar providers del repositorio para acceso centralizado
export '../../data/repositories/agent_crm_repository.dart'
    show
        agentCRMRepositoryProvider,
        agentCoursesProvider,
        agentMembershipsProvider,
        currentAgentContactProvider,
        agentLocationProvider,
        isUserInAgentCRMProvider;

export '../../data/services/agent_crm_service.dart'
    show
        agentCRMServiceProvider,
        agentCRMProductsProvider,
        agentCRMCoursesProvider,
        agentCRMMembershipsProvider,
        agentCRMContactsProvider,
        agentCRMContactByEmailProvider,
        agentCRMTagsProvider,
        agentCRMUsersProvider,
        agentCRMPipelinesProvider;

// ==================== Products/Cursos Providers ====================

/// Provider para todos los productos del CRM
final crmProductsProvider = FutureProvider<List<AgentCRMProduct>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getProducts();
});

/// Provider para cursos (filtrados de productos)
final crmCoursesProvider = FutureProvider<List<AgentCRMProduct>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getCourses();
});

/// Provider para membresías
final crmMembershipsProvider =
    FutureProvider<List<AgentCRMProduct>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getMemberships();
});

/// Provider para un producto específico por ID
final crmProductByIdProvider =
    FutureProvider.family<AgentCRMProduct?, String>((ref, productId) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getProductById(productId);
});

/// Provider para cursos destacados (primeros 6)
final crmFeaturedCoursesProvider =
    FutureProvider<List<AgentCRMProduct>>((ref) async {
  final courses = await ref.watch(crmCoursesProvider.future);
  return courses.take(6).toList();
});

/// Provider para buscar cursos por nombre
final crmCourseSearchProvider =
    FutureProvider.family<List<AgentCRMProduct>, String>((ref, query) async {
  final courses = await ref.watch(crmCoursesProvider.future);
  if (query.isEmpty) return courses;
  final lowerQuery = query.toLowerCase();
  return courses
      .where((c) =>
          c.name.toLowerCase().contains(lowerQuery) ||
          (c.description?.toLowerCase().contains(lowerQuery) ?? false))
      .toList();
});

// ==================== Calendars Providers ====================

/// Provider para calendarios del CRM
final crmCalendarsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getCalendars();
});

/// Provider para citas/eventos del usuario actual
final crmUserAppointmentsProvider =
    FutureProvider<List<AgentCRMAppointment>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  final contact = ref.watch(currentAgentContactProvider);

  if (contact == null) return [];

  return service.getAppointments(contactId: contact.id);
});

/// Provider para citas de un calendario específico
final crmCalendarAppointmentsProvider =
    FutureProvider.family<List<AgentCRMAppointment>, String>(
        (ref, calendarId) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getAppointments(calendarId: calendarId);
});

/// Provider para citas en un rango de fechas
final crmAppointmentsInRangeProvider = FutureProvider.family<
    List<AgentCRMAppointment>,
    ({DateTime start, DateTime end})>((ref, range) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getAppointments(startDate: range.start, endDate: range.end);
});

// ==================== Tags Providers ====================

/// Provider para todos los tags del CRM
final crmTagsProvider = FutureProvider<List<AgentCRMTag>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getTags();
});

/// Provider para tags del usuario actual
final crmUserTagsProvider = Provider<List<String>>((ref) {
  final contact = ref.watch(currentAgentContactProvider);
  return contact?.tags ?? [];
});

/// Provider para verificar si el usuario tiene un tag específico
final crmUserHasTagProvider = Provider.family<bool, String>((ref, tagName) {
  final userTags = ref.watch(crmUserTagsProvider);
  return userTags.any((t) => t.toLowerCase() == tagName.toLowerCase());
});

// ==================== Contacts Providers ====================

/// Provider para contactos (requiere permisos de admin)
final crmContactsProvider = FutureProvider<List<AgentCRMContact>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getContacts();
});

/// Provider para buscar contacto por email
final crmContactByEmailProvider =
    FutureProvider.family<AgentCRMContact?, String>((ref, email) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getContactByEmail(email);
});

/// Provider para el contacto del usuario actual (desde repositorio)
final crmCurrentContactProvider = Provider<AgentCRMContact?>((ref) {
  return ref.watch(currentAgentContactProvider);
});

// ==================== Pipelines Providers ====================

/// Provider para pipelines
final crmPipelinesProvider =
    FutureProvider<List<AgentCRMPipeline>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getPipelines();
});

/// Provider para stages de un pipeline específico
final crmPipelineStagesProvider =
    Provider.family<List<AgentCRMPipelineStage>, String>((ref, pipelineId) {
  final pipelines = ref.watch(crmPipelinesProvider).valueOrNull ?? [];
  final pipeline = pipelines.where((p) => p.id == pipelineId).firstOrNull;
  return pipeline?.stages ?? [];
});

// ==================== Location/Business Info ====================

/// Provider para información del negocio
final crmBusinessInfoProvider = FutureProvider<AgentCRMLocation?>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getLocation();
});

// ==================== Users Providers (Admin) ====================

/// Provider para usuarios del CRM (instructores, admins)
final crmUsersProvider = FutureProvider<List<AgentCRMUser>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getUsers();
});

/// Provider para instructores (filtrados por rol)
final crmInstructorsProvider = FutureProvider<List<AgentCRMUser>>((ref) async {
  final users = await ref.watch(crmUsersProvider.future);
  // Filtrar usuarios que podrían ser instructores
  return users
      .where((u) =>
          u.role?.toLowerCase().contains('instructor') == true ||
          u.role?.toLowerCase().contains('teacher') == true ||
          u.role?.toLowerCase().contains('admin') == true)
      .toList();
});

// ==================== Estado de carga global ====================

/// Provider para verificar si hay datos cargados del CRM
final crmIsInitializedProvider = Provider<bool>((ref) {
  final state = ref.watch(agentCRMRepositoryProvider);
  return state.products.isNotEmpty || state.location != null;
});

/// Provider para verificar si está cargando datos del CRM
final crmIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(agentCRMRepositoryProvider).isLoading;
});

/// Provider para errores del CRM
final crmErrorProvider = Provider<String?>((ref) {
  return ref.watch(agentCRMRepositoryProvider).error;
});
