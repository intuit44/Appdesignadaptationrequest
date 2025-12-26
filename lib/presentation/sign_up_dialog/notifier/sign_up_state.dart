part of 'sign_up_notifier.dart';

/// Represents the state of SignUp in the application.

// ignore_for_file: must_be_immutable
class SignUpState extends Equatable {
  SignUpState({
    this.fullNameInputController,
    this.emailInputController,
    this.passwordInputController,
    this.isShowPassword = true,
    this.termsConditionsCheckbox = false,
    this.signUpModelObj,
  });

  TextEditingController? fullNameInputController;

  TextEditingController? emailInputController;

  TextEditingController? passwordInputController;

  SignUpModel? signUpModelObj;

  bool isShowPassword;

  bool termsConditionsCheckbox;

  @override
  List<Object?> get props => [
    fullNameInputController,
    emailInputController,
    passwordInputController,
    isShowPassword,
    termsConditionsCheckbox,
    signUpModelObj,
  ];
  SignUpState copyWith({
    TextEditingController? fullNameInputController,
    TextEditingController? emailInputController,
    TextEditingController? passwordInputController,
    bool? isShowPassword,
    bool? termsConditionsCheckbox,
    SignUpModel? signUpModelObj,
  }) {
    return SignUpState(
      fullNameInputController:
          fullNameInputController ?? this.fullNameInputController,
      emailInputController: emailInputController ?? this.emailInputController,
      passwordInputController:
          passwordInputController ?? this.passwordInputController,
      isShowPassword: isShowPassword ?? this.isShowPassword,
      termsConditionsCheckbox:
          termsConditionsCheckbox ?? this.termsConditionsCheckbox,
      signUpModelObj: signUpModelObj ?? this.signUpModelObj,
    );
  }
}
