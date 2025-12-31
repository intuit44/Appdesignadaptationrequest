import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/become_an_instructor_notifier.dart';

class ScrollviewOneTab3Page extends ConsumerStatefulWidget {
  const ScrollviewOneTab3Page({super.key});

  @override
  ScrollviewOneTab3PageState createState() => ScrollviewOneTab3PageState();
}

class ScrollviewOneTab3PageState extends ConsumerState<ScrollviewOneTab3Page> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: 30.h),
        child: Column(
          children: [
            _buildApplicationSection(context),
            _buildFooterSection(context),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildApplicationSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8.h,
                        width: 8.h,
                        margin: EdgeInsets.only(top: 2.h),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 12.h),
                          child: Text(
                            "msg_an_undergraduate".tr,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8.h,
                        width: 8.h,
                        margin: EdgeInsets.only(top: 2.h),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 12.h),
                          child: Text(
                            "msg_participate_in_supervised".tr,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8.h,
                        width: 8.h,
                        margin: EdgeInsets.only(top: 2.h),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 12.h),
                          child: Text(
                            "msg_state_teaching_license".tr,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8.h,
                        width: 8.h,
                        margin: EdgeInsets.only(top: 2.h),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 12.h),
                          child: Text(
                            "msg_purse_graduate_studies".tr,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 26.h),
          CustomElevatedButton(
            width: 122.h,
            text: "lbl_apply_now".tr,
            buttonTextStyle: theme.textTheme.titleSmall!,
            alignment: Alignment.centerLeft,
          ),
          SizedBox(height: 36.h),
          Text(
            "msg_how_to_apply_to".tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: CustomTextStyles.headlineMediumGray90001.copyWith(
              height: 1.36,
            ),
          ),
          SizedBox(height: 22.h),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
              color: appTheme.whiteA700,
              borderRadius: BorderRadiusStyle.roundedBorder10,
              boxShadow: [
                BoxShadow(
                  color: appTheme.black90001.withValues(alpha: 0.05),
                  spreadRadius: 2.h,
                  blurRadius: 2.h,
                  offset: const Offset(0, 50),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    color: appTheme.indigo50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusStyle.roundedBorder10,
                    ),
                    child: Container(
                      height: 230.h,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: appTheme.indigo50,
                        borderRadius: BorderRadiusStyle.roundedBorder10,
                        boxShadow: [
                          BoxShadow(
                            color: appTheme.black90001.withValues(alpha: 0.05),
                            spreadRadius: 2.h,
                            blurRadius: 2.h,
                            offset: const Offset(0, 50),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgGroup76251,
                            height: 218.h,
                            width: 262.h,
                          ),
                          CustomIconButton(
                            height: 40.h,
                            width: 40.h,
                            padding: EdgeInsets.all(12.h),
                            decoration: IconButtonStyleHelper.fillPrimaryTL20,
                            child: CustomImageView(
                              imagePath: ImageConstant.imgOverflowMenu,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 68.h),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 28.h, vertical: 34.h),
            decoration: BoxDecoration(
              color: appTheme.black900,
              borderRadius: BorderRadiusStyle.roundedBorder10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "msg_subscribe_for_get".tr,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium!.copyWith(height: 1.36),
                ),
                SizedBox(height: 8.h),
                Text(
                  "msg_20k_students_daily".tr,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.bodyLargeWhiteA700.copyWith(
                    height: 1.50,
                  ),
                ),
                SizedBox(height: 28.h),
                Consumer(
                  builder: (context, ref, _) {
                    return CustomTextFormField(
                      controller:
                          ref.watch(becomeAnInstructorNotifier).emailController,
                      hintText: "msg_enter_your_email".tr,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.emailAddress,
                      contentPadding: EdgeInsets.fromLTRB(
                        14.h,
                        16.h,
                        14.h,
                        14.h,
                      ),
                      validator: (value) {
                        if (value == null ||
                            (!isValidEmail(value, isRequired: true))) {
                          return "err_msg_please_enter_valid_email".tr;
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 20.h),
                CustomElevatedButton(
                  text: "lbl_subscribe".tr,
                  buttonTextStyle: theme.textTheme.titleSmall!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCoursesSection(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("lbl_courses".tr, style: theme.textTheme.titleLarge),
          SizedBox(height: 16.h),
          Text("msg_classroom_courses".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("msg_virtual_classroom".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("msg_e_learning_courses".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_video_courses".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_offline_courses".tr, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildQuickLinksSection(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("lbl_quick_links".tr, style: theme.textTheme.titleLarge),
          SizedBox(height: 16.h),
          Text("lbl_home".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text(
            "msg_professional_education".tr,
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(height: 16.h),
          Text("lbl_courses".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_admissions".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_testimonial".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_programs".tr, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildFooterSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 46.h),
      decoration: BoxDecoration(color: appTheme.gray100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgGroup7623,
                  height: 30.h,
                  width: 30.h,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.h),
                      child: Text(
                        "lbl_educatsy".tr,
                        style: theme.textTheme.headlineLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgFacebook,
                  height: 22.h,
                  width: 22.h,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgUserDeepOrange400,
                  height: 36.h,
                  width: 36.h,
                  margin: EdgeInsets.only(left: 14.h),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgTwitterLogo,
                  height: 16.h,
                  width: 22.h,
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(left: 14.h, top: 8.h),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgLinkedinIcon,
                  height: 18.h,
                  width: 22.h,
                  margin: EdgeInsets.only(left: 14.h),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Text("lbl_2021_educatsy".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 18.h),
          Text(
            "msg_educatsy_is_a_registered".tr,
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(height: 58.h),
          Text("lbl_community".tr, style: theme.textTheme.titleLarge),
          SizedBox(height: 16.h),
          Text("lbl_learners".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_parteners".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_developers".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 14.h),
          Text("lbl_transactions".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_blog".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 14.h),
          Text("lbl_teaching_center".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 24.h),
          _buildCoursesSection(context),
          SizedBox(height: 28.h),
          _buildQuickLinksSection(context),
          SizedBox(height: 26.h),
          Text("lbl_more".tr, style: theme.textTheme.titleLarge),
          SizedBox(height: 18.h),
          Text("lbl_press".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_investors".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_terms".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_privacy".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_help".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 14.h),
          Text("lbl_contact".tr, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
