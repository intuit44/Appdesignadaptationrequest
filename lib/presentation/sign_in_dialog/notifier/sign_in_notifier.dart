import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/sign_in_model.dart';
part 'sign_in_state.dart';

final signInNotifier =
    StateNotifierProvider.autoDispose<SignInNotifier, SignInState>(
      (ref) => SignInNotifier(
        SignInState(
          emailInputFieldController: TextEditingController(),
          passwordInputFieldController: TextEditingController(),
          isShowPassword: true,
          keepMeSignedInCheckbox: false,
        ),
      ),
    );

/// A notifier that manages the state of a SignIn according to the event that is dispatched to it.
class SignInNotifier extends StateNotifier<SignInState> {
  SignInNotifier(SignInState state) : super(state);

  void changePasswordVisibility() {
    state = state.copyWith(isShowPassword: !(state.isShowPassword ?? false));
  }

  void changeCheckBox(bool value) {
    state = state.copyWith(keepMeSignedInCheckbox: value);
  }
}
