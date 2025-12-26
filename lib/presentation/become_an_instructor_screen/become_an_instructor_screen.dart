import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'scrollview_one_tab3_page.dart';

class BecomeAnInstructorScreen extends ConsumerStatefulWidget {
  const BecomeAnInstructorScreen({Key? key}) : super(key: key);

  @override
  BecomeAnInstructorScreenState createState() =>
      BecomeAnInstructorScreenState();
}

// ignore_for_file: must_be_immutable
class BecomeAnInstructorScreenState
    extends ConsumerState<BecomeAnInstructorScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 2, vsync: this);
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
                height: 2446.h,
                child: TabBarView(
                  controller: tabviewController,
                  children: [ScrollviewOneTab3Page(), ScrollviewOneTab3Page()],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildMainContent(BuildContext context) {
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
        Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 18.h),
                decoration: BoxDecoration(
                  color: appTheme.yellow100,
                  borderRadius: BorderRadiusStyle.roundedBorder10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(height: 14.h),
                    Text(
                      "msg_join_eduvi_as_a".tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.headlineLargeGray90001_1.copyWith(
                        height: 1.27,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    CustomImageView(
                      imagePath: ImageConstant.imgObjects,
                      height: 126.h,
                      width: double.maxFinite,
                      margin: EdgeInsets.only(left: 54.h, right: 56.h),
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              CustomImageView(
                imagePath: ImageConstant.imgImage322x316,
                height: 342.h,
                width: double.maxFinite,
              ),
              SizedBox(height: 30.h),
              SizedBox(height: 40.h),
              Text(
                "msg_apply_as_instructor".tr,
                style: CustomTextStyles.headlineSmallBlack9000124,
              ),
              SizedBox(height: 30.h),
              SizedBox(height: 8.h),
              Text(
                "msg_teaching_is_a_vital".tr,
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge!.copyWith(height: 1.50),
              ),
              SizedBox(height: 30.h),
              SizedBox(height: 18.h),
              SizedBox(
                width: double.maxFinite,
                child: TabBar(
                  controller: tabviewController,
                  labelPadding: EdgeInsets.zero,
                  labelColor: theme.colorScheme.primary,
                  labelStyle: TextStyle(
                    fontSize: 14.fSize,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelColor: appTheme.gray700,
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.fSize,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  indicatorColor: theme.colorScheme.primary,
                  tabs: [
                    Tab(child: Text("msg_intstructor_requirements".tr)),
                    Tab(child: Text("msg_instructor_rules".tr)),
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
