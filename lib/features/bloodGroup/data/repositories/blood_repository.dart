import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/bloodGroup/data/datasource/local/blood_local_datasource.dart';
import 'package:blood_link/features/bloodGroup/data/models/blood_hive_model.dart';
import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:blood_link/features/bloodGroup/domain/repositories/blood_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bloodRepositoryProvider = Provider<IBloodRepository>((ref) {
  return BloodRepository(
    bloodLocalDatasource: ref.read(bloodLocalDatasourceProvider),
  );
});

class BloodRepository implements IBloodRepository {
  final BloodLocalDatasource _bloodLocalDatasource;

  BloodRepository({required BloodLocalDatasource bloodLocalDatasource})
    : _bloodLocalDatasource = bloodLocalDatasource;

  @override
  Future<Either<Failure, bool>> createBloodGroup(BloodEntity blood) async {
    try {
      final model = BloodHiveModel.fromEntity(blood);
      final result = await _bloodLocalDatasource.createBloodGroup(model);
      if (result) {
        return Right(true);
      }
      return Left(
        LocalDatabaseFailure(message: "Failure to create Blood Group"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BloodEntity>>> getAllBloodGroup() async {
    try {
      final models = await _bloodLocalDatasource.getAllBloodGroup();
      final entities = BloodHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BloodEntity>> getBloodById(String bloodId) async {
    try {
      final model = await _bloodLocalDatasource.getBloodById(bloodId);
      final entity = model.toEntity();
      return Right(entity);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
