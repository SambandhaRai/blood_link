import 'dart:io';

import 'package:blood_link/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/login_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/logout_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/register_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/upload_profile_picture_usecase.dart';
import 'package:blood_link/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final authViewmodelProvider = NotifierProvider<AuthViewmodel, AuthState>(
  () => AuthViewmodel(),
);

class AuthViewmodel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final UploadProfilePictureUsecase _uploadProfilePictureUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    _uploadProfilePictureUsecase = ref.read(
      uploadProfilePictureUsecaseProvider,
    );
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    return AuthState();
  }

  // Register
  Future<void> register({
    required String fullName,
    required String phoneNumber,
    required String dob,
    required String gender,
    String? bloodId,
    String? healthCondition,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = RegisterUsecaseParams(
      fullName: fullName,
      phoneNumber: phoneNumber,
      dob: dob,
      gender: gender,
      bloodId: bloodId,
      healthCondition: healthCondition,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    final result = await _registerUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (isRegistered) {
        if (isRegistered) {
          state = state.copyWith(
            status: AuthStatus.registered,
            errorMessage: null,
          );
        } else {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: "Registration Failed",
          );
        }
      },
    );
  }

  // Login
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = LoginUsecaseParams(email: email, password: password);
    final result = await _loginUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
          errorMessage: null,
        );
      },
    );
  }

  // Logout
  Future<void> logout() async {
    final result = await _logoutUsecase();
    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        authEntity: null,
      ),
    );
  }

  // Upload Profile Picture
  Future<void> uploadProfilePicture(File image) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _uploadProfilePictureUsecase(
      UploadProfilePictureParams(image: image),
    );
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (imageName) {
        state = state.copyWith(
          status: AuthStatus.loaded,
          uploadProfilePictureName: imageName,
        );
      },
    );
  }

  // Get Current User
  Future<void> getCurrentUser() async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (entity) {
        state = state.copyWith(status: AuthStatus.loaded, authEntity: entity);
      },
    );
  }
}
