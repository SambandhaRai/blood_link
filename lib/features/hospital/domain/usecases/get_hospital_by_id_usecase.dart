import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/hospital/data/repositories/hospital_repository.dart';
import 'package:blood_link/features/hospital/domain/entities/hospital_entity.dart';
import 'package:blood_link/features/hospital/domain/repositories/hospital_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetHospitalByIdParams extends Equatable {
  final String hospitalId;

  const GetHospitalByIdParams({required this.hospitalId});

  @override
  List<Object?> get props => [hospitalId];
}

final getHospitalByIdUsecaseProvider = Provider<GetHospitalByIdUsecase>((ref) {
  return GetHospitalByIdUsecase(
    hospitalRepository: ref.read(hospitalRepositoryProvider),
  );
});

class GetHospitalByIdUsecase
    implements UsecaseWithParams<HospitalEntity, GetHospitalByIdParams> {
  final IHospitalRepository _hospitalRepository;

  GetHospitalByIdUsecase({required IHospitalRepository hospitalRepository})
    : _hospitalRepository = hospitalRepository;

  @override
  Future<Either<Failure, HospitalEntity>> call(GetHospitalByIdParams param) {
    return _hospitalRepository.getHospitalById(param.hospitalId);
  }
}
