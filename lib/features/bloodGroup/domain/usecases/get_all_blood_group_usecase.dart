import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/bloodGroup/data/repositories/blood_repository.dart';
import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:blood_link/features/bloodGroup/domain/repositories/blood_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final getAllBloodGroupUsecaseProvider = Provider<GetAllBloodGroupUsecase>((
  ref,
) {
  return GetAllBloodGroupUsecase(
    bloodRepository: ref.read(bloodRepositoryProvider),
  );
});

class GetAllBloodGroupUsecase
    implements UsecaseWithoutParams<List<BloodEntity>> {
  final IBloodRepository _bloodRepository;
  GetAllBloodGroupUsecase({required IBloodRepository bloodRepository})
    : _bloodRepository = bloodRepository;

  @override
  Future<Either<Failure, List<BloodEntity>>> call() {
    return _bloodRepository.getAllBloodGroup();
  }
}
