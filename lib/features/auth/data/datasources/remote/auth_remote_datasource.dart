import 'package:blood_link/core/api/api_client.dart';
import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/features/auth/data/datasources/auth_datasource.dart';
import 'package:blood_link/features/auth/data/models/auth_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;

  AuthRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

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
