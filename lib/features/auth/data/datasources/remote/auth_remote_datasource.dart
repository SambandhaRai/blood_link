import 'package:blood_link/core/api/api_client.dart';
import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/core/services/storage/token_service.dart';
import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:blood_link/features/auth/data/datasources/auth_datasource.dart';
import 'package:blood_link/features/auth/data/models/auth_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenService = tokenService;

  @override
  Future<AuthApiModel?> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isEmailExists(String email) {
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.authLogin,
      data: {"email": email, "password": password},
    );
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);

      // Save user session to SharedPreferences
      await _userSessionService.saveUserSession(
        userId: user.userId!,
        email: user.email,
        fullName: user.fullName,
        gender: user.gender,
        dob: user.dob,
        bloodId: user.bloodId,
        phoneNumber: user.phoneNumber,
        healthCondition: user.healthCondition,
        profilePicture: user.profilePicture,
      );

      // save token
      final token = response.data["token"] as String?;
      await _tokenService.saveToken(token!);

      return user;
    }
    return null;
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.authRegister,
      data: user.toJson(),
    );
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registerUser = AuthApiModel.fromJson(data);
      return registerUser;
    }
    return user;
  }

  @override
  Future<AuthApiModel?> getUserByEmail(String email) {
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> getUserByPhoneNumber(String phoneNumber) {
    throw UnimplementedError();
  }
}
