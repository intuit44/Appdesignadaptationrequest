import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_checkbox_button.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/sign_up_notifier.dart';

class SignUpDialog extends ConsumerStatefulWidget {
  const SignUpDialog({Key? key}) : super(key: key);

  @override
  SignUpDialogState createState() => SignUpDialogState();
}

// ignore_for_file: must_be_immutable
class SignUpDialogState extends ConsumerState<SignUpDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 40.h),
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(20.h),
                      decoration: BoxDecoration(
                        color: appTheme.whiteA700,
                        borderRadius: BorderRadiusStyle.roundedBorder5,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildGoogleSignupButton(context),
                          SizedBox(height: 26.h),
                          Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.symmetric(horizontal: 20.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1.h,
                                    width: 20.h,
                                    margin: EdgeInsets.only(top: 8.h),
                                    decoration: BoxDecoration(
                                      color: appTheme.gray700,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.h),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "msg_or_signup_with_your".tr,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ),
                                SizedBox(width: 10.h),
                                Expanded(
                                  child: Container(
                                    height: 1.h,
                                    width: 20.h,
                                    margin: EdgeInsets.only(top: 8.h),
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
                              "lbl_full_name".tr,
                              style: CustomTextStyles.titleMediumGray90001_1,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          _buildFullNameInput(context),
                          SizedBox(height: 20.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "lbl_email".tr,
                              style: CustomTextStyles.titleMediumGray90001_1,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          _buildEmailInput(context),
                          SizedBox(height: 20.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "lbl_passord".tr,
                              style: CustomTextStyles.titleMediumGray90001_1,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          _buildPasswordInput(context),
                          SizedBox(height: 18.h),
                          _buildTermsConditionsCheckbox(context),
                          SizedBox(height: 22.h),
                          _buildSignUpButton(context),
                          SizedBox(height: 20.h),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "msg_alreay_have_account2".tr,
                                  style: theme.textTheme.titleMedium,
                                ),
                                TextSpan(
                                  text: "lbl_sign_in".tr,
                                  style: CustomTextStyles.titleMediumPrimary_1,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                    SizedBox(height: 46.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildGoogleSignupButton(BuildContext context) {
    return CustomOutlinedButton(
      text: "msg_signup_with_google".tr,
      leftIcon: Container(
        padding: EdgeInsets.all(8.h),
        margin: EdgeInsets.only(right: 14.h),
        decoration: BoxDecoration(
          color: appTheme.red60002,
          borderRadius: BorderRadius.circular(6.h),
        ),
        child: CustomImageView(
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

  /// Section Widget
  Widget _buildFullNameInput(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(signUpNotifier).fullNameInputController,
          hintText: "lbl_esther_howard".tr,
          autofillHints: const [AutofillHints.name],
          prefix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgAccount24Outline,
              height: 22.h,
              width: 18.h,
              fit: BoxFit.contain,
            ),
          ),
          prefixConstraints: BoxConstraints(maxHeight: 50.h),
          contentPadding: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
          borderDecoration: TextFormFieldStyleHelper.outlineGray,
          fillColor: appTheme.whiteA700,
        );
      },
    );
  }

  /// Section Widget
  Widget _buildEmailInput(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(signUpNotifier).emailInputController,
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
  Widget _buildPasswordInput(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(signUpNotifier).passwordInputController,
          hintText: "lbl".tr,
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.visiblePassword,
          autofillHints: const [AutofillHints.newPassword],
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
              ref.read(signUpNotifier.notifier).changePasswordVisibility();
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
          obscureText: ref.watch(signUpNotifier).isShowPassword,
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
  Widget _buildTermsConditionsCheckbox(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Consumer(
        builder: (context, ref, _) {
          return CustomCheckboxButton(
            alignment: Alignment.centerLeft,
            text: "msg_i_agreed_to_the".tr,
            value: ref.watch(signUpNotifier).termsConditionsCheckbox,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            textStyle: CustomTextStyles.titleSmallGray90001,
            onChange: (value) {
              ref.read(signUpNotifier.notifier).changeCheckBox(value);
            },
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildSignUpButton(BuildContext context) {
    return CustomElevatedButton(
      text: "lbl_sign_up".tr,
      buttonTextStyle: CustomTextStyles.titleMediumWhiteA700,
    );
  }
}
