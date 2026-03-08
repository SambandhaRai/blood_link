import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/request/data/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteRequestParams extends Equatable {
  final String requestId;

  const DeleteRequestParams({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

final deleteRequestUsecaseProvider = Provider<DeleteRequestUsecase>((ref) {
  return DeleteRequestUsecase(
    requestRepository: ref.read(requestRepositoryProvider),
  );
});

class DeleteRequestUsecase
    implements UsecaseWithParams<void, DeleteRequestParams> {
  final IRequestRepository _requestRepository;

  DeleteRequestUsecase({required IRequestRepository requestRepository})
    : _requestRepository = requestRepository;

  @override
  Future<Either<Failure, void>> call(DeleteRequestParams param) {
    return _requestRepository.deleteRequest(param.requestId);
  }
}
