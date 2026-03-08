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
  final int page;
  final int size;

  const PendingRequestsParams({this.search, this.page = 1, this.size = 10});

  @override
  List<Object?> get props => [search, page, size];
}

final getAllPendingRequestsUsecaseProvider =
    Provider<GetAllPendingRequestsUsecase>((ref) {
      return GetAllPendingRequestsUsecase(
        requestRepository: ref.read(requestRepositoryProvider),
      );
    });

class GetAllPendingRequestsUsecase
    implements
        UsecaseWithParams<
          ({
            List<RequestEntity> requests,
            int page,
            int size,
            int total,
            int totalPages,
          }),
          PendingRequestsParams
        > {
  final IRequestRepository _requestRepository;

  GetAllPendingRequestsUsecase({required IRequestRepository requestRepository})
    : _requestRepository = requestRepository;

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
  call(
    PendingRequestsParams params,
  ) async {
    return _requestRepository.getAllPendingRequests(
      page: params.page,
      size: params.size,
      search: params.search,
    );
  }
}
