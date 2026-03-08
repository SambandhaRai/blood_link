import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/request/data/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetRequestByIdParams extends Equatable {
  final String requestId;

  const GetRequestByIdParams({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

final getRequestByIdUsecaseProvider = Provider<GetRequestByIdUsecase>((ref) {
  return GetRequestByIdUsecase(
    requestRepository: ref.read(requestRepositoryProvider),
  );
});

class GetRequestByIdUsecase
    implements UsecaseWithParams<RequestEntity, GetRequestByIdParams> {
  final IRequestRepository _requestRepository;

  GetRequestByIdUsecase({required IRequestRepository requestRepository})
    : _requestRepository = requestRepository;

  @override
  Future<Either<Failure, RequestEntity>> call(GetRequestByIdParams param) {
    return _requestRepository.getRequestById(param.requestId);
  }
}
