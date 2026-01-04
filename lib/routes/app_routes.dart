import 'package:flutter/material.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/become_an_instructor_screen/become_an_instructor_screen.dart';
import '../presentation/eduvi_course_details_screen/eduvi_course_details_screen.dart';
import '../presentation/eduvi_online_shop_one_screen/eduvi_online_shop_one_screen.dart';
import '../presentation/eduvi_online_shop_screen/eduvi_online_shop_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/mentor_profile_screen/mentor_profile_screen.dart';
import '../presentation/mentors_screen/mentors_screen.dart';
import '../presentation/pricing_screen/pricing_screen.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String homeScreen = '/home_screen';

  static const String scrollviewOneTabPage = '/scrollview_one_tab_page';

  static const String eduviOnlineShopOneScreen =
      '/eduvi_online_shop_one_screen';

  static const String scrollviewOneTab1Page = '/scrollview_one_tab1_page';

  static const String eduviOnlineShopScreen = '/eduvi_online_shop_screen';

  static const String scrollviewOneTab2Page = '/scrollview_one_tab2_page';

  static const String eduviCourseDetailsScreen = '/eduvi_course_details_screen';

  static const String pricingScreen = '/pricing_screen';

  static const String becomeAnInstructorScreen = '/become_an_instructor_screen';

  static const String scrollviewOneTab3Page = '/scrollview_one_tab3_page';

  static const String mentorsScreen = '/mentors_screen';

  static const String scrollviewOneTab4Page = '/scrollview_one_tab4_page';

  static const String mentorProfileScreen = '/mentor_profile_screen';

  static const String scrollviewOneTab5Page = '/scrollview_one_tab5_page';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String productDetailScreen = '/product_detail_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    homeScreen: (context) => const HomeScreen(),
    eduviOnlineShopOneScreen: (context) => const EduviOnlineShopOneScreen(),
    eduviOnlineShopScreen: (context) => const EduviOnlineShopScreen(),
    eduviCourseDetailsScreen: (context) => const EduviCourseDetailsScreen(),
    pricingScreen: (context) => const PricingScreen(),
    becomeAnInstructorScreen: (context) => const BecomeAnInstructorScreen(),
    mentorsScreen: (context) => const MentorsScreen(),
    mentorProfileScreen: (context) => const MentorProfileScreen(),
    appNavigationScreen: (context) => const AppNavigationScreen(),
    initialRoute: (context) => const HomeScreen(),
  };
}
