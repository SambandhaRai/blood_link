import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/request/data/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinishRequestParams extends Equatable {
  final String requestId;

  const FinishRequestParams({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

final finishRequestUsecaseProvider = Provider<FinishRequestUsecase>((ref) {
  return FinishRequestUsecase(
    requestRepository: ref.read(requestRepositoryProvider),
  );
});

class FinishRequestUsecase
    implements UsecaseWithParams<RequestEntity, FinishRequestParams> {
  final IRequestRepository _requestRepository;

  FinishRequestUsecase({required IRequestRepository requestRepository})
    : _requestRepository = requestRepository;

  @override
  Future<Either<Failure, RequestEntity>> call(FinishRequestParams param) {
    return _requestRepository.finishRequest(param.requestId);
  }
}
