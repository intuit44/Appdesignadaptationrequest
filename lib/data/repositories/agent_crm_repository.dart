import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/agent_crm_models.dart';
import '../services/agent_crm_service.dart';

/// Estado del repositorio de Agent CRM
class AgentCRMState {
  final AgentCRMLocation? location;
  final List<AgentCRMProduct> products;
  final List<AgentCRMProduct> courses;
  final List<AgentCRMProduct> memberships;
  final List<AgentCRMContact> contacts;
  final List<AgentCRMOpportunity> opportunities;
  final List<AgentCRMPipeline> pipelines;
  final List<AgentCRMTag> tags;
  final AgentCRMContact? currentUserContact;
  final bool isLoading;
  final String? error;

  const AgentCRMState({
    this.location,
    this.products = const [],
    this.courses = const [],
    this.memberships = const [],
    this.contacts = const [],
    this.opportunities = const [],
    this.pipelines = const [],
    this.tags = const [],
    this.currentUserContact,
    this.isLoading = false,
    this.error,
  });

  AgentCRMState copyWith({
    AgentCRMLocation? location,
    List<AgentCRMProduct>? products,
    List<AgentCRMProduct>? courses,
    List<AgentCRMProduct>? memberships,
    List<AgentCRMContact>? contacts,
    List<AgentCRMOpportunity>? opportunities,
    List<AgentCRMPipeline>? pipelines,
    List<AgentCRMTag>? tags,
    AgentCRMContact? currentUserContact,
    bool? isLoading,
    String? error,
  }) {
    return AgentCRMState(
      location: location ?? this.location,
      products: products ?? this.products,
      courses: courses ?? this.courses,
      memberships: memberships ?? this.memberships,
      contacts: contacts ?? this.contacts,
      opportunities: opportunities ?? this.opportunities,
      pipelines: pipelines ?? this.pipelines,
      tags: tags ?? this.tags,
      currentUserContact: currentUserContact ?? this.currentUserContact,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Repositorio principal de Agent CRM
/// Gestiona toda la data de Agent CRM Pro
class AgentCRMRepository extends StateNotifier<AgentCRMState> {
  final AgentCRMService _service;

  AgentCRMRepository({AgentCRMService? service})
      : _service = service ?? AgentCRMService.instance,
        super(const AgentCRMState());

  /// Inicializa el repositorio cargando datos básicos
  Future<void> initialize() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Cargar location y productos en paralelo
      final results = await Future.wait([
        _service.getLocation(),
        _service.getProducts(),
      ]);

      final location = results[0] as AgentCRMLocation?;
      final products = results[1] as List<AgentCRMProduct>;

      // Separar cursos y membresías
      final courses =
          products.where((p) => p.isCourse && !p.isMembership).toList();
      final memberships = products.where((p) => p.isMembership).toList();

      state = state.copyWith(
        location: location,
        products: products,
        courses: courses,
        memberships: memberships,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al inicializar Agent CRM: $e',
      );
    }
  }

  /// Carga todos los cursos
  Future<void> loadCourses() async {
    try {
      final courses = await _service.getCourses();
      state = state.copyWith(courses: courses);
    } catch (e) {
      state = state.copyWith(error: 'Error al cargar cursos: $e');
    }
  }

  /// Carga todas las membresías
  Future<void> loadMemberships() async {
    try {
      final memberships = await _service.getMemberships();
      state = state.copyWith(memberships: memberships);
    } catch (e) {
      state = state.copyWith(error: 'Error al cargar membresías: $e');
    }
  }

  /// Carga contactos
  Future<void> loadContacts({String? query}) async {
    try {
      final contacts = await _service.getContacts(query: query);
      state = state.copyWith(contacts: contacts);
    } catch (e) {
      state = state.copyWith(error: 'Error al cargar contactos: $e');
    }
  }

  /// Busca y establece el contacto del usuario actual por email
  Future<AgentCRMContact?> setCurrentUserByEmail(String email) async {
    try {
      final contact = await _service.getContactByEmail(email);
      if (contact != null) {
        state = state.copyWith(currentUserContact: contact);
      }
      return contact;
    } catch (e) {
      return null;
    }
  }

  /// Crea un nuevo contacto (para registro de usuarios)
  Future<AgentCRMContact?> createContact({
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    List<String>? tags,
  }) async {
    try {
      final contact = await _service.createContact(
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        tags: tags,
      );

      if (contact != null) {
        // Actualizar lista de contactos
        state = state.copyWith(
          contacts: [...state.contacts, contact],
          currentUserContact: contact,
        );
      }

      return contact;
    } catch (e) {
      state = state.copyWith(error: 'Error al crear contacto: $e');
      return null;
    }
  }

  /// Actualiza el contacto del usuario actual
  Future<AgentCRMContact?> updateCurrentUserContact({
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    if (state.currentUserContact == null) return null;

    try {
      final updated = await _service.updateContact(
        state.currentUserContact!.id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      if (updated != null) {
        state = state.copyWith(currentUserContact: updated);
      }

      return updated;
    } catch (e) {
      return null;
    }
  }

  /// Agrega tags al usuario actual
  Future<bool> addTagsToCurrentUser(List<String> tags) async {
    if (state.currentUserContact == null) return false;

    try {
      return await _service.addTagsToContact(
        state.currentUserContact!.id,
        tags,
      );
    } catch (e) {
      return false;
    }
  }

  /// Carga oportunidades
  Future<void> loadOpportunities() async {
    try {
      final opportunities = await _service.getOpportunities();
      state = state.copyWith(opportunities: opportunities);
    } catch (e) {
      state = state.copyWith(error: 'Error al cargar oportunidades: $e');
    }
  }

  /// Carga pipelines
  Future<void> loadPipelines() async {
    try {
      final pipelines = await _service.getPipelines();
      state = state.copyWith(pipelines: pipelines);
    } catch (e) {
      state = state.copyWith(error: 'Error al cargar pipelines: $e');
    }
  }

  /// Carga tags
  Future<void> loadTags() async {
    try {
      final tags = await _service.getTags();
      state = state.copyWith(tags: tags);
    } catch (e) {
      state = state.copyWith(error: 'Error al cargar tags: $e');
    }
  }

  /// Crea una oportunidad para el usuario actual
  Future<AgentCRMOpportunity?> createOpportunityForCurrentUser({
    required String name,
    required String pipelineId,
    required String stageId,
    double? value,
  }) async {
    if (state.currentUserContact == null) return null;

    try {
      final opportunity = await _service.createOpportunity(
        name: name,
        pipelineId: pipelineId,
        stageId: stageId,
        contactId: state.currentUserContact!.id,
        monetaryValue: value,
      );

      if (opportunity != null) {
        state = state.copyWith(
          opportunities: [...state.opportunities, opportunity],
        );
      }

      return opportunity;
    } catch (e) {
      return null;
    }
  }

  /// Obtiene un curso/producto por ID
  AgentCRMProduct? getProductById(String id) {
    return state.products.where((p) => p.id == id).firstOrNull;
  }

  /// Obtiene un curso por ID
  AgentCRMProduct? getCourseById(String id) {
    return state.courses.where((c) => c.id == id).firstOrNull;
  }

  /// Limpia error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Refresca todos los datos
  Future<void> refresh() => initialize();
}

// ==================== Riverpod Providers ====================

/// Provider principal del repositorio de Agent CRM
final agentCRMRepositoryProvider =
    StateNotifierProvider<AgentCRMRepository, AgentCRMState>((ref) {
  return AgentCRMRepository();
});

/// Provider para cursos
final agentCoursesProvider = Provider<List<AgentCRMProduct>>((ref) {
  return ref.watch(agentCRMRepositoryProvider).courses;
});

/// Provider para membresías
final agentMembershipsProvider = Provider<List<AgentCRMProduct>>((ref) {
  return ref.watch(agentCRMRepositoryProvider).memberships;
});

/// Provider para contacto del usuario actual
final currentAgentContactProvider = Provider<AgentCRMContact?>((ref) {
  return ref.watch(agentCRMRepositoryProvider).currentUserContact;
});

/// Provider para información de la empresa
final agentLocationProvider = Provider<AgentCRMLocation?>((ref) {
  return ref.watch(agentCRMRepositoryProvider).location;
});

/// Provider para verificar si el usuario está registrado en Agent CRM
final isUserInAgentCRMProvider = Provider<bool>((ref) {
  return ref.watch(agentCRMRepositoryProvider).currentUserContact != null;
});
