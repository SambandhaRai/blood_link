import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/request/data/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingRequestsParams extends Equatable {
  final String? search;

  const PendingRequestsParams({this.search});

  @override
  List<Object?> get props => [search];
}

final getAllPendingRequestsUsecaseProvider =
    Provider<GetAllPendingRequestsUsecase>((ref) {
      return GetAllPendingRequestsUsecase(
        requestRepository: ref.read(requestRepositoryProvider),
      );
    });

class GetAllPendingRequestsUsecase
    implements UsecaseWithParams<List<RequestEntity>, PendingRequestsParams> {
  final IRequestRepository _requestRepository;

  GetAllPendingRequestsUsecase({required IRequestRepository requestRepository})
    : _requestRepository = requestRepository;

  @override
  Future<Either<Failure, List<RequestEntity>>> call(
    PendingRequestsParams params,
  ) async {
    final result = await _requestRepository.getAllPendingRequests(
      page: 1,
      size: 10,
      search: params.search,
    );

    return result.map((r) => r.requests);
  }
}
