import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/services/connectivity/network_info.dart';
import 'package:blood_link/features/request/data/datasource/remote/request_remote_datasource.dart';
import 'package:blood_link/features/request/data/models/create_request_api_model.dart';
import 'package:blood_link/features/request/domain/entities/create_request_entity.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestRepositoryProvider = Provider<IRequestRepository>((ref) {
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
      return Left(NetworkFailure(message: "No Internet Connection"));
    }

    try {
      final result = await _requestRemoteDatasource.getAllPendingRequests(
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
      return Left(NetworkFailure(message: "No Internet Connection"));
    }
    try {
      final result = await _requestRemoteDatasource.getMyHistory();

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
