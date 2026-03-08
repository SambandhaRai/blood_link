import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/auth/data/repositories/auth_repository.dart';
import 'package:blood_link/features/auth/domain/entities/auth_entity.dart';
import 'package:blood_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateProfileParams extends Equatable {
  final AuthEntity entity;

  const UpdateProfileParams({required this.entity});

  @override
  List<Object?> get props => [entity];
}

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  return UpdateProfileUsecase(authRepository: ref.read(authRepositoryProvider));
});

class UpdateProfileUsecase
    implements UsecaseWithParams<AuthEntity, UpdateProfileParams> {
  final IAuthRepository _authRepository;

  UpdateProfileUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call(UpdateProfileParams params) {
    return _authRepository.updateUserProfile(params.entity);
  }
}
