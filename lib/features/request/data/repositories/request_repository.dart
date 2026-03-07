import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/services/connectivity/network_info.dart';
import 'package:blood_link/features/request/data/datasource/local/request_local_datasource.dart';
import 'package:blood_link/features/request/data/datasource/remote/request_remote_datasource.dart';
import 'package:blood_link/features/request/data/models/create_request_api_model.dart';
import 'package:blood_link/features/request/data/models/request_hive_model.dart';
import 'package:blood_link/features/request/domain/entities/create_request_entity.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestRepositoryProvider = Provider<IRequestRepository>((ref) {
  return RequestRepository(
    requestLocalDatasource: ref.read(requestLocalDatasourceProvider),
    requestRemoteDatasource: ref.read(requestRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class RequestRepository implements IRequestRepository {
  static const int _pendingRequestCacheLimit = 4;
  static const int _historyCacheLimitPerSection = 4;

  final RequestLocalDatasource _requestLocalDatasource;
  final RequestRemoteDatasource _requestRemoteDatasource;
  final NetworkInfo _networkInfo;

  RequestRepository({
    required RequestLocalDatasource requestLocalDatasource,
    required RequestRemoteDatasource requestRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _requestLocalDatasource = requestLocalDatasource,
       _requestRemoteDatasource = requestRemoteDatasource,
       _networkInfo = networkInfo;

  String _dioErrorMessage(
    DioException e, {
    String fallback = "Request failed",
  }) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data["message"];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
      final errors = data["errors"];
      if (errors is String && errors.trim().isNotEmpty) {
        return errors.trim();
      }
    }
    return e.message?.trim().isNotEmpty == true ? e.message!.trim() : fallback;
  }

  @override
  Future<Either<Failure, RequestEntity>> createRequest(
    CreateRequestEntity request,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No Internet Connection"));
    }

    try {
      final payload = CreateRequestApiModel.fromEntity(request);
      final created = await _requestRemoteDatasource.createRequest(payload);

      return Right(created.toEntity());
    } on DioException catch (e) {
      final msg =
          e.response?.data?["errors"] ??
          e.response?.data?["message"] ??
          e.message ??
          "Request failed";
      return Left(ApiFailure(message: msg.toString()));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RequestEntity>> updateRequest(
    String requestId,
    CreateRequestEntity request,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No Internet Connection"));
    }

    try {
      final payload = CreateRequestApiModel.fromEntity(request);
      final updated = await _requestRemoteDatasource.updateRequest(
        requestId,
        payload,
      );
      return Right(updated.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _dioErrorMessage(e, fallback: "Failed to update request"),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRequest(String requestId) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No Internet Connection"));
    }

    try {
      await _requestRemoteDatasource.deleteRequest(requestId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _dioErrorMessage(e, fallback: "Failed to delete request"),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RequestEntity>> getRequestById(
    String requestId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No Internet Connection"));
    }

    try {
      final model = await _requestRemoteDatasource.getRequestById(requestId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<
    Either<
      Failure,
      ({
        List<RequestEntity> requests,
        int page,
        int size,
        int total,
        int totalPages,
      })
    >
  >
  getAllPendingRequests({int page = 1, int size = 10, String? search}) async {
    if (!await _networkInfo.isConnected) {
      final cachedRequests = await _requestLocalDatasource.getAllRequests(
        amount: size,
      );
      if (cachedRequests.isNotEmpty) {
        final entities = cachedRequests.map((e) => e.toEntity()).toList();
        return Right((
          requests: entities,
          page: 1,
          size: entities.length,
          total: entities.length,
          totalPages: 1,
        ));
      }
      return Left(
        NetworkFailure(message: "No Internet Connection and no cached data"),
      );
    }

    try {
      final result = await _requestRemoteDatasource.getAllPendingRequests(
        page: page,
        size: size,
        search: search,
      );

      final entities = result.requests.map((e) => e.toEntity()).toList();
      final hiveModels = RequestHiveModel.fromApiModelList(result.requests);
      await _requestLocalDatasource.cachePendingRequests(
        hiveModels,
        amount: _pendingRequestCacheLimit,
      );

      return Right((
        requests: entities,
        page: result.page,
        size: result.size,
        total: result.total,
        totalPages: result.totalPages,
      ));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<
    Either<
      Failure,
      ({
        List<RequestEntity> donated,
        ({
          List<RequestEntity> requestedOngoing,
          List<RequestEntity> donationOngoing,
        })
        ongoing,
        List<RequestEntity> received,
      })
    >
  >
  getMyHistory() async {
    if (!await _networkInfo.isConnected) {
      final cached = await _requestLocalDatasource.getCachedHistoryRequests();
      final donated = cached.donated.map((e) => e.toEntity()).toList();
      final requestedOngoing = cached.ongoing.requestedOngoing
          .map((e) => e.toEntity())
          .toList();
      final donationOngoing = cached.ongoing.donationOngoing
          .map((e) => e.toEntity())
          .toList();
      final received = cached.received.map((e) => e.toEntity()).toList();

      final hasAnyHistory =
          donated.isNotEmpty ||
          requestedOngoing.isNotEmpty ||
          donationOngoing.isNotEmpty ||
          received.isNotEmpty;

      if (!hasAnyHistory) {
        return Left(
          NetworkFailure(
            message: "No Internet Connection and no cached history data",
          ),
        );
      }

      return Right((
        donated: donated,
        ongoing: (
          requestedOngoing: requestedOngoing,
          donationOngoing: donationOngoing,
        ),
        received: received,
      ));
    }
    try {
      final result = await _requestRemoteDatasource.getMyHistory();

      await _requestLocalDatasource.cacheHistoryRequests(
        donated: RequestHiveModel.fromApiModelList(result.donated),
        requestedOngoing: RequestHiveModel.fromApiModelList(
          result.ongoing.requestedOngoing,
        ),
        donationOngoing: RequestHiveModel.fromApiModelList(
          result.ongoing.donationOngoing,
        ),
        received: RequestHiveModel.fromApiModelList(result.received),
        amountPerSection: _historyCacheLimitPerSection,
      );

      return Right((
        donated: result.donated.map((e) => e.toEntity()).toList(),
        ongoing: (
          requestedOngoing: result.ongoing.requestedOngoing
              .map((e) => e.toEntity())
              .toList(),
          donationOngoing: result.ongoing.donationOngoing
              .map((e) => e.toEntity())
              .toList(),
        ),
        received: result.received.map((e) => e.toEntity()).toList(),
      ));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RequestEntity>> acceptRequest(String requestId) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No Internet Connection"));
    }
    try {
      final model = await _requestRemoteDatasource.acceptRequest(requestId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _dioErrorMessage(e, fallback: "Failed to accept request"),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RequestEntity>> finishRequest(String requestId) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No Internet Connection"));
    }

    try {
      final model = await _requestRemoteDatasource.finishRequest(requestId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<
    Either<
      Failure,
      ({
        List<RequestEntity> requests,
        int page,
        int size,
        int total,
        int totalPages,
      })
    >
  >
  getMatchedRequests({
    required double lng,
    required double lat,
    double km = 5,
    int page = 1,
    int size = 10,
    String? search,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No Internet Connection"));
    }

    try {
      final result = await _requestRemoteDatasource.getMatchedRequests(
        lng: lng,
        lat: lat,
        km: km,
        page: page,
        size: size,
        search: search,
      );

      return Right((
        requests: result.requests.map((e) => e.toEntity()).toList(),
        page: result.page,
        size: result.size,
        total: result.total,
        totalPages: result.totalPages,
      ));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
