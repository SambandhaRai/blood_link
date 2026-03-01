import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/request/domain/entities/create_request_entity.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IRequestRepository {
  Future<Either<Failure, RequestEntity>> createRequest(
    CreateRequestEntity request,
  );
  Future<Either<Failure, RequestEntity>> getRequestById(String requestId);
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
  getAllPendingRequests({int page, int size, String? search});

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
  getMyHistory();

  Future<Either<Failure, RequestEntity>> acceptRequest(String requestId);
  Future<Either<Failure, RequestEntity>> finishRequest(String requestId);

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
    double km,
    int page,
    int size,
    String? search,
  });
}
