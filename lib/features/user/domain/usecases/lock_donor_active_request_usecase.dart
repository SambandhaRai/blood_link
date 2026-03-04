import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/user/data/repositories/user_repository.dart';
import 'package:blood_link/features/user/domain/entities/user_entity.dart';
import 'package:blood_link/features/user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LockDonorActiveRequestParams extends Equatable {
  final String userId;
  final String requestId;

  const LockDonorActiveRequestParams({
    required this.userId,
    required this.requestId,
  });

  @override
  List<Object?> get props => [userId, requestId];
}

final lockDonorActiveRequestUsecaseProvider = Provider<
  LockDonorActiveRequestUsecase
>((ref) {
  return LockDonorActiveRequestUsecase(
    userRepository: ref.read(userRepositoryProvider),
  );
});

class LockDonorActiveRequestUsecase
    implements
        UsecaseWithParams<UserEntity?, LockDonorActiveRequestParams> {
  final IUserRepository _userRepository;

  LockDonorActiveRequestUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, UserEntity?>> call(
    LockDonorActiveRequestParams param,
  ) {
    return _userRepository.lockDonorActiveRequest(
      userId: param.userId,
      requestId: param.requestId,
    );
  }
}
