import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/request/data/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getMyHistoryUsecaseProvider = Provider<GetMyHistoryUsecase>((ref) {
  return GetMyHistoryUsecase(
    requestRepository: ref.read(requestRepositoryProvider),
  );
});

class GetMyHistoryUsecase
    implements
        UsecaseWithoutParams<
          ({
            List<RequestEntity> donated,
            ({
              List<RequestEntity> requestedOngoing,
              List<RequestEntity> donationOngoing,
            })
            ongoing,
            List<RequestEntity> received,
          })
        > {
  final IRequestRepository _requestRepository;

  GetMyHistoryUsecase({required IRequestRepository requestRepository})
    : _requestRepository = requestRepository;

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
  call() {
    return _requestRepository.getMyHistory();
  }
}
