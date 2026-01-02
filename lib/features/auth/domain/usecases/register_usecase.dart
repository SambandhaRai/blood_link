import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/auth/data/repositories/auth_repository.dart';
import 'package:blood_link/features/auth/domain/entities/auth_entity.dart';
import 'package:blood_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterUsecaseParams extends Equatable {
  final String fullName;
  final String phoneNumber;
  final String dob;
  final String gender;
  final String bloodGroup;
  final String? healthCondition;
  final String email;
  final String password;

  const RegisterUsecaseParams({
    required this.fullName,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    required this.bloodGroup,
    this.healthCondition,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
    fullName,
    phoneNumber,
    dob,
    gender,
    bloodGroup,
    healthCondition,
    email,
    password,
  ];
}

// Provider
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      fullName: params.fullName,
      phoneNumber: params.phoneNumber,
      dob: params.dob,
      gender: params.gender,
      bloodGroup: params.bloodGroup,
      healthCondition: params.healthCondition,
      email: params.email,
      password: params.password,
    );
    return _authRepository.register(entity);
  }
}
