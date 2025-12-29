import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/become_an_instructor_model.dart';
import '../models/scrollview_one_tab3_model.dart';
part 'become_an_instructor_state.dart';

final becomeAnInstructorNotifier = StateNotifierProvider.autoDispose<
  BecomeAnInstructorNotifier,
  BecomeAnInstructorState
>(
  (ref) => BecomeAnInstructorNotifier(
    BecomeAnInstructorState(
      emailController: TextEditingController(),
      scrollviewOneTab3ModelObj: const ScrollviewOneTab3Model(),
    ),
  ),
);

/// A notifier that manages the state of a BecomeAnInstructor according to the event that is dispatched to it.
class BecomeAnInstructorNotifier
    extends StateNotifier<BecomeAnInstructorState> {
  BecomeAnInstructorNotifier(super.state);
}
