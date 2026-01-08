import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/services/agent_crm_service.dart';
import '../models/mentors_model.dart';
import '../models/mentorslist_item_model.dart';
import '../models/scrollview_one_tab4_model.dart';
part 'mentors_state.dart';

final mentorsNotifier =
    StateNotifierProvider.autoDispose<MentorsNotifier, MentorsState>(
  (ref) => MentorsNotifier(
    MentorsState(
      emailController: TextEditingController(),
      scrollviewOneTab4ModelObj: ScrollviewOneTab4Model(
        mentorslistItemList: [],
      ),
      isLoading: true,
    ),
    ref,
  ),
);

/// Provider para cargar mentores/usuarios desde el CRM de GoHighLevel
final crmUsersProvider =
    FutureProvider.autoDispose<List<MentorslistItemModel>>((ref) async {
  final crmService = AgentCRMService.instance;
  final users = await crmService.getUsers();

  return users
      .map((user) => MentorslistItemModel(
            id: user.id,
            founderMentor: ImageConstant.imgBg, // Default image
            kristinwatson:
                user.fullName.isNotEmpty ? user.fullName : 'Instructor',
            foundermentor1: _getRoleTitle(user.role),
            bio:
                'Instructor certificado en Fibro Academy especializado en técnicas de estética profesional.',
            specialties: user.permissions.take(3).toList(),
            email: user.email,
            phone: user.phone,
          ))
      .toList();
});

String _getRoleTitle(String? role) {
  if (role == null) return 'Instructor';
  switch (role.toLowerCase()) {
    case 'admin':
      return 'Director / Lead Instructor';
    case 'user':
      return 'Instructor Certificado';
    default:
      return role;
  }
}

/// A notifier that manages the state of a Mentors according to the event that is dispatched to it.
class MentorsNotifier extends StateNotifier<MentorsState> {
  // ignore: unused_field
  final Ref ref;

  MentorsNotifier(super.state, this.ref) {
    _loadMentors();
  }

  Future<void> _loadMentors() async {
    try {
      final crmService = AgentCRMService.instance;
      final users = await crmService.getUsers();

      final mentorItems = users
          .map((user) => MentorslistItemModel(
                id: user.id,
                founderMentor: ImageConstant.imgBg,
                kristinwatson:
                    user.fullName.isNotEmpty ? user.fullName : 'Instructor',
                foundermentor1: _getRoleTitle(user.role),
                bio:
                    'Instructor certificado en Fibro Academy con experiencia en técnicas de estética profesional.',
                specialties: user.permissions.take(3).toList(),
                email: user.email,
                phone: user.phone,
              ))
          .toList();

      state = state.copyWith(
        scrollviewOneTab4ModelObj: ScrollviewOneTab4Model(
          mentorslistItemList: mentorItems,
        ),
        isLoading: false,
      );
    } catch (e) {
      // En caso de error, usar datos de fallback
      state = state.copyWith(
        scrollviewOneTab4ModelObj: ScrollviewOneTab4Model(
          mentorslistItemList: [
            MentorslistItemModel(
              founderMentor: ImageConstant.imgBg,
              kristinwatson: "Fibro Academy Team",
              foundermentor1: "Equipo de Instructores",
              bio:
                  "Instructores certificados con experiencia en micropigmentación y estética.",
              specialties: ["Microblading", "Estética"],
            ),
          ],
        ),
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Recargar mentores desde CRM
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    await _loadMentors();
  }
}
