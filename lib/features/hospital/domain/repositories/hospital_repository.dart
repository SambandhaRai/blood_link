import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/hospital/domain/entities/hospital_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IHospitalRepository {
  Future<Either<Failure, List<HospitalEntity>>> getAllHospitals();
  Future<Either<Failure, HospitalEntity>> getHospitalById(String hospitalId);
}
