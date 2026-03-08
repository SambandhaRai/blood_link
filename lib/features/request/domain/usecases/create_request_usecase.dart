import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/usecases/app_usecase.dart';
import 'package:blood_link/features/request/data/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/entities/create_request_entity.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart'
    hide RequestForType, ConditionType;
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRequestParams extends Equatable {
  final String recipientBloodId;
  final String recipientDetails;
  final ConditionType recipientCondition;
  final String hospitalId;

  final RequestForType requestFor;
  final String? relationToPatient;
  final String? patientName;
  final String? patientPhone;

  const CreateRequestParams({
    required this.recipientBloodId,
    required this.recipientDetails,
    required this.recipientCondition,
    required this.hospitalId,
    this.requestFor = RequestForType.self,
    this.relationToPatient,
    this.patientName,
    this.patientPhone,
  });

  @override
  List<Object?> get props => [
    recipientBloodId,
    recipientDetails,
    recipientCondition,
    hospitalId,
    requestFor,
    relationToPatient,
    patientName,
    patientPhone,
  ];
}

final createRequestUsecaseProvider = Provider<CreateRequestUsecase>((ref) {
  return CreateRequestUsecase(
    requestRepository: ref.read(requestRepositoryProvider),
  );
});

class CreateRequestUsecase
    implements UsecaseWithParams<RequestEntity, CreateRequestParams> {
  final IRequestRepository _requestRepository;

  CreateRequestUsecase({required IRequestRepository requestRepository})
    : _requestRepository = requestRepository;

  @override
  Future<Either<Failure, RequestEntity>> call(CreateRequestParams param) {
    final entity = CreateRequestEntity(
      recipientBloodId: param.recipientBloodId,
      hospitalId: param.hospitalId,
      recipientDetails: param.recipientDetails,
      recipientCondition: param.recipientCondition,
      requestFor: param.requestFor,
      relationToPatient: param.requestFor == RequestForType.others
          ? param.relationToPatient
          : null,
      patientName: param.requestFor == RequestForType.others
          ? param.patientName
          : null,
      patientPhone: param.requestFor == RequestForType.others
          ? param.patientPhone
          : null,
    );

    return _requestRepository.createRequest(entity);
  }
}
