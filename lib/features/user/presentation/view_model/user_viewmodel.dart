import 'package:blood_link/features/user/domain/usecases/get_current_user_profile_usecase.dart';
import 'package:blood_link/features/user/domain/usecases/lock_donor_active_request_usecase.dart';
import 'package:blood_link/features/user/domain/usecases/unlock_donor_active_request_usecase.dart';
import 'package:blood_link/features/user/presentation/state/user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userViewmodelProvider = NotifierProvider.autoDispose<UserViewmodel, UserState>(
  UserViewmodel.new,
);

class UserViewmodel extends Notifier<UserState> {
  late final GetCurrentUserProfileUsecase _getCurrentUserProfileUsecase;
  late final LockDonorActiveRequestUsecase _lockDonorActiveRequestUsecase;
  late final UnlockDonorActiveRequestUsecase _unlockDonorActiveRequestUsecase;

  @override
  UserState build() {
    _getCurrentUserProfileUsecase = ref.read(
      getCurrentUserProfileUsecaseProvider,
    );
    _lockDonorActiveRequestUsecase = ref.read(
      lockDonorActiveRequestUsecaseProvider,
    );
    _unlockDonorActiveRequestUsecase = ref.read(
      unlockDonorActiveRequestUsecaseProvider,
    );
    return const UserState();
  }

  Future<void> getCurrentUserProfile() async {
    state = state.copyWith(
      status: UserStatus.loading,
      resetErrorMessage: true,
      resetSuccessMessage: true,
    );

    final result = await _getCurrentUserProfileUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = state.copyWith(status: UserStatus.loaded, user: user);
      },
    );
  }

  Future<void> lockDonorActiveRequest({
    required String userId,
    required String requestId,
  }) async {
    state = state.copyWith(
      status: UserStatus.loading,
      resetErrorMessage: true,
      resetSuccessMessage: true,
    );

    final result = await _lockDonorActiveRequestUsecase(
      LockDonorActiveRequestParams(userId: userId, requestId: requestId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          status: UserStatus.loaded,
          user: user,
          successMessage: "Active request locked successfully.",
        );
      },
    );
  }

  Future<void> unlockDonorActiveRequest({
    required String userId,
    required String requestId,
  }) async {
    state = state.copyWith(
      status: UserStatus.loading,
      resetErrorMessage: true,
      resetSuccessMessage: true,
    );

    final result = await _unlockDonorActiveRequestUsecase(
      UnlockDonorActiveRequestParams(userId: userId, requestId: requestId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          status: UserStatus.loaded,
          user: user,
          successMessage: "Active request unlocked successfully.",
        );
      },
    );
  }
}
