import 'package:equatable/equatable.dart';

enum ConditionType { critical, urgent, stable }

enum RequestForType { self, others }

class RequestEntity extends Equatable {
  final String? requestId;

  final String recipientBloodId;
  final String recipientDetails;
  final ConditionType recipientCondition;
  final String hospitalId;

  final String? postedBy;

  final RequestForType requestFor;

  final String? relationToPatient;
  final String? patientName;
  final String? patientPhone;

  final String? donorId;

  final String? requestStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RequestEntity({
    this.requestId,
    required this.recipientBloodId,
    required this.recipientDetails,
    required this.recipientCondition,
    required this.hospitalId,
    this.postedBy,
    this.requestFor = RequestForType.self,
    this.relationToPatient,
    this.patientName,
    this.patientPhone,
    this.donorId,
    this.requestStatus,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    requestId,
    recipientBloodId,
    recipientDetails,
    recipientCondition,
    hospitalId,
    postedBy,
    requestFor,
    relationToPatient,
    patientName,
    patientPhone,
    donorId,
    requestStatus,
    createdAt,
    updatedAt,
  ];
}
