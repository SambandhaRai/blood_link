import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/request/data/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AcceptRequestParams extends Equatable {
  final String requestId;

  const AcceptRequestParams({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

final acceptRequestUsecaseProvider = Provider<AcceptRequestUsecase>((ref) {
  return AcceptRequestUsecase(
    requestRepository: ref.read(requestRepositoryProvider),
  );
});

class AcceptRequestUsecase
    implements UsecaseWithParams<RequestEntity, AcceptRequestParams> {
  final IRequestRepository _requestRepository;

  AcceptRequestUsecase({required IRequestRepository requestRepository})
    : _requestRepository = requestRepository;

  @override
  Future<Either<Failure, RequestEntity>> call(AcceptRequestParams param) {
    return _requestRepository.acceptRequest(param.requestId);
  }
}
