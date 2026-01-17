import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/bloodGroup/data/repositories/blood_repository.dart';
import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:blood_link/features/bloodGroup/domain/repositories/blood_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateBloodGroupParams extends Equatable {
  final String bloodGroup;

  const CreateBloodGroupParams({required this.bloodGroup});

  @override
  List<Object?> get props => [bloodGroup];
}

// Provider
final createBloodGroupUsecaseProvider = Provider<CreateBloodGroupUsecase>((
  ref,
) {
  return CreateBloodGroupUsecase(
    bloodRepostory: ref.read(bloodRepositoryProvider),
  );
});

class CreateBloodGroupUsecase
    implements UsecaseWithParams<bool, CreateBloodGroupParams> {
  final IBloodRepository _bloodRepository;

  CreateBloodGroupUsecase({required IBloodRepository bloodRepostory})
    : _bloodRepository = bloodRepostory;

  @override
  Future<Either<Failure, bool>> call(CreateBloodGroupParams param) {
    BloodEntity bloodEntity = BloodEntity(bloodGroup: param.bloodGroup);
    return _bloodRepository.createBloodGroup(bloodEntity);
  }
}
