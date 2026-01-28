import 'dart:io';

import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/auth/data/repositories/auth_repository.dart';
import 'package:blood_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadProfilePictureParams extends Equatable {
  final File image;

  const UploadProfilePictureParams({required this.image});

  @override
  List<Object?> get props => [image];
}

final uploadProfilePictureUsecaseProvider =
    Provider<UploadProfilePictureUsecase>((ref) {
      return UploadProfilePictureUsecase(
        authRepository: ref.read(authRepositoryProvider),
      );
    });

class UploadProfilePictureUsecase
    implements UsecaseWithParams<String?, UploadProfilePictureParams> {
  final IAuthRepository _authRepository;
  UploadProfilePictureUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;
  @override
  Future<Either<Failure, String?>> call(UploadProfilePictureParams param) {
    return _authRepository.uploadProfilePicture(param.image);
  }
}
