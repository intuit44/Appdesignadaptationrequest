part of 'sign_in_notifier.dart';

/// Represents the state of SignIn in the application.

// ignore_for_file: must_be_immutable
class SignInState extends Equatable {
  SignInState({
    this.emailInputFieldController,
    this.passwordInputFieldController,
    this.isShowPassword = true,
    this.keepMeSignedInCheckbox = false,
    this.signInModelObj,
  });

  TextEditingController? emailInputFieldController;

  TextEditingController? passwordInputFieldController;

  SignInModel? signInModelObj;

  bool isShowPassword;

  bool keepMeSignedInCheckbox;

  @override
  List<Object?> get props => [
    emailInputFieldController,
    passwordInputFieldController,
    isShowPassword,
    keepMeSignedInCheckbox,
    signInModelObj,
  ];
  SignInState copyWith({
    TextEditingController? emailInputFieldController,
    TextEditingController? passwordInputFieldController,
    bool? isShowPassword,
    bool? keepMeSignedInCheckbox,
    SignInModel? signInModelObj,
  }) {
    return SignInState(
      emailInputFieldController:
          emailInputFieldController ?? this.emailInputFieldController,
      passwordInputFieldController:
          passwordInputFieldController ?? this.passwordInputFieldController,
      isShowPassword: isShowPassword ?? this.isShowPassword,
      keepMeSignedInCheckbox:
          keepMeSignedInCheckbox ?? this.keepMeSignedInCheckbox,
      signInModelObj: signInModelObj ?? this.signInModelObj,
    );
  }
}
