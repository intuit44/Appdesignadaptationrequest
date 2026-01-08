import 'package:flutter/material.dart';
import '../presentation/addresses_screen/addresses_screen.dart';
import '../presentation/agent_crm_courses_screen/agent_crm_courses_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/appointments_screen/appointments_screen.dart';
import '../presentation/become_an_instructor_screen/become_an_instructor_screen.dart';
import '../presentation/cart_screen/cart_screen.dart';
import '../presentation/fibro_course_details_screen/fibro_course_details_screen.dart';
import '../presentation/fibro_shop_main_screen/fibro_shop_main_screen.dart';
import '../presentation/fibro_shop_screen/fibro_shop_screen.dart';
import '../presentation/help_screen/help_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/main_screen/main_screen.dart';
import '../presentation/membership_portal_screen/membership_portal_screen.dart';
import '../presentation/mentor_profile_screen/mentor_profile_screen.dart';
import '../presentation/mentors_screen/mentors_screen.dart';
import '../presentation/orders_screen/orders_screen.dart';
import '../presentation/payment_methods_screen/payment_methods_screen.dart';
import '../presentation/pricing_screen/pricing_screen.dart';
import '../presentation/product_categories_screen/product_categories_screen.dart';
import '../presentation/product_detail_screen/product_detail_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/tutorials_screen/tutorials_screen.dart';
import '../presentation/wishlist_screen/wishlist_screen.dart';
import '../presentation/chatbot_screen/chatbot_screen.dart';
import '../data/models/product_model.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String mainScreen = '/main_screen';
  static const String appointmentsScreen = '/appointments_screen';
  static const String homeScreen = '/home_screen';

  static const String scrollviewOneTabPage = '/scrollview_one_tab_page';

  static const String fibroShopMainScreen = '/fibro_shop_main_screen';

  static const String scrollviewOneTab1Page = '/scrollview_one_tab1_page';

  static const String fibroShopScreen = '/fibro_shop_screen';

  static const String scrollviewOneTab2Page = '/scrollview_one_tab2_page';

  static const String fibroCourseDetailsScreen = '/fibro_course_details_screen';

  static const String pricingScreen = '/pricing_screen';

  static const String becomeAnInstructorScreen = '/become_an_instructor_screen';

  static const String scrollviewOneTab3Page = '/scrollview_one_tab3_page';

  static const String mentorsScreen = '/mentors_screen';

  static const String scrollviewOneTab4Page = '/scrollview_one_tab4_page';

  static const String mentorProfileScreen = '/mentor_profile_screen';

  static const String scrollviewOneTab5Page = '/scrollview_one_tab5_page';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String productDetailScreen = '/product_detail_screen';

  // Agent CRM Courses routes
  static const String agentCRMCoursesScreen = '/agent_crm_courses_screen';

  // Cart route
  static const String cartScreen = '/cart_screen';

  // Product categories route
  static const String productCategoriesScreen = '/product_categories_screen';

  // New screens
  static const String ordersScreen = '/orders_screen';
  static const String wishlistScreen = '/wishlist_screen';
  static const String addressesScreen = '/addresses_screen';
  static const String paymentMethodsScreen = '/payment_methods_screen';
  static const String settingsScreen = '/settings_screen';
  static const String helpScreen = '/help_screen';
  static const String tutorialsScreen = '/tutorials_screen';
  static const String chatbotScreen = '/chatbot_screen';
  static const String membershipPortalScreen = '/membership_portal_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    mainScreen: (context) => const MainScreen(),
    homeScreen: (context) => const HomeScreen(),
    appointmentsScreen: (context) => const AppointmentsScreen(),
    fibroShopMainScreen: (context) => const FibroShopMainScreen(),
    fibroShopScreen: (context) => const FibroShopScreen(),
    fibroCourseDetailsScreen: (context) => const FibroCourseDetailsScreen(),
    pricingScreen: (context) => const PricingScreen(),
    becomeAnInstructorScreen: (context) => const BecomeAnInstructorScreen(),
    mentorsScreen: (context) => const MentorsScreen(),
    mentorProfileScreen: (context) => const MentorProfileScreen(),
    appNavigationScreen: (context) => const AppNavigationScreen(),
    agentCRMCoursesScreen: (context) => const AgentCRMCoursesScreen(),
    cartScreen: (context) => const CartScreen(showAppBar: true),
    productCategoriesScreen: (context) => const ProductCategoriesScreen(),
    ordersScreen: (context) => const OrdersScreen(),
    wishlistScreen: (context) => const WishlistScreen(),
    addressesScreen: (context) => const AddressesScreen(),
    paymentMethodsScreen: (context) => const PaymentMethodsScreen(),
    settingsScreen: (context) => const SettingsScreen(),
    helpScreen: (context) => const HelpScreen(),
    tutorialsScreen: (context) => const TutorialsScreen(),
    chatbotScreen: (context) => const ChatbotScreen(),
    membershipPortalScreen: (context) => const MembershipPortalScreen(),
    initialRoute: (context) => const MainScreen(),
  };

  /// Navegación a ProductDetailScreen con producto
  static void navigateToProductDetail(
      BuildContext context, ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          productId: product.id,
          product: product,
        ),
      ),
    );
  }

  /// Navegación a ProductDetailScreen solo con ID
  static void navigateToProductDetailById(BuildContext context, int productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productId: productId),
      ),
    );
  }
}
