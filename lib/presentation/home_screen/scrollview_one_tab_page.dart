import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../core/providers/course_providers.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/course_card_widget.dart';
import 'notifier/home_notifier.dart';

class ScrollviewOneTabPage extends ConsumerStatefulWidget {
  const ScrollviewOneTabPage({super.key});

  @override
  ScrollviewOneTabPageState createState() => ScrollviewOneTabPageState();
}

class ScrollviewOneTabPageState extends ConsumerState<ScrollviewOneTabPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClassList(context),
                  SizedBox(height: 30.h),
                  _buildVisitMoreClassesButton(context),
                  SizedBox(height: 70.h),
                  _buildAdditionalInfo(context),
                  SizedBox(height: 70.h),
                  CustomImageView(
                    imagePath: ImageConstant.imgImage322x316,
                    height: 322.h,
                    width: double.maxFinite,
                    margin: EdgeInsets.symmetric(horizontal: 8.h),
                  ),
                  SizedBox(height: 52.h),
                  Text(
                    "msg_want_to_share_your_knowledge".tr,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.headlineMediumBlack90001.copyWith(
                      height: 1.36,
                    ),
                  ),
                  SizedBox(height: 22.h),
                  Text(
                    "msg_high_definition3".tr,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge!.copyWith(height: 1.50),
                  ),
                  SizedBox(height: 22.h),
                  _buildCareerInformationButton(context),
                  SizedBox(height: 42.h),
                  _buildSubscribeSection(context),
                ],
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  /// Section Widget - Muestra cursos reales de WooCommerce
  Widget _buildClassList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.h, right: 18.h),
      child: Consumer(
        builder: (context, ref, _) {
          final coursesState = ref.watch(courseRepositoryProvider);
          final courses = coursesState.courses;
          final isLoading = coursesState.isLoading;
          final error = coursesState.error;

          // Estado de carga
          if (isLoading && courses.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(40.h),
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: 16.h),
                    Text(
                      "msg_loading_courses".tr,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }

          // Estado de error
          if (error != null && courses.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(40.h),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48.h,
                      color: appTheme.red600,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "msg_error_loading".tr,
                      style: theme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 16.h),
                    CustomElevatedButton(
                      text: "Reintentar",
                      width: 150.h,
                      onPressed: () {
                        ref
                            .read(courseRepositoryProvider.notifier)
                            .loadCourses(refresh: true);
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          // Sin cursos
          if (courses.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(40.h),
                child: Text(
                  "msg_no_courses".tr,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            );
          }

          // Lista de cursos reales
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 14.h);
            },
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseCardWidget(
                course: course,
                onTap: () {
                  NavigatorService.pushNamed(
                    AppRoutes.fibroCourseDetailsScreen,
                    arguments: {'courseId': course.id},
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildVisitMoreClassesButton(BuildContext context) {
    return CustomElevatedButton(
      text: "msg_visit_more_classes".tr,
      margin: EdgeInsets.only(left: 80.h, right: 78.h),
      buttonTextStyle: theme.textTheme.titleSmall!,
    );
  }

  /// Section Widget
  Widget _buildCollegeLevelButton(BuildContext context) {
    return CustomElevatedButton(
      height: 44.h,
      width: 120.h,
      text: "lbl_college_level".tr,
      buttonStyle: CustomButtonStyles.fillBlack,
      buttonTextStyle: theme.textTheme.titleSmall!,
      alignment: Alignment.centerLeft,
    );
  }

  /// Section Widget
  Widget _buildRegistrationNowButton(BuildContext context) {
    return CustomElevatedButton(
      width: 150.h,
      text: "lbl_registation_now".tr,
      buttonTextStyle: theme.textTheme.titleSmall!,
      alignment: Alignment.centerLeft,
    );
  }

  /// Section Widget
  Widget _buildAdditionalInfo(BuildContext context) {
    return SizedBox(
      height: 818.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 8.h,
              width: 310.h,
              margin: EdgeInsets.only(bottom: 84.h),
              decoration: BoxDecoration(
                color: appTheme.black90001,
                borderRadius: BorderRadius.circular(154.h),
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 28.h),
            decoration: BoxDecoration(
              color: appTheme.red5002,
              borderRadius: BorderRadiusStyle.roundedBorder10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildCollegeLevelButton(context),
                SizedBox(height: 14.h),
                Text(
                  "msg_don_t_waste_time".tr,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.headlineMediumBlack90001.copyWith(
                    height: 1.36,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "msg_high_definition2".tr,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge!.copyWith(height: 1.50),
                ),
                SizedBox(height: 22.h),
                _buildRegistrationNowButton(context),
                SizedBox(height: 30.h),
                CustomImageView(
                  imagePath: ImageConstant.img6,
                  height: 30.h,
                  width: 32.h,
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 14.h),
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  height: 250.h,
                  width: double.maxFinite,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgImage,
                        height: 250.h,
                        width: double.maxFinite,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 4.h),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 14.h),
                                          child: CustomIconButton(
                                            height: 30.h,
                                            width: 30.h,
                                            padding: EdgeInsets.all(6.h),
                                            decoration: IconButtonStyleHelper
                                                .outlineGrayTL5,
                                            alignment: Alignment.bottomCenter,
                                            child: CustomImageView(
                                              imagePath: ImageConstant.imgHtml1,
                                            ),
                                          ),
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant.imgGrid,
                                          height: 30.h,
                                          width: 32.h,
                                          margin: EdgeInsets.only(right: 8.h),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
  Widget _buildCareerInformationButton(BuildContext context) {
    return CustomElevatedButton(
      width: 176.h,
      text: "msg_career_information".tr,
      buttonTextStyle: theme.textTheme.titleSmall!,
    );
  }

  /// Section Widget
  Widget _buildEmailInput(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(homeNotifier).emailInputController,
          hintText: "msg_enter_your_email".tr,
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.emailAddress,
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
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
  Widget _buildSubscribeButton(BuildContext context) {
    return CustomElevatedButton(
      text: "lbl_subscribe".tr,
      buttonTextStyle: theme.textTheme.titleSmall!,
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
          _buildEmailInput(context),
          SizedBox(height: 20.h),
          _buildSubscribeButton(context),
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
                SizedBox(width: 12.h),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "lbl_educatsy".tr,
                      style: theme.textTheme.headlineLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
}
