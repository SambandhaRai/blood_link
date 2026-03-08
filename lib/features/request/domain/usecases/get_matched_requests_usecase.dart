import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/request/data/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetMatchedRequestsParams extends Equatable {
  final double lng;
  final double lat;
  final double km;
  final int page;
  final int size;
  final String? search;

  const GetMatchedRequestsParams({
    required this.lng,
    required this.lat,
    this.km = 5,
    this.page = 1,
    this.size = 10,
    this.search,
  });

  @override
  List<Object?> get props => [lng, lat, km, page, size, search];
}

final getMatchedRequestsUsecaseProvider = Provider<GetMatchedRequestsUsecase>((
  ref,
) {
  return GetMatchedRequestsUsecase(
    requestRepository: ref.read(requestRepositoryProvider),
  );
});

class GetMatchedRequestsUsecase
    implements
        UsecaseWithParams<
          ({
            List<RequestEntity> requests,
            int page,
            int size,
            int total,
            int totalPages,
          }),
          GetMatchedRequestsParams
        > {
  final IRequestRepository _requestRepository;

  GetMatchedRequestsUsecase({required IRequestRepository requestRepository})
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
  call(GetMatchedRequestsParams param) {
    return _requestRepository.getMatchedRequests(
      lng: param.lng,
      lat: param.lat,
      km: param.km,
      page: param.page,
      size: param.size,
      search: param.search,
    );
  }
}
