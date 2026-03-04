import 'package:blood_link/core/api/api_client.dart';
import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/core/services/storage/token_service.dart';
import 'package:blood_link/features/user/data/datasource/user_datasource.dart';
import 'package:blood_link/features/user/data/models/user_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRemoteDatasourceProvider = Provider<UserRemoteDatasource>((ref) {
  return UserRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class UserRemoteDatasource implements IUserDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  UserRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  Options _authOptions(String? token) {
    return Options(headers: {"Authorization": "Bearer $token"});
  }

  @override
  Future<UserApiModel?> getCurrentUserProfile() async {
    final token = _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.userProfile,
      options: _authOptions(token),
    );

    final data = response.data["data"];
    if (data == null) return null;
    return UserApiModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<UserApiModel?> lockDonorActiveRequest({
    required String userId,
    required String requestId,
  }) async {
    final token = _tokenService.getToken();
    final response = await _apiClient.patch(
      ApiEndpoints.lockDonorActiveRequest(userId, requestId),
      options: _authOptions(token),
    );

    final data = response.data["data"];
    if (data == null) return null;
    return UserApiModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<UserApiModel?> unlockDonorActiveRequest({
    required String userId,
    required String requestId,
  }) async {
    final token = _tokenService.getToken();
    final response = await _apiClient.patch(
      ApiEndpoints.unlockDonorActiveRequest(userId, requestId),
      options: _authOptions(token),
    );

    final data = response.data["data"];
    if (data == null) return null;
    return UserApiModel.fromJson(data as Map<String, dynamic>);
  }
}
