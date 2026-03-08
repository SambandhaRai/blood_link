import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/user/data/repositories/user_repository.dart';
import 'package:blood_link/features/user/domain/entities/user_entity.dart';
import 'package:blood_link/features/user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnlockDonorActiveRequestParams extends Equatable {
  final String userId;
  final String requestId;

  const UnlockDonorActiveRequestParams({
    required this.userId,
    required this.requestId,
  });

  @override
  List<Object?> get props => [userId, requestId];
}

final unlockDonorActiveRequestUsecaseProvider = Provider<
  UnlockDonorActiveRequestUsecase
>((ref) {
  return UnlockDonorActiveRequestUsecase(
    userRepository: ref.read(userRepositoryProvider),
  );
});

class UnlockDonorActiveRequestUsecase
    implements
        UsecaseWithParams<UserEntity?, UnlockDonorActiveRequestParams> {
  final IUserRepository _userRepository;

  UnlockDonorActiveRequestUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, UserEntity?>> call(
    UnlockDonorActiveRequestParams param,
  ) {
    return _userRepository.unlockDonorActiveRequest(
      userId: param.userId,
      requestId: param.requestId,
    );
  }
}
