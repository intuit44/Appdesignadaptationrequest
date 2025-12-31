import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'scrollview_one_tab4_page.dart';

class MentorsScreen extends ConsumerStatefulWidget {
  const MentorsScreen({super.key});

  @override
  MentorsScreenState createState() => MentorsScreenState();
}

// ignore_for_file: must_be_immutable
class MentorsScreenState extends ConsumerState<MentorsScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;

  int tabIndex = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray10001,
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
                height: 3408.h,
                child: TabBarView(
                  controller: tabviewController,
                  children: const [
                    ScrollviewOneTab4Page(),
                    ScrollviewOneTab4Page(),
                    ScrollviewOneTab4Page(),
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
        SizedBox(height: 28.h),
        Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 18.h),
                decoration: BoxDecoration(
                  color: appTheme.red5002,
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
                            text: "lbl_our_mentors".tr,
                            style: CustomTextStyles.titleMediumPrimary_2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      "msg_eduvi_has_the_qualified".tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.headlineLargeGray90001_1.copyWith(
                        height: 1.27,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    CustomImageView(
                      imagePath: ImageConstant.img49063311,
                      height: 116.h,
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 34.h),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 42.h),
        Container(
          width: 364.h,
          margin: EdgeInsets.only(left: 10.h),
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
                  decoration: tabIndex == 0
                      ? BoxDecoration(
                          color: appTheme.orange20002,
                          borderRadius: BorderRadius.circular(5.h),
                        )
                      : BoxDecoration(
                          color: appTheme.whiteA700,
                          borderRadius: BorderRadius.circular(5.h),
                        ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 10.h,
                    ),
                    child: Text("lbl_all_mentors".tr),
                  ),
                ),
              ),
              Tab(
                height: 40,
                child: Container(
                  alignment: Alignment.center,
                  decoration: tabIndex == 1
                      ? BoxDecoration(
                          color: appTheme.orange20002,
                          borderRadius: BorderRadius.circular(5.h),
                        )
                      : BoxDecoration(
                          color: appTheme.whiteA700,
                          borderRadius: BorderRadius.circular(5.h),
                        ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 10.h,
                    ),
                    child: Text("msg_for_kindergarten".tr),
                  ),
                ),
              ),
              Tab(
                height: 40,
                child: Container(
                  alignment: Alignment.center,
                  decoration: tabIndex == 2
                      ? BoxDecoration(
                          color: appTheme.orange20002,
                          borderRadius: BorderRadius.circular(5.h),
                        )
                      : BoxDecoration(
                          color: appTheme.whiteA700,
                          borderRadius: BorderRadius.circular(5.h),
                        ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 10.h,
                    ),
                    child: Text("lbl_for_high_school".tr),
                  ),
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
    );
  }
}
