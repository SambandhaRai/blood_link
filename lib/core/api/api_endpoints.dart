class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://10.0.2.2:5050/api/';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // =================== Auth Endpoints ===================
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';

  // =================== Admin Endpoints ===================
  static const String admin = '/admin';
  static const String adminCreateBloodGroup = '/admin/bloodGroups/create';

  // =================== Blood Group Endpoints ===================
  static const String bloodGroup = '/bloodGroup';
  static String bloodGroupById(String id) => '/bloodGroup/$id';
}
