import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/user/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, UserEntity?>> getCurrentUserProfile();

  Future<Either<Failure, UserEntity?>> lockDonorActiveRequest({
    required String userId,
    required String requestId,
  });

  Future<Either<Failure, UserEntity?>> unlockDonorActiveRequest({
    required String userId,
    required String requestId,
  });
}
