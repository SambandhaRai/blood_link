import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IBloodRepository {
  Future<Either<Failure, List<BloodEntity>>> getAllBloodGroup();
  Future<Either<Failure, BloodEntity>> getBloodById(String bloodId);
  Future<Either<Failure, bool>> createBloodGroup(BloodEntity blood);
}
