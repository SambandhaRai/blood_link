import 'dart:io';

import 'package:blood_link/core/services/sensors/biometric/biometric_service.dart';
import 'package:blood_link/core/services/storage/biometric_shared_prefs.dart';
import 'package:blood_link/core/services/storage/token_service.dart';
import 'package:blood_link/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/login_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/logout_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/register_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/upload_profile_picture_usecase.dart';
import 'package:blood_link/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

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
  late final BiometricService _biometricService;
  late final BiometricPrefService _biometricPrefService;
  late final TokenService _tokenService;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    _uploadProfilePictureUsecase = ref.read(
      uploadProfilePictureUsecaseProvider,
    );
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    _biometricService = ref.read(biometricServiceProvider);
    _biometricPrefService = ref.read(biometricPrefServiceProvider);
    _tokenService = ref.read(tokenServiceProvider);
    Future.microtask(_initBiometrics);
    return AuthState();
  }

  Future<void> _initBiometrics() async {
    try {
      final available = await _biometricService.canCheck();
      final enabled = _biometricPrefService.isEnabled();
      state = state.copyWith(
        biometricAvailable: available,
        biometricEnabled: enabled && available,
      );
    } catch (_) {
      state = state.copyWith(
        biometricAvailable: false,
        biometricEnabled: false,
      );
    }
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

  Future<void> setBiometricEnabled(bool enabled) async {
    final available = await _biometricService.canCheck();

    // If device can't do biometrics, don't allow enabling.
    if (enabled && !available) {
      await _biometricPrefService.setEnabled(false);
      state = state.copyWith(
        biometricAvailable: false,
        biometricEnabled: false,
        status: AuthStatus.error,
        errorMessage: "Biometrics not available on this device",
      );
      return;
    }

    // Do not require biometric prompt here; authenticate during login flow.
    await _biometricPrefService.setEnabled(enabled);
    state = state.copyWith(
      biometricAvailable: available,
      biometricEnabled: enabled,
      clearError: true,
    );
  }

  Future<bool> loginWithBiometrics() async {
    state = state.copyWith(biometricLoading: true, clearError: true);

    if (!state.biometricAvailable) {
      state = state.copyWith(
        biometricLoading: false,
        status: AuthStatus.error,
        errorMessage: "Biometrics not available on this device",
      );
      return false;
    }

    if (!state.biometricEnabled) {
      state = state.copyWith(
        biometricLoading: false,
        status: AuthStatus.error,
        errorMessage: "Enable biometric login in Profile settings first",
      );
      return false;
    }

    final ok = await _biometricService.authenticate();
    if (!ok) {
      final code = _biometricService.lastExceptionCode;
      final available = await _biometricService.canCheck();
      if (!available) {
        await _biometricPrefService.setEnabled(false);
      }
      state = state.copyWith(
        biometricAvailable: available,
        biometricEnabled: available ? state.biometricEnabled : false,
        biometricLoading: false,
        status: AuthStatus.error,
        errorMessage: !available
            ? "Biometrics are currently unavailable on this device"
            : code == LocalAuthExceptionCode.uiUnavailable
            ? "Biometric prompt unavailable right now. Try again in a moment."
            : "Fingerprint authentication failed",
      );
      return false;
    }

    // Require previously saved token from password login.
    final token = _tokenService.getToken();
    if (token == null || token.trim().isEmpty) {
      state = state.copyWith(
        biometricLoading: false,
        status: AuthStatus.error,
        errorMessage: "No saved session. Please login with password once.",
      );
      return false;
    }

    // Validate token + fetch latest user profile.
    final result = await _getCurrentUserUsecase();
    return result.fold(
      (failure) {
        state = state.copyWith(
          biometricLoading: false,
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (entity) {
        state = state.copyWith(
          biometricLoading: false,
          status: AuthStatus.authenticated,
          authEntity: entity,
        );
        return true;
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
