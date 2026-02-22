import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IRequestRepository {
  Future<Either<Failure, List<RequestEntity>>> getAllRequests();
  Future<Either<Failure, bool>> createRequest(RequestEntity request);
}
