import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/sign_up_model.dart';
part 'sign_up_state.dart';

final signUpNotifier =
    StateNotifierProvider.autoDispose<SignUpNotifier, SignUpState>(
      (ref) => SignUpNotifier(
        SignUpState(
          fullNameInputController: TextEditingController(),
          emailInputController: TextEditingController(),
          passwordInputController: TextEditingController(),
          isShowPassword: true,
          termsConditionsCheckbox: false,
        ),
      ),
    );

/// A notifier that manages the state of a SignUp according to the event that is dispatched to it.
class SignUpNotifier extends StateNotifier<SignUpState> {
  SignUpNotifier(SignUpState state) : super(state);

  void changePasswordVisibility() {
    state = state.copyWith(isShowPassword: !(state.isShowPassword ?? false));
  }

  void changeCheckBox(bool value) {
    state = state.copyWith(termsConditionsCheckbox: value);
  }
}
