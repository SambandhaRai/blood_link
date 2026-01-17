import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/bloodGroup/data/repositories/blood_repository.dart';
import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:blood_link/features/bloodGroup/domain/repositories/blood_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetBloodGroupByIdParams extends Equatable {
  final String bloodId;

  const GetBloodGroupByIdParams({required this.bloodId});

  @override
  List<Object?> get props => [bloodId];
}

// Provider
final getBloodGroupByIdUsecaseProvider = Provider<GetBloodGroupByIdUsecase>((
  ref,
) {
  return GetBloodGroupByIdUsecase(
    bloodRepository: ref.read(bloodRepositoryProvider),
  );
});

class GetBloodGroupByIdUsecase
    implements UsecaseWithParams<BloodEntity, GetBloodGroupByIdParams> {
  final IBloodRepository _bloodRepository;

  GetBloodGroupByIdUsecase({required IBloodRepository bloodRepository})
    : _bloodRepository = bloodRepository;

  @override
  Future<Either<Failure, BloodEntity>> call(GetBloodGroupByIdParams param) {
    return _bloodRepository.getBloodById(param.bloodId);
  }
}
