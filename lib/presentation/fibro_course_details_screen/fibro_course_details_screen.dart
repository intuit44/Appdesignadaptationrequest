import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/listmaths_item_model.dart';
import 'models/listthethree1_item_model.dart';
import 'notifier/fibro_course_details_notifier.dart';
import 'widgets/listmaths_item_widget.dart';
import 'widgets/listthethree1_item_widget.dart';

class FibroCourseDetailsScreen extends ConsumerStatefulWidget {
  const FibroCourseDetailsScreen({super.key});

  @override
  FibroCourseDetailsScreenState createState() =>
      FibroCourseDetailsScreenState();
}

// ignore_for_file: must_be_immutable
class FibroCourseDetailsScreenState
    extends ConsumerState<FibroCourseDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildNavigationBar(context),
        body: Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Column(
                        children: [
                          _buildHomeSection(context),
                          SizedBox(height: 60.h),
                          _buildCourseSummary(context),
                          SizedBox(height: 60.h),
                          _buildCourseDetails(context),
                          SizedBox(height: 60.h),
                          _buildPopularBooks(context),
                          SizedBox(height: 60.h),
                          _buildSubscribeSection(context),
                        ],
                      ),
                    ),
                    _buildFooter(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildNavigationBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgGroup7623,
        margin: EdgeInsets.only(left: 20.h),
      ),
      title: AppbarTitle(
        text: "lbl_educatsy".tr,
        margin: EdgeInsets.only(left: 8.h),
      ),
      actions: [
        AppbarSubtitle(
          text: "lbl_menu".tr,
          onTap: () {
            NavigatorService.pushNamed(AppRoutes.appNavigationScreen);
          },
        ),
        AppbarTrailingImage(
          imagePath: ImageConstant.imgBars24Outline,
          height: 30.h,
          width: 30.h,
          margin: EdgeInsets.only(left: 11.h, right: 19.h),
          onTap: () {
            NavigatorService.pushNamed(AppRoutes.appNavigationScreen);
          },
        ),
      ],
      styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildHomeSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 18.h),
      decoration: BoxDecoration(
        color: appTheme.gray200,
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "lbl_home2".tr,
                  style: CustomTextStyles.titleMediumBlack90001_1,
                ),
                TextSpan(
                  text: "msg_become_an_instructor".tr,
                  style: CustomTextStyles.titleMediumPrimary_2,
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 16.h),
          Container(
            height: 230.h,
            width: double.maxFinite,
            margin: EdgeInsets.only(left: 2.h, right: 4.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgPexelsVanessaGarcia6325959230x298,
                  height: 230.h,
                  width: double.maxFinite,
                  radius: BorderRadius.circular(20.h),
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
          SizedBox(height: 14.h),
          SizedBox(
            width: 264.h,
            child: Text(
              "msg_maths_for_standard".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.headlineSmallBlack9000124.copyWith(
                height: 1.25,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Consumer(
            builder: (context, ref, _) {
              return ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10.h);
                },
                itemCount: ref
                        .watch(fibroCourseDetailsNotifier)
                        .fibroCourseDetailsModelObj
                        ?.listmathsItemList
                        .length ??
                    0,
                itemBuilder: (context, index) {
                  ListmathsItemModel model = ref
                          .watch(fibroCourseDetailsNotifier)
                          .fibroCourseDetailsModelObj
                          ?.listmathsItemList[index] ??
                      ListmathsItemModel();
                  return ListmathsItemWidget(model);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCourseSummary(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
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
                SizedBox(
                  width: double.maxFinite,
                  child: _buildFour(
                    context,
                    instructorTitle: "lbl_total_course".tr,
                    instructorName: "lbl_49_00".tr,
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildFour(
                    context,
                    instructorTitle: "lbl_instructor".tr,
                    instructorName: "lbl_wade_warren".tr,
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "lbl_ratings".tr,
                          style: CustomTextStyles.titleMediumSemiBold,
                        ),
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgClose,
                        height: 14.h,
                        width: 84.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildFour(
                    context,
                    instructorTitle: "lbl_durations".tr,
                    instructorName: "lbl_10_days".tr,
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildFour(
                    context,
                    instructorTitle: "lbl_lessons".tr,
                    instructorName: "lbl_30".tr,
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildFour(
                    context,
                    instructorTitle: "lbl_quzzes".tr,
                    instructorName: "lbl_5".tr,
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildFour(
                    context,
                    instructorTitle: "lbl_certifcate".tr,
                    instructorName: "lbl_yes".tr,
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildFour(
                    context,
                    instructorTitle: "lbl_language".tr,
                    instructorName: "lbl_english".tr,
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildFour(
                    context,
                    instructorTitle: "lbl_access".tr,
                    instructorName: "lbl_lifetime".tr,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          CustomElevatedButton(
            text: "lbl_purchase_course".tr,
            buttonTextStyle: CustomTextStyles.titleMediumWhiteA700,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCourseDetails(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(right: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_course_details".tr,
            style: CustomTextStyles.headlineSmall24,
          ),
          SizedBox(height: 12.h),
          Text(
            "msg_lorem_ipsum_dolor".tr,
            maxLines: 14,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge!.copyWith(height: 1.50),
          ),
          SizedBox(height: 46.h),
          Text("lbl_certification".tr, style: CustomTextStyles.headlineSmall24),
          SizedBox(height: 12.h),
          Text(
            "msg_lorem_ipsum_dolor2".tr,
            maxLines: 7,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge!.copyWith(height: 1.50),
          ),
          SizedBox(height: 46.h),
          Text(
            "msg_who_this_course".tr,
            style: CustomTextStyles.headlineSmall24,
          ),
          SizedBox(height: 16.h),
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
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text(
                            "msg_lorem_ipsum_dolor3".tr,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8.h,
                        width: 8.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text(
                            "msg_lorem_ipsum_dolor3".tr,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8.h,
                        width: 8.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text(
                            "msg_lorem_ipsum_dolor3".tr,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8.h,
                        width: 8.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text(
                            "msg_lorem_ipsum_dolor3".tr,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8.h,
                        width: 8.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text(
                            "msg_lorem_ipsum_dolor3".tr,
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
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPopularBooks(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("lbl_popular_books".tr, style: CustomTextStyles.headlineSmall24),
          SizedBox(height: 16.h),
          Consumer(
            builder: (context, ref, _) {
              return ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10.h);
                },
                itemCount: ref
                        .watch(fibroCourseDetailsNotifier)
                        .fibroCourseDetailsModelObj
                        ?.listthethree1ItemList
                        .length ??
                    0,
                itemBuilder: (context, index) {
                  Listthethree1ItemModel model = ref
                          .watch(fibroCourseDetailsNotifier)
                          .fibroCourseDetailsModelObj
                          ?.listthethree1ItemList[index] ??
                      Listthethree1ItemModel();
                  return Listthethree1ItemWidget(model);
                },
              );
            },
          ),
          SizedBox(height: 16.h),
          Text("lbl_see_more".tr, style: CustomTextStyles.titleMediumPrimary),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSubscribeSection(BuildContext context) {
    return Container(
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
            style: CustomTextStyles.bodyLargeWhiteA700.copyWith(height: 1.50),
          ),
          SizedBox(height: 28.h),
          Consumer(
            builder: (context, ref, _) {
              return CustomTextFormField(
                controller:
                    ref.watch(fibroCourseDetailsNotifier).emailController,
                hintText: "msg_enter_your_email".tr,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.emailAddress,
                contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
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
    );
  }

  /// Section Widget
  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 46.h),
      decoration: BoxDecoration(color: appTheme.gray100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgFacebook,
                  height: 22.h,
                  width: 22.h,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.h),
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgUserDeepOrange400,
                          height: 36.h,
                          width: 36.h,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgTwitterLogo,
                          height: 16.h,
                          width: 22.h,
                          margin: EdgeInsets.only(left: 14.h),
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
          Text("lbl_courses".tr, style: theme.textTheme.titleLarge),
          SizedBox(height: 18.h),
          Text("msg_classroom_courses".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 14.h),
          Text("msg_virtual_classroom".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("msg_e_learning_courses".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 14.h),
          Text("lbl_video_courses".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 14.h),
          Text("lbl_offline_courses".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 26.h),
          Text("lbl_quick_links".tr, style: theme.textTheme.titleLarge),
          SizedBox(height: 18.h),
          Text("lbl_home".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 14.h),
          Text(
            "msg_professional_education".tr,
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(height: 16.h),
          Text("lbl_courses".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 14.h),
          Text("lbl_admissions".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_testimonial".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_programs".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 24.h),
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

  /// Common widget
  Widget _buildFour(
    BuildContext context, {
    required String instructorTitle,
    required String instructorName,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          instructorTitle,
          style: CustomTextStyles.titleMediumSemiBold.copyWith(
            color: appTheme.gray700,
          ),
        ),
        Text(
          instructorName,
          style: CustomTextStyles.titleMediumGray90001SemiBold.copyWith(
            decoration: TextDecoration.underline,
            color: appTheme.gray90001,
          ),
        ),
      ],
    );
  }
}
