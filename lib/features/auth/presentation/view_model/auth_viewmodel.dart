import 'package:blood_link/features/auth/domain/usecases/login_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/register_usecase.dart';
import 'package:blood_link/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final authViewmodelProvider = NotifierProvider<AuthViewmodel, AuthState>(
  () => AuthViewmodel(),
);

class AuthViewmodel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    return AuthState();
  }

  // Register
  Future<void> register({
    required String fullName,
    required String phoneNumber,
    required String dob,
    required String gender,
    required String bloodGroup,
    String? healthCondition,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = RegisterUsecaseParams(
      fullName: fullName,
      phoneNumber: phoneNumber,
      dob: dob,
      gender: gender,
      bloodGroup: bloodGroup,
      email: email,
      password: password,
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
}
