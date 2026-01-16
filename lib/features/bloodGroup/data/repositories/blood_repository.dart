import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/services/connectivity/network_info.dart';
import 'package:blood_link/features/bloodGroup/data/datasource/local/blood_local_datasource.dart';
import 'package:blood_link/features/bloodGroup/data/datasource/remote/blood_remote_datasource.dart';
import 'package:blood_link/features/bloodGroup/data/models/blood_api_model.dart';
import 'package:blood_link/features/bloodGroup/data/models/blood_hive_model.dart';
import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:blood_link/features/bloodGroup/domain/repositories/blood_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bloodRepositoryProvider = Provider<IBloodRepository>((ref) {
  return BloodRepository(
    bloodLocalDatasource: ref.read(bloodLocalDatasourceProvider),
    bloodRemoteDatasource: ref.read(bloodRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class BloodRepository implements IBloodRepository {
  final BloodLocalDatasource _bloodLocalDatasource;
  final BloodRemoteDatasource _bloodRemoteDatasource;
  final NetworkInfo _networkInfo;

  BloodRepository({
    required BloodLocalDatasource bloodLocalDatasource,
    required BloodRemoteDatasource bloodRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _bloodLocalDatasource = bloodLocalDatasource,
       _bloodRemoteDatasource = bloodRemoteDatasource,
       _networkInfo = networkInfo;

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
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _bloodRemoteDatasource.getAllBloodGroup();
        final result = BloodApiModel.toEntityList(apiModel);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data['message'] ?? "Failed to fetch Blood Groups",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _bloodLocalDatasource.getAllBloodGroup();
        final entities = BloodHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, BloodEntity>> getBloodById(String bloodId) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _bloodRemoteDatasource.getBloodById(bloodId);
        final result = apiModel.toEntity();
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data['message'] ?? "Failed to fetch Blood Group",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _bloodLocalDatasource.getBloodById(bloodId);
        final entity = model.toEntity();
        return Right(entity);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
