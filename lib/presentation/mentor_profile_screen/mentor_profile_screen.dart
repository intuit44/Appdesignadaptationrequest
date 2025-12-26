import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import 'scrollview_one_tab5_page.dart';

class MentorProfileScreen extends ConsumerStatefulWidget {
  const MentorProfileScreen({Key? key}) : super(key: key);

  @override
  MentorProfileScreenState createState() => MentorProfileScreenState();
}

// ignore_for_file: must_be_immutable
class MentorProfileScreenState extends ConsumerState<MentorProfileScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;

  int tabIndex = 0;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Column(children: [_buildProfileOverview(context)]),
                  ),
                ];
              },
              body: SizedBox(
                height: 2474.h,
                child: TabBarView(
                  controller: tabviewController,
                  children: [
                    ScrollviewOneTab5Page(),
                    ScrollviewOneTab5Page(),
                    ScrollviewOneTab5Page(),
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
  Widget _buildProfileOverview(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(
          height: 52.h,
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
            AppbarSubtitle(text: "lbl_menu".tr),
            AppbarTrailingImage(
              imagePath: ImageConstant.imgBars24Outline,
              height: 30.h,
              width: 30.h,
              margin: EdgeInsets.only(left: 11.h, right: 19.h),
            ),
          ],
        ),
        SizedBox(height: 26.h),
        SizedBox(
          height: 178.h,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 112.h,
                  width: 374.h,
                  decoration: BoxDecoration(
                    color: appTheme.red5002,
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                ),
              ),
              CustomImageView(
                imagePath: ImageConstant.imgBg,
                height: 130.h,
                width: 132.h,
                radius: BorderRadius.circular(10.h),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            children: [
              Text(
                "lbl_kritsin_watson".tr,
                style: CustomTextStyles.headlineSmallMedium,
              ),
              SizedBox(height: 4.h),
              Text("msg_founder_mentor".tr, style: theme.textTheme.titleMedium),
              SizedBox(height: 16.h),
              CustomElevatedButton(
                text: "lbl_contact_now".tr,
                margin: EdgeInsets.symmetric(horizontal: 80.h),
                buttonTextStyle: CustomTextStyles.titleMediumWhiteA700,
              ),
              SizedBox(height: 30.h),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.h),
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
                      child: _buildExperienceInfo(
                        context,
                        experienceTitle: "lbl_total_course".tr,
                        experienceDuration: "lbl_30".tr,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "lbl_ratings".tr,
                            style: CustomTextStyles.titleMediumSemiBold,
                          ),
                          Spacer(),
                          CustomImageView(
                            imagePath: ImageConstant.imgSignal,
                            height: 14.h,
                            width: 16.h,
                            alignment: Alignment.topCenter,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "lbl_4_92".tr,
                                  style: CustomTextStyles.titleMediumGray90001,
                                ),
                                TextSpan(
                                  text: "lbl_153".tr,
                                  style: CustomTextStyles
                                      .titleMediumPrimarySemiBold
                                      .copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text: "lbl3".tr,
                                  style: CustomTextStyles.titleMediumGray90001,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: _buildExperienceInfo(
                        context,
                        experienceTitle: "lbl_experiences".tr,
                        experienceDuration: "lbl_10_years".tr,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: _buildExperienceInfo(
                        context,
                        experienceTitle: "lbl_grauduated".tr,
                        experienceDuration: "lbl_yes".tr,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: _buildExperienceInfo(
                        context,
                        experienceTitle: "lbl_language".tr,
                        experienceDuration: "lbl_english_french".tr,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "lbl_social".tr,
                              style: CustomTextStyles.titleMediumSemiBold,
                            ),
                          ),
                          Spacer(),
                          CustomImageView(
                            imagePath: ImageConstant.imgFacebookGray90001,
                            height: 16.h,
                            width: 18.h,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgInfo,
                            height: 26.h,
                            width: 28.h,
                            margin: EdgeInsets.only(left: 12.h),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgTwitterLogoGray90001,
                            height: 12.h,
                            width: 18.h,
                            margin: EdgeInsets.only(left: 12.h),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgLinkedinIconGray90001,
                            height: 14.h,
                            width: 18.h,
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(left: 12.h, bottom: 4.h),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.maxFinite,
                child: TabBar(
                  controller: tabviewController,
                  labelPadding: EdgeInsets.zero,
                  labelColor: appTheme.whiteA700,
                  labelStyle: TextStyle(
                    fontSize: 14.fSize,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelColor: appTheme.gray90001,
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.fSize,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(
                      height: 40,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        margin: EdgeInsets.only(right: 6.h),
                        decoration: tabIndex == 0
                            ? BoxDecoration(
                                color: appTheme.orange20002,
                                borderRadius: BorderRadius.circular(5.h),
                              )
                            : BoxDecoration(
                                color: appTheme.whiteA700,
                                borderRadius: BorderRadius.circular(5.h),
                              ),
                        child: Text("lbl_about".tr),
                      ),
                    ),
                    Tab(
                      height: 40,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        margin: EdgeInsets.symmetric(horizontal: 6.h),
                        decoration: tabIndex == 1
                            ? BoxDecoration(
                                color: appTheme.orange20002,
                                borderRadius: BorderRadius.circular(5.h),
                              )
                            : BoxDecoration(
                                color: appTheme.whiteA700,
                                borderRadius: BorderRadius.circular(5.h),
                              ),
                        child: Text("lbl_courses".tr),
                      ),
                    ),
                    Tab(
                      height: 40,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        margin: EdgeInsets.only(left: 6.h),
                        decoration: tabIndex == 2
                            ? BoxDecoration(
                                color: appTheme.orange20002,
                                borderRadius: BorderRadius.circular(5.h),
                              )
                            : BoxDecoration(
                                color: appTheme.whiteA700,
                                borderRadius: BorderRadius.circular(5.h),
                              ),
                        child: Text("lbl_reviews".tr),
                      ),
                    ),
                  ],
                  indicatorColor: Colors.transparent,
                  onTap: (index) {
                    tabIndex = index;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Common widget
  Widget _buildExperienceInfo(
    BuildContext context, {
    required String experienceTitle,
    required String experienceDuration,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          experienceTitle,
          style: CustomTextStyles.titleMediumSemiBold.copyWith(
            color: appTheme.gray700,
          ),
        ),
        Text(
          experienceDuration,
          style: CustomTextStyles.titleMediumGray90001SemiBold.copyWith(
            color: appTheme.gray90001,
          ),
        ),
      ],
    );
  }
}
