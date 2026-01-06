// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../core/providers/auth_state_provider.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_checkbox_button.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/sign_in_notifier.dart';

class SignInDialog extends ConsumerStatefulWidget {
  const SignInDialog({super.key});

  @override
  SignInDialogState createState() => SignInDialogState();
}

class SignInDialogState extends ConsumerState<SignInDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios en el estado de autenticación
    ref.watch(authStateProvider);

    // Mostrar error si existe
    ref.listen<GlobalAuthState>(authStateProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(authStateProvider.notifier).clearError();
      }

      // Si se autenticó exitosamente, cerrar el diálogo y navegar
      if (next.isAuthenticated && previous?.isAuthenticated != true) {
        Navigator.of(context).pop();
        NavigatorService.pushNamedAndRemoveUntil(AppRoutes.homeScreen);
      }
    });

    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Container(
                    width: double.maxFinite,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.h, vertical: 98.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.only(
                            left: 20.h,
                            top: 30.h,
                            right: 20.h,
                          ),
                          decoration: BoxDecoration(
                            color: appTheme.whiteA700,
                            borderRadius: BorderRadiusStyle.roundedBorder5,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildSignupWithGoogleButton(context),
                              SizedBox(height: 26.h),
                              Container(
                                width: double.maxFinite,
                                margin: EdgeInsets.symmetric(horizontal: 20.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 1.h,
                                        margin: EdgeInsets.only(top: 2.h),
                                        decoration: BoxDecoration(
                                          color: appTheme.gray700,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.h),
                                      child: Text(
                                        "msg_or_sign_in_with".tr,
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1.h,
                                        margin: EdgeInsets.only(top: 2.h),
                                        decoration: BoxDecoration(
                                          color: appTheme.gray700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 28.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "lbl_email".tr,
                                  style:
                                      CustomTextStyles.titleMediumGray90001_1,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              _buildEmailInputField(context),
                              SizedBox(height: 20.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "lbl_passord".tr,
                                  style:
                                      CustomTextStyles.titleMediumGray90001_1,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              _buildPasswordInputField(context),
                              SizedBox(height: 30.h),
                              _buildSignUpButton(context),
                              SizedBox(height: 22.h),
                              _buildKeepMeSignedInCheckbox(context),
                              SizedBox(height: 40.h),
                              Text(
                                "msg_forgot_password".tr,
                                style: CustomTextStyles.titleSmallGray700_1,
                              ),
                              SizedBox(height: 4.h),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSignupWithGoogleButton(BuildContext context) {
    final isLoading = ref.watch(authStateProvider).isLoading;

    return CustomOutlinedButton(
      text: isLoading ? "msg_signing_in".tr : "msg_signup_with_google".tr,
      onPressed: isLoading ? null : () => _handleGoogleSignIn(),
      leftIcon: Container(
        padding: EdgeInsets.all(8.h),
        margin: EdgeInsets.only(right: 14.h),
        decoration: BoxDecoration(
          color: appTheme.red60002,
          borderRadius: BorderRadius.circular(6.h),
        ),
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : CustomImageView(
                imagePath: ImageConstant.imgGoogleplus11,
                height: 24.h,
                width: 24.h,
                fit: BoxFit.contain,
              ),
      ),
      buttonStyle: CustomButtonStyles.outlineGray,
      buttonTextStyle: theme.textTheme.bodyLarge!,
    );
  }

  Future<void> _handleGoogleSignIn() async {
    await ref.read(authStateProvider.notifier).signInWithGoogle();
  }

  /// Section Widget
  Widget _buildEmailInputField(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(signInNotifier).emailInputFieldController,
          hintText: "msg_user_example_com".tr,
          textInputType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          prefix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgMessage24Outline,
              height: 22.h,
              width: 18.h,
              fit: BoxFit.contain,
            ),
          ),
          prefixConstraints: BoxConstraints(maxHeight: 50.h),
          contentPadding: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
          borderDecoration: TextFormFieldStyleHelper.outlineGray,
          fillColor: appTheme.whiteA700,
          validator: (value) {
            if (value == null || (!isValidEmail(value, isRequired: true))) {
              return "err_msg_please_enter_valid_email".tr;
            }
            return null;
          },
        );
      },
    );
  }

  /// Section Widget
  Widget _buildPasswordInputField(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(signInNotifier).passwordInputFieldController,
          hintText: "lbl".tr,
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.visiblePassword,
          autofillHints: const [AutofillHints.password],
          prefix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
            child: CustomImageView(
              imagePath: ImageConstant
                  .imgLockpadLocksafesecurityprotectedlockAlt24Outline,
              height: 22.h,
              width: 18.h,
              fit: BoxFit.contain,
            ),
          ),
          prefixConstraints: BoxConstraints(maxHeight: 50.h),
          suffix: InkWell(
            onTap: () {
              ref.read(signInNotifier.notifier).changePasswordVisibility();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgEye11,
                height: 22.h,
                width: 18.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          suffixConstraints: BoxConstraints(maxHeight: 50.h),
          obscureText: ref.watch(signInNotifier).isShowPassword,
          contentPadding: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
          borderDecoration: TextFormFieldStyleHelper.outlineGray,
          fillColor: appTheme.whiteA700,
          validator: (value) {
            if (value == null || (!isValidPassword(value, isRequired: true))) {
              return "err_msg_please_enter_valid_password".tr;
            }
            return null;
          },
        );
      },
    );
  }

  /// Section Widget
  Widget _buildSignUpButton(BuildContext context) {
    final isLoading = ref.watch(authStateProvider).isLoading;

    return CustomElevatedButton(
      text: isLoading ? "msg_signing_in".tr : "lbl_sign_in".tr,
      buttonTextStyle: CustomTextStyles.titleMediumWhiteA700,
      onPressed: isLoading ? null : () => _handleEmailSignIn(),
    );
  }

  Future<void> _handleEmailSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final signInState = ref.read(signInNotifier);
      final email = signInState.emailInputFieldController?.text ?? '';
      final password = signInState.passwordInputFieldController?.text ?? '';

      await ref.read(authStateProvider.notifier).signInWithEmail(
            email: email,
            password: password,
          );
    }
  }

  /// Section Widget
  Widget _buildKeepMeSignedInCheckbox(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Consumer(
        builder: (context, ref, _) {
          return CustomCheckboxButton(
            alignment: Alignment.centerLeft,
            text: "msg_keep_me_signed_in".tr,
            value: ref.watch(signInNotifier).keepMeSignedInCheckbox,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            onChange: (value) {
              ref.read(signInNotifier.notifier).changeCheckBox(value);
            },
          );
        },
      ),
    );
  }
}
