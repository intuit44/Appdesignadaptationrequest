/// API Endpoints para WooCommerce y autenticación
class ApiEndpoints {
  // Base URL del sitio WordPress/WooCommerce
  static const String baseUrl = 'https://fibroacademyusa.com';

  // WooCommerce REST API
  static const String wcApiVersion = 'wc/v3';
  static const String wcApiBase = '$baseUrl/wp-json/$wcApiVersion';

  // JWT Auth (requiere plugin JWT Authentication en WordPress)
  static const String jwtAuth = '$baseUrl/wp-json/jwt-auth/v1';
  static const String jwtToken = '$jwtAuth/token';
  static const String jwtValidate = '$jwtAuth/token/validate';

  // Productos/Cursos
  static const String products = '$wcApiBase/products';
  static String productById(int id) => '$products/$id';
  static const String productCategories = '$wcApiBase/products/categories';

  // Órdenes
  static const String orders = '$wcApiBase/orders';
  static String orderById(int id) => '$orders/$id';

  // Clientes
  static const String customers = '$wcApiBase/customers';
  static String customerById(int id) => '$customers/$id';

  // WordPress Users (para registro/perfil)
  static const String wpUsers = '$baseUrl/wp-json/wp/v2/users';
  static const String wpMe = '$wpUsers/me';
}
