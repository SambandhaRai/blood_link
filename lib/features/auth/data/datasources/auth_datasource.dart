import 'dart:io';

import 'package:blood_link/features/auth/data/models/auth_api_model.dart';
import 'package:blood_link/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthLocalDatasource {
  Future<AuthHiveModel> register(AuthHiveModel model);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();

  // get email exists
  Future<bool> isEmailExists(String email);
  Future<AuthHiveModel?> getUserByEmail(String email);
  Future<AuthHiveModel?> getUserByPhoneNumber(String phoneNumber);
}

abstract interface class IAuthRemoteDatasource {
  Future<AuthApiModel> register(AuthApiModel user);
  Future<AuthApiModel?> login(String email, String password);
  Future<AuthApiModel?> getCurrentUser();
  Future<bool> logout();

  // get email exists
  Future<bool> isEmailExists(String email);
  Future<AuthApiModel?> getUserByEmail(String email);
  Future<AuthApiModel?> getUserByPhoneNumber(String phoneNumber);

  // update user profile
  Future<AuthApiModel?> updateUserProfile(AuthApiModel user);
  Future<String?> uploadProfilePicture(File image);
}
