import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'scrollview_one_tab1_page.dart';

class EduviOnlineShopOneScreen extends ConsumerStatefulWidget {
  const EduviOnlineShopOneScreen({super.key});

  @override
  EduviOnlineShopOneScreenState createState() =>
      EduviOnlineShopOneScreenState();
}

// ignore_for_file: must_be_immutable
class EduviOnlineShopOneScreenState
    extends ConsumerState<EduviOnlineShopOneScreen>
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
                height: 4560.h,
                child: TabBarView(
                  controller: tabviewController,
                  children: const [
                    ScrollviewOneTab1Page(),
                    ScrollviewOneTab1Page(),
                    ScrollviewOneTab1Page(),
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
                padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 8.h),
                decoration: BoxDecoration(
                  color: appTheme.red5002,
                  borderRadius: BorderRadiusStyle.roundedBorder10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "lbl_home2".tr,
                            style: CustomTextStyles.titleMediumBlack90001_1,
                          ),
                          TextSpan(
                            text: "lbl_shop".tr,
                            style: CustomTextStyles.titleMediumPrimary_2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "msg_eduvi_online_book".tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineLarge!.copyWith(
                        height: 1.27,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomImageView(
                      imagePath: ImageConstant.imgKisspngBookcas,
                      height: 142.h,
                      width: double.maxFinite,
                      margin: EdgeInsets.only(left: 28.h, right: 26.h),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 70.h),
        Container(
          width: 354.h,
          margin: EdgeInsets.only(left: 20.h),
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
                    child: Text("lbl_all_books".tr),
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
                    child: Text("lbl_kindergarten".tr),
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
                    child: Text("lbl_high_school2".tr),
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
