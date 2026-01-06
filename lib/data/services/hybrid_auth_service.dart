/// Servicio híbrido para sincronización Auth + CRM
/// Combina Firebase Auth con Agent CRM Contact
///
/// Flujo:
/// 1. Usuario se autentica con Firebase (Google/Email)
/// 2. Se busca/crea contacto en Agent CRM con el mismo email
/// 3. Se asocian tags para activar workflows del CRM (CloseBot, Twilio, GPT, etc)
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../services/agent_crm_service.dart';
import '../models/agent_crm_models.dart';
import '../repositories/agent_crm_repository.dart';
import '../../core/providers/auth_state_provider.dart';

/// Estado del usuario híbrido (Firebase + CRM)
class HybridUserState {
  final firebase_auth.User? firebaseUser;
  final AgentCRMContact? crmContact;
  final bool isSynced;
  final bool isSyncing;
  final String? syncError;

  const HybridUserState({
    this.firebaseUser,
    this.crmContact,
    this.isSynced = false,
    this.isSyncing = false,
    this.syncError,
  });

  HybridUserState copyWith({
    firebase_auth.User? firebaseUser,
    AgentCRMContact? crmContact,
    bool? isSynced,
    bool? isSyncing,
    String? syncError,
  }) {
    return HybridUserState(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      crmContact: crmContact ?? this.crmContact,
      isSynced: isSynced ?? this.isSynced,
      isSyncing: isSyncing ?? this.isSyncing,
      syncError: syncError,
    );
  }

  /// Está autenticado en Firebase?
  bool get isAuthenticated => firebaseUser != null;

  /// Está sincronizado con CRM?
  bool get isInCRM => crmContact != null;

  /// Email del usuario (Firebase tiene prioridad)
  String? get email => firebaseUser?.email ?? crmContact?.email;

  /// Nombre completo (CRM tiene prioridad para datos de negocio)
  String get displayName {
    if (crmContact != null && crmContact!.fullName.isNotEmpty) {
      return crmContact!.fullName;
    }
    return firebaseUser?.displayName ?? 'Usuario';
  }

  /// Nombre de pila
  String? get firstName => crmContact?.firstName;

  /// Apellido
  String? get lastName => crmContact?.lastName;

  /// Teléfono (solo de CRM)
  String? get phone => crmContact?.phone;

  /// Foto (Firebase)
  String? get photoUrl => firebaseUser?.photoURL;

  /// Tags del usuario en CRM
  List<String> get tags => crmContact?.tags ?? [];

  /// ID del contacto en CRM
  String? get crmContactId => crmContact?.id;

  /// ID de Firebase
  String? get firebaseUid => firebaseUser?.uid;
}

/// Notifier para el estado híbrido de usuario
class HybridAuthNotifier extends StateNotifier<HybridUserState> {
  final Ref _ref;
  final AgentCRMService _crmService;

  HybridAuthNotifier(this._ref)
      : _crmService = AgentCRMService.instance,
        super(const HybridUserState()) {
    // Escuchar cambios de autenticación
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _ref.listen<GlobalAuthState>(authStateProvider, (prev, next) {
      if (next.isAuthenticated && next.firebaseUser != null) {
        // Usuario autenticado - sincronizar con CRM
        _syncWithCRM(next.firebaseUser!);
      } else if (!next.isAuthenticated) {
        // Usuario cerró sesión
        state = const HybridUserState();
      }
    });

    // Verificar estado inicial
    final authState = _ref.read(authStateProvider);
    if (authState.isAuthenticated && authState.firebaseUser != null) {
      _syncWithCRM(authState.firebaseUser!);
    }
  }

  /// Sincroniza el usuario de Firebase con Agent CRM
  /// Ejecuta en microtask para no bloquear UI
  /// Usa getOrCreateContact que maneja duplicados automáticamente
  Future<void> _syncWithCRM(firebase_auth.User firebaseUser) async {
    if (state.isSyncing) return;

    state = state.copyWith(
      firebaseUser: firebaseUser,
      isSyncing: true,
      syncError: null,
    );

    // Ejecutar en microtask para no bloquear el hilo principal
    await Future.microtask(() async {
      try {
        final email = firebaseUser.email;
        if (email == null || email.isEmpty) {
          state = state.copyWith(isSyncing: false, isSynced: false);
          return;
        }

        debugPrint('HybridAuth: Sincronizando con CRM para: $email');

        // Usar getOrCreateContact que maneja todo automáticamente
        final contact = await _crmService.getOrCreateContact(
          email: email,
          firstName: firebaseUser.displayName?.split(' ').firstOrNull,
          lastName: firebaseUser.displayName?.split(' ').skip(1).join(' '),
          tags: ['app-user', 'firebase-auth'],
        );

        if (contact != null) {
          debugPrint('HybridAuth: Contacto CRM obtenido: ${contact.id}');

          // Agregar tag de app-user si no lo tiene (en background)
          if (!contact.tags.contains('app-user')) {
            _crmService
                .addTagsToContact(contact.id, ['app-user'])
                .then((_) => debugPrint('HybridAuth: Tag app-user agregado'))
                .catchError((_) => null);
          }

          // Actualizar estado del repositorio de CRM
          _ref
              .read(agentCRMRepositoryProvider.notifier)
              .setCurrentUserByEmail(email);
        }

        state = state.copyWith(
          crmContact: contact,
          isSynced: contact != null,
          isSyncing: false,
        );

        debugPrint(
            'HybridAuth: Sincronización completada. CRM Contact: ${contact?.id}');
      } catch (e) {
        debugPrint('HybridAuth: Error de sincronización: $e');
        state = state.copyWith(
          isSyncing: false,
          syncError: 'Error al sincronizar con CRM',
        );
      }
    });
  }

  /// Refresca la sincronización con CRM
  Future<void> refreshSync() async {
    final firebaseUser = state.firebaseUser;
    if (firebaseUser != null) {
      await _syncWithCRM(firebaseUser);
    }
  }

  /// Agrega tags al usuario actual en CRM
  /// Esto puede disparar workflows automáticos (CloseBot, Twilio, GPT, etc)
  Future<bool> addTags(List<String> tags) async {
    if (state.crmContact == null) return false;

    try {
      final success =
          await _crmService.addTagsToContact(state.crmContact!.id, tags);

      if (success) {
        // Actualizar estado local
        final updatedTags = [...state.crmContact!.tags, ...tags];
        final updatedContact = AgentCRMContact(
          id: state.crmContact!.id,
          email: state.crmContact!.email,
          firstName: state.crmContact!.firstName,
          lastName: state.crmContact!.lastName,
          phone: state.crmContact!.phone,
          tags: updatedTags.toSet().toList(), // Eliminar duplicados
          customFields: state.crmContact!.customFields,
        );
        state = state.copyWith(crmContact: updatedContact);
        debugPrint('HybridAuth: Tags agregados: $tags');
      }

      return success;
    } catch (e) {
      debugPrint('HybridAuth: Error al agregar tags: $e');
      return false;
    }
  }

  /// Actualiza el perfil del usuario en CRM
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    if (state.crmContact == null) return false;

    try {
      final updated = await _crmService.updateContact(
        state.crmContact!.id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      if (updated != null) {
        state = state.copyWith(crmContact: updated);
        debugPrint('HybridAuth: Perfil actualizado');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('HybridAuth: Error al actualizar perfil: $e');
      return false;
    }
  }

  /// Registra interés en un curso (agrega tag específico)
  Future<bool> registerCourseInterest(
      String courseId, String courseName) async {
    final tag = 'interested-$courseId';
    return addTags([tag, 'course-interest']);
  }

  /// Marca usuario como inscrito a un curso
  Future<bool> markCourseEnrollment(String courseId, String courseName) async {
    final tag = 'enrolled-$courseId';
    return addTags([tag, 'active-student']);
  }
}

// ==================== Providers ====================

/// Provider principal para autenticación híbrida
final hybridAuthProvider =
    StateNotifierProvider<HybridAuthNotifier, HybridUserState>((ref) {
  return HybridAuthNotifier(ref);
});

/// Provider para verificar si está autenticado (Firebase)
final isHybridAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(hybridAuthProvider).isAuthenticated;
});

/// Provider para verificar si está sincronizado con CRM
final isInCRMProvider = Provider<bool>((ref) {
  return ref.watch(hybridAuthProvider).isInCRM;
});

/// Provider para verificar si está sincronizando
final isSyncingCRMProvider = Provider<bool>((ref) {
  return ref.watch(hybridAuthProvider).isSyncing;
});

/// Provider para obtener el email del usuario
final userEmailProvider = Provider<String?>((ref) {
  return ref.watch(hybridAuthProvider).email;
});

/// Provider para obtener el nombre de display
final userDisplayNameProvider = Provider<String>((ref) {
  return ref.watch(hybridAuthProvider).displayName;
});

/// Provider para obtener los tags del usuario
final userTagsProvider = Provider<List<String>>((ref) {
  return ref.watch(hybridAuthProvider).tags;
});

/// Provider para verificar si el usuario tiene un tag específico
final userHasTagProvider = Provider.family<bool, String>((ref, tagName) {
  final tags = ref.watch(userTagsProvider);
  return tags.any((t) => t.toLowerCase() == tagName.toLowerCase());
});

/// Provider para obtener el ID del contacto CRM
final crmContactIdProvider = Provider<String?>((ref) {
  return ref.watch(hybridAuthProvider).crmContactId;
});
