import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_checkbox_button.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/sign_in_notifier.dart'; // ignore_for_file: must_be_immutable

class SignInDialog extends ConsumerStatefulWidget {
  const SignInDialog({Key? key}) : super(key: key);

  @override
  SignInDialogState createState() => SignInDialogState();
}

// ignore_for_file: must_be_immutable
class SignInDialogState extends ConsumerState<SignInDialog> {
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
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 98.h),
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
                                    "msg_or_sign_in_with".tr,
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
                              "lbl_email".tr,
                              style: CustomTextStyles.titleMediumGray90001_1,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          _buildEmailInputField(context),
                          SizedBox(height: 20.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "lbl_passord".tr,
                              style: CustomTextStyles.titleMediumGray90001_1,
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
      ],
    );
  }

  /// Section Widget
  Widget _buildSignupWithGoogleButton(BuildContext context) {
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
  Widget _buildEmailInputField(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(signInNotifier).emailInputFieldController,
          hintText: "msg_user_example_com".tr,
          textInputType: TextInputType.emailAddress,
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
          prefix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
            child: CustomImageView(
              imagePath:
                  ImageConstant
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
    return CustomElevatedButton(
      text: "lbl_sign_up".tr,
      buttonTextStyle: CustomTextStyles.titleMediumWhiteA700,
    );
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
