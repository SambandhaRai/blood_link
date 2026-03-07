import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/services/connectivity/network_info.dart';
import 'package:blood_link/features/hospital/data/datasource/local/hospital_local_datasource.dart';
import 'package:blood_link/features/hospital/data/datasource/remote/hospital_remote_datasource.dart';
import 'package:blood_link/features/hospital/data/model/hospital_api_model.dart';
import 'package:blood_link/features/hospital/data/model/hospital_hive_model.dart';
import 'package:blood_link/features/hospital/domain/entities/hospital_entity.dart';
import 'package:blood_link/features/hospital/domain/repositories/hospital_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hospitalRepositoryProvider = Provider<HospitalRepository>((ref) {
  final hospitalLocalDatasource = ref.read(hospitalLocalDatasourceProvider);
  final hospitalRemoteDatasource = ref.read(hospitalRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return HospitalRepository(
    hospitalLocalDatasource: hospitalLocalDatasource,
    hospitalRemoteDatasource: hospitalRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class HospitalRepository implements IHospitalRepository {
  final HospitalLocalDatasource _hospitalLocalDatasource;
  final HospitalRemoteDatasource _hospitalRemoteDatasource;
  final NetworkInfo _networkInfo;

  HospitalRepository({
    required HospitalLocalDatasource hospitalLocalDatasource,
    required HospitalRemoteDatasource hospitalRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _hospitalLocalDatasource = hospitalLocalDatasource,
       _hospitalRemoteDatasource = hospitalRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<HospitalEntity>>> getAllHospitals() async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _hospitalRemoteDatasource.getAllHospitals();
        final hiveModels = HospitalHiveModel.fromApiModelList(apiModel);
        await _hospitalLocalDatasource.cacheAllHospitals(hiveModels);
        final result = HospitalApiModel.toEntityList(apiModel);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? "Failed to fetch Hospitals",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _hospitalLocalDatasource.getAllHospitals();
        final entities = HospitalHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, HospitalEntity>> getHospitalById(
    String hospitalId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _hospitalRemoteDatasource.getHospitalById(
          hospitalId,
        );
        if (apiModel != null) {
          return Right(apiModel.toEntity());
        }
        return Left(ApiFailure(message: "Failed to fetch Hospital"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Failed to fetch Hospital",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _hospitalLocalDatasource.getHospitalById(
          hospitalId,
        );
        if (model != null) {
          return Right(model.toEntity());
        }
        return Left(LocalDatabaseFailure(message: "Hospital not found"));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
