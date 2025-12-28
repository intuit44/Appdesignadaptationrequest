import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../sign_in_dialog/sign_in_dialog.dart';
import '../sign_up_dialog/sign_up_dialog.dart';

class AppNavigationScreen extends ConsumerStatefulWidget {
  const AppNavigationScreen({Key? key}) : super(key: key);

  @override
  AppNavigationScreenState createState() => AppNavigationScreenState();
}

class AppNavigationScreenState extends ConsumerState<AppNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFFFFFFF),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Color(0XFFFFFFFF)),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Text(
                        "App Navigation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0XFF000000),
                          fontSize: 20.fSize,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.only(left: 20.h),
                      child: Text(
                        "Check your app's UI from the below demo screens of your app.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0XFF888888),
                          fontSize: 16.fSize,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: Color(0XFF000000),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(color: Color(0XFFFFFFFF)),
                    child: Column(
                      children: [
                        _buildScreenTitle(
                          context,
                          screenTitle: "Sign In - Dialog",
                          onTapScreenTitle: () =>
                              onTapDialogTitle(context, SignInDialog()),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Sign Up - Dialog",
                          onTapScreenTitle: () =>
                              onTapDialogTitle(context, SignUpDialog()),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Home",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.homeScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Eduvi online shop One",
                          onTapScreenTitle: () => onTapScreenTitle(
                            AppRoutes.eduviOnlineShopOneScreen,
                          ),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Eduvi online shop",
                          onTapScreenTitle: () => onTapScreenTitle(
                            AppRoutes.eduviOnlineShopScreen,
                          ),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Eduvi course details",
                          onTapScreenTitle: () => onTapScreenTitle(
                            AppRoutes.eduviCourseDetailsScreen,
                          ),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Pricing",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.pricingScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Become an instructor",
                          onTapScreenTitle: () => onTapScreenTitle(
                            AppRoutes.becomeAnInstructorScreen,
                          ),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Mentors",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.mentorsScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Mentor Profile",
                          onTapScreenTitle: () => onTapScreenTitle(
                            AppRoutes.mentorProfileScreen,
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
    );
  }

  /// Common click event for dialog
  void onTapDialogTitle(BuildContext context, Widget className) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          // Keep DhiWise default flow (dialog), but constrain + scroll to avoid
          // RenderFlex overflow (esp. when the keyboard opens on smaller screens).
          insetPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.h),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: SingleChildScrollView(
              child: className,
            ),
          ),
          backgroundColor: Colors.transparent,
        );
      },
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle?.call();
      },
      child: Container(
        decoration: BoxDecoration(color: Color(0XFFFFFFFF)),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                screenTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF000000),
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(height: 5.h),
            Divider(height: 1.h, thickness: 1.h, color: Color(0XFF888888)),
          ],
        ),
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(String routeName) {
    NavigatorService.pushNamed(routeName);
  }
}
