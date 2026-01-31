import 'dart:io';

import 'package:blood_link/core/api/api_client.dart';
import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/core/services/storage/token_service.dart';
import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:blood_link/features/auth/data/datasources/auth_datasource.dart';
import 'package:blood_link/features/auth/data/models/auth_api_model.dart';
import 'package:dio/dio.dart';
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
  Future<AuthApiModel?> getCurrentUser() async {
    // throw UnimplementedError();
    final token = _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.userProfile,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    if (response.data["success"] == true) {
      final user = AuthApiModel.fromJson(response.data["data"]);

      await _userSessionService.saveUserSession(
        userId: user.userId!,
        email: user.email,
        fullName: user.fullName,
        phoneNumber: user.phoneNumber,
        gender: user.gender,
        bloodId: user.bloodId,
        dob: user.dob,
        healthCondition: user.healthCondition,
        profilePicture: user.profilePicture,
      );

      return user;
    }
    return null;
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

  @override
  Future<AuthApiModel?> updateUserProfile(AuthApiModel user) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.put(
      ApiEndpoints.updateUserProfile,
      data: user.toJson(),
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.data["success"] == true) {
      final data = response.data["data"] as Map<String, dynamic>;
      final newUserProfile = AuthApiModel.fromJson(data);

      await _userSessionService.saveUserSession(
        userId: newUserProfile.userId!,
        email: newUserProfile.email,
        fullName: newUserProfile.fullName,
        gender: newUserProfile.gender,
        dob: newUserProfile.dob,
        bloodId: newUserProfile.bloodId,
        phoneNumber: newUserProfile.phoneNumber,
        healthCondition: newUserProfile.healthCondition,
        profilePicture: newUserProfile.profilePicture,
      );

      return newUserProfile;
    }
    return user;
  }

  @override
  Future<String?> uploadProfilePicture(File image) async {
    final fileName = image.path.split("/").last;
    final formData = FormData.fromMap({
      "profilePicture": await MultipartFile.fromFile(
        image.path,
        filename: fileName,
      ),
    });

    final token = _tokenService.getToken();
    final response = await _apiClient.uploadFilePut(
      ApiEndpoints.uploadProfilePicture,
      formData: formData,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.data["success"] == true) {
      final data = response.data["data"] as Map<String, dynamic>;
      final profilePicture = data["profilePicture"] as String?;

      if (profilePicture != null) {
        await _userSessionService.saveUserSession(
          userId: _userSessionService.getCurrentUserId() ?? "",
          email: _userSessionService.getCurrentUserEmail() ?? "",
          fullName: _userSessionService.getCurrentUserFullName() ?? "",
          phoneNumber: _userSessionService.getCurrentUserPhoneNumber() ?? "",
          gender: _userSessionService.getCurrentUserGender(),
          bloodId: _userSessionService.getCurrentUserBloodId(),
          dob: _userSessionService.getCurrentUserDob(),
          healthCondition: _userSessionService.getCurrentUserHealthCondition(),
          profilePicture: profilePicture,
        );
      }

      return profilePicture;
    }

    return null;
  }
}
