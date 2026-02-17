import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/hospital/data/repositories/hospital_repository.dart';
import 'package:blood_link/features/hospital/domain/entities/hospital_entity.dart';
import 'package:blood_link/features/hospital/domain/repositories/hospital_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllHospitalsUsecaseProvider = Provider<GetAllHospitalsUsecase>((ref) {
  return GetAllHospitalsUsecase(
    hospitalRepository: ref.read(hospitalRepositoryProvider),
  );
});

class GetAllHospitalsUsecase
    implements UsecaseWithoutParams<List<HospitalEntity>> {
  final IHospitalRepository _hospitalRepository;

  GetAllHospitalsUsecase({required IHospitalRepository hospitalRepository})
    : _hospitalRepository = hospitalRepository;
  @override
  Future<Either<Failure, List<HospitalEntity>>> call() {
    return _hospitalRepository.getAllHospitals();
  }
}
