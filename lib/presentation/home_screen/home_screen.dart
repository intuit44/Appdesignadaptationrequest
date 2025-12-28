import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/chipviewone_two_item_model.dart';
import 'notifier/home_notifier.dart';
import 'scrollview_one_tab_page.dart';
import 'widgets/chipviewone_two_item_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

// ignore_for_file: must_be_immutable
class HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;

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
                    child: Column(children: [_buildMainContent(context)]),
                  ),
                ];
              },
              body: SizedBox(
                height: 6318.h,
                child: TabBarView(
                  controller: tabviewController,
                  children: [
                    Container(),
                    ScrollviewOneTabPage(),
                    ScrollviewOneTabPage(),
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
  Widget _buildCtaNeverStopLearning(BuildContext context) {
    return CustomElevatedButton(
      height: 44.h,
      width: 170.h,
      text: "msg_never_stop_learning".tr,
      buttonStyle: CustomButtonStyles.fillWhiteA,
      buttonTextStyle: CustomTextStyles.titleSmallDeeporange400,
      onPressed: () {
        // Template buttons ship without navigation wiring.
        // Send user to the demo navigation hub.
        NavigatorService.pushNamed(AppRoutes.appNavigationScreen);
      },
    );
  }

  /// Section Widget
  Widget _buildClassInput(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(homeNotifier).classInputController,
          hintText: "lbl_class_course".tr,
          hintStyle: CustomTextStyles.titleMediumGray700,
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          borderDecoration: TextFormFieldStyleHelper.fillWhiteA,
          fillColor: appTheme.whiteA700,
        );
      },
    );
  }

  /// Section Widget
  Widget _buildSearchButton(BuildContext context) {
    return CustomElevatedButton(
      text: "lbl_serach".tr,
      leftIcon: Container(
        margin: EdgeInsets.only(right: 8.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgMagnifier24Outline,
          height: 20.h,
          width: 20.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonTextStyle: CustomTextStyles.titleMediumWhiteA700,
      onPressed: () {
        // Reasonable default: take user to mentors list (example flow).
        NavigatorService.pushNamed(AppRoutes.mentorsScreen);
      },
    );
  }

  /// Section Widget
  Widget _buildVisitCoursesButton(BuildContext context) {
    return CustomElevatedButton(
      text: "lbl_visit_courses".tr,
      margin: EdgeInsets.only(left: 86.h, right: 72.h),
      buttonTextStyle: CustomTextStyles.titleMediumWhiteA700,
      onPressed: () {
        NavigatorService.pushNamed(AppRoutes.eduviCourseDetailsScreen);
      },
    );
  }

  /// Section Widget
  Widget _buildMainContent(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(
          leadingWidth: 40.h,
          leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgGroup7623,
            margin: EdgeInsets.only(left: 20.h),
          ),
          title: AppbarTitle(
            text: "lbl_educatsy".tr,
            margin: EdgeInsets.only(left: 8.h),
            onTap: () {
              NavigatorService.pushNamed(AppRoutes.appNavigationScreen);
            },
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
        ),
        SizedBox(height: 30.h),
        Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            children: [
              _buildCtaNeverStopLearning(context),
              SizedBox(height: 14.h),
              Text(
                "msg_grow_up_your_skills_by".tr,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.headlineLargeBold.copyWith(
                  height: 1.25,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "msg_eduvi_is_a_global".tr,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge!.copyWith(height: 1.88),
              ),
              SizedBox(height: 24.h),
              Consumer(
                builder: (context, ref, _) {
                  return CustomDropDown(
                    icon: Container(
                      margin: EdgeInsets.only(left: 16.h),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgArrowdown,
                        height: 22.h,
                        width: 24.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    iconSize: 22.h,
                    hintText: "lbl_kindergarten".tr,
                    items: ref
                            .watch(homeNotifier)
                            .homeModelObj
                            ?.dropdownItemList ??
                        [],
                    contentPadding: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
                  );
                },
              ),
              SizedBox(height: 12.h),
              _buildClassInput(context),
              SizedBox(height: 12.h),
              _buildSearchButton(context),
              SizedBox(height: 50.h),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(right: 12.h),
                child: Column(
                  children: [
                    SizedBox(
                      height: 338.h,
                      width: double.maxFinite,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgVector1,
                            height: 272.h,
                            width: 288.h,
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 18.h),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 0,
                              margin: EdgeInsets.only(right: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusStyle.customBorderTL58,
                              ),
                              child: Container(
                                height: 324.h,
                                width: 252.h,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusStyle.customBorderTL58,
                                  gradient: LinearGradient(
                                    begin: Alignment(0.5, 0.14),
                                    end: Alignment(0.5, 1),
                                    colors: [
                                      appTheme.orange20000,
                                      appTheme.orange20001,
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CustomImageView(
                                      imagePath: ImageConstant.imgSchoolBoyHold,
                                      height: 324.h,
                                      width: 204.h,
                                    ),
                                    SizedBox(
                                      height: 324.h,
                                      width: 204.h,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CustomImageView(
                                            imagePath: ImageConstant
                                                .imgSchoolBoyHold324x202,
                                            height: 324.h,
                                            width: double.maxFinite,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 14.h),
                                            child: CustomIconButton(
                                              height: 38.h,
                                              width: 38.h,
                                              padding: EdgeInsets.all(6.h),
                                              decoration: IconButtonStyleHelper
                                                  .outlineGray,
                                              alignment: Alignment.topRight,
                                              child: CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgCloseWhiteA700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.img4,
                            height: 38.h,
                            width: 40.h,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 34.h),
                          ),
                          CustomIconButton(
                            height: 38.h,
                            width: 38.h,
                            padding: EdgeInsets.all(6.h),
                            decoration: IconButtonStyleHelper.outlineGray,
                            alignment: Alignment.topLeft,
                            child: CustomImageView(
                              imagePath: ImageConstant.imgBook1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 30.h),
                            child: CustomIconButton(
                              height: 38.h,
                              width: 38.h,
                              padding: EdgeInsets.all(6.h),
                              decoration: IconButtonStyleHelper.outlineGray,
                              child: CustomImageView(
                                imagePath: ImageConstant.img1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 70.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: Text(
                        "msg_high_quality_video".tr,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.headlineMediumBlack90001
                            .copyWith(height: 1.36),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "msg_high_definition".tr,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge!.copyWith(height: 1.50),
                    ),
                    SizedBox(height: 28.h),
                    _buildVisitCoursesButton(context),
                  ],
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  color: appTheme.whiteA700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                  ),
                  child: Container(
                    height: 250.h,
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: appTheme.whiteA700,
                      borderRadius: BorderRadiusStyle.roundedBorder10,
                      boxShadow: [
                        BoxShadow(
                          color: appTheme.black90001.withValues(alpha: 0.05),
                          spreadRadius: 2.h,
                          blurRadius: 2.h,
                          offset: Offset(0, 50),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomImageView(
                          imagePath:
                              ImageConstant.imgPexelsVanessaGarcia6325959,
                          height: 230.h,
                          width: double.maxFinite,
                          radius: BorderRadius.circular(10.h),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10.h),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.h,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                  color: appTheme.whiteA700,
                                                  borderRadius:
                                                      BorderRadiusStyle
                                                          .roundedBorder10,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: appTheme.black90001
                                                          .withValues(alpha: 0.1),
                                                      spreadRadius: 2.h,
                                                      blurRadius: 2.h,
                                                      offset: Offset(0, 50),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgPortraitLittleGirlColoring,
                                                      height: 56.h,
                                                      width: double.maxFinite,
                                                      radius:
                                                          BorderRadius.circular(
                                                        10.h,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomImageView(
                                            imagePath: ImageConstant
                                                .imgFloatingIconDeepOrange400,
                                            height: 30.h,
                                            width: 30.h,
                                            radius: BorderRadius.circular(10.h),
                                            margin: EdgeInsets.only(left: 80.h),
                                          ),
                                          CustomImageView(
                                            imagePath: ImageConstant
                                                .imgFloatingIconPrimary,
                                            height: 30.h,
                                            width: 30.h,
                                            radius: BorderRadius.circular(10.h),
                                            margin: EdgeInsets.only(
                                              left: 102.h,
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Consumer(
                  builder: (context, ref, _) {
                    return Wrap(
                      runSpacing: 15.h,
                      spacing: 15.h,
                      children: List<Widget>.generate(
                        ref
                                .watch(homeNotifier)
                                .homeModelObj
                                ?.chipviewoneTwoItemList
                                .length ??
                            0,
                        (index) {
                          ChipviewoneTwoItemModel model = ref
                                  .watch(homeNotifier)
                                  .homeModelObj
                                  ?.chipviewoneTwoItemList[index] ??
                              ChipviewoneTwoItemModel();
                          return ChipviewoneTwoItemWidget(
                            model,
                            onSelectedChipView: (value) {
                              ref
                                  .read(homeNotifier.notifier)
                                  .onSelectedChipView(index, value);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Text(
                "msg_qualified_lessons".tr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.headlineMediumBlack90001.copyWith(
                  height: 1.36,
                ),
              ),
              Text(
                "msg_a_lesson_or_class".tr,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge!.copyWith(height: 1.50),
              ),
              Container(
                margin: EdgeInsets.only(left: 6.h, right: 10.h),
                width: double.maxFinite,
                child: TabBar(
                  controller: tabviewController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: appTheme.whiteA700,
                  labelStyle: TextStyle(
                    fontSize: 14.fSize,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelColor: appTheme.black90001,
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.fSize,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  indicator: BoxDecoration(
                    color: appTheme.orange20002,
                    borderRadius: BorderRadius.circular(5.h),
                  ),
                  dividerHeight: 0.0,
                  tabs: [
                    Tab(
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Text("lbl_kindergarten".tr),
                      ),
                    ),
                    Tab(
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Text("lbl_high_school".tr),
                      ),
                    ),
                    Tab(
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Text("lbl_college".tr),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
