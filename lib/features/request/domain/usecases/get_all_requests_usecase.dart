import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/request/data/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllRequestsUsecaseProvider = Provider<GetAllRequestsUsecase>((ref) {
  return GetAllRequestsUsecase(
    requestRepository: ref.read(requestRepositoryProvider),
  );
});

class GetAllRequestsUsecase
    implements UsecaseWithoutParams<List<RequestEntity>> {
  final IRequestRepository _requestRepository;
  GetAllRequestsUsecase({required IRequestRepository requestRepository})
    : _requestRepository = requestRepository;

  @override
  Future<Either<Failure, List<RequestEntity>>> call() {
    return _requestRepository.getAllRequests();
  }
}
