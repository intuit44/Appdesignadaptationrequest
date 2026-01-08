/// API Endpoints para Cloud Functions y WooCommerce
class ApiEndpoints {
  // Cloud Functions URL (backend centralizado)
  static const String cloudFunctionsUrl =
      'https://us-central1-eng-gate-453810-h3.cloudfunctions.net';

  // Base URL del sitio WordPress/WooCommerce (solo para checkout WebView)
  static const String baseUrl = 'https://fibroacademyusa.com';

  // Cloud Functions endpoints
  static const String cfGetProducts = '$cloudFunctionsUrl/getProducts';
  static const String cfGetProductDetail =
      '$cloudFunctionsUrl/getProductDetail';
  static const String cfGetCategories = '$cloudFunctionsUrl/getCategories';
  static const String cfCheckAvailability =
      '$cloudFunctionsUrl/checkAvailability';
  static const String cfGetCourses = '$cloudFunctionsUrl/getCourses';
  static const String cfGetCourseDetail = '$cloudFunctionsUrl/getCourseDetail';
  static const String cfGetUpcomingEvents =
      '$cloudFunctionsUrl/getUpcomingEvents';
  static const String cfGetOrders = '$cloudFunctionsUrl/getOrders';
  static const String cfCreateOrder = '$cloudFunctionsUrl/createOrder';
  static const String cfGetOrCreateCustomer =
      '$cloudFunctionsUrl/getOrCreateCustomer';
  static const String cfGetContactInfo = '$cloudFunctionsUrl/getContactInfo';
  static const String cfChat = '$cloudFunctionsUrl/chat';
  static const String cfGetTutorials = '$cloudFunctionsUrl/getTutorials';
  static const String cfGetAgentCRMProducts =
      '$cloudFunctionsUrl/getAgentCRMProducts';
  static const String cfGetMentors = '$cloudFunctionsUrl/getMentors';

  // WooCommerce REST API (legacy - mantener para compatibilidad)
  static const String wcApiVersion = 'wc/v3';
  static const String wcApiBase = '$baseUrl/wp-json/$wcApiVersion';

  // JWT Auth (requiere plugin JWT Authentication en WordPress)
  static const String jwtAuth = '$baseUrl/wp-json/jwt-auth/v1';
  static const String jwtToken = '$jwtAuth/token';
  static const String jwtValidate = '$jwtAuth/token/validate';

  // Productos/Cursos (legacy)
  static const String products = '$wcApiBase/products';
  static String productById(int id) => '$products/$id';
  static const String productCategories = '$wcApiBase/products/categories';

  // Órdenes (legacy)
  static const String orders = '$wcApiBase/orders';
  static String orderById(int id) => '$orders/$id';

  // Clientes (legacy)
  static const String customers = '$wcApiBase/customers';
  static String customerById(int id) => '$customers/$id';

  // WordPress Users (para registro/perfil)
  static const String wpUsers = '$baseUrl/wp-json/wp/v2/users';
  static const String wpMe = '$wpUsers/me';
}
