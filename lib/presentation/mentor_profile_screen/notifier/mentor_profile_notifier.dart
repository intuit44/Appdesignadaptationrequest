import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/mentor_profile_model.dart';
import '../models/scrollview_one_tab5_model.dart';
part 'mentor_profile_state.dart';

final mentorProfileNotifier = StateNotifierProvider.autoDispose<
  MentorProfileNotifier,
  MentorProfileState
>(
  (ref) => MentorProfileNotifier(
    MentorProfileState(
      emailController: TextEditingController(),
      scrollviewOneTab5ModelObj: const ScrollviewOneTab5Model(),
    ),
  ),
);

/// A notifier that manages the state of a MentorProfile according to the event that is dispatched to it.
class MentorProfileNotifier extends StateNotifier<MentorProfileState> {
  MentorProfileNotifier(super.state);
}
