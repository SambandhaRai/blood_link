import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/services/connectivity/network_info.dart';
import 'package:blood_link/features/request/data/datasource/remote/request_remote_datasource.dart';
import 'package:blood_link/features/request/data/models/request_api_model.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  return RequestRepository(
    requestRemoteDatasource: ref.read(requestRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class RequestRepository implements IRequestRepository {
  final RequestRemoteDatasource _requestRemoteDatasource;
  final NetworkInfo _networkInfo;

  RequestRepository({
    required RequestRemoteDatasource requestRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _requestRemoteDatasource = requestRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> createRequest(RequestEntity request) async {
    if (await _networkInfo.isConnected) {
      try {
        final requestApiModel = RequestApiModel.fromEntity(request);
        await _requestRemoteDatasource.createRequest(requestApiModel);
        return Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, List<RequestEntity>>> getAllRequests() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _requestRemoteDatasource.getAllRequests();
        final entities = RequestApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: "No Internet Connection"));
    }
  }
}
