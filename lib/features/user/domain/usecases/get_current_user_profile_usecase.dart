import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/user/data/repositories/user_repository.dart';
import 'package:blood_link/features/user/domain/entities/user_entity.dart';
import 'package:blood_link/features/user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCurrentUserProfileUsecaseProvider = Provider<GetCurrentUserProfileUsecase>((
  ref,
) {
  return GetCurrentUserProfileUsecase(
    userRepository: ref.read(userRepositoryProvider),
  );
});

class GetCurrentUserProfileUsecase
    implements UsecaseWithoutParams<UserEntity?> {
  final IUserRepository _userRepository;

  GetCurrentUserProfileUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, UserEntity?>> call() {
    return _userRepository.getCurrentUserProfile();
  }
}
