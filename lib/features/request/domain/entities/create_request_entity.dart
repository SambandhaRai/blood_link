import 'package:equatable/equatable.dart';

enum ConditionType { critical, urgent, stable }

enum RequestForType { self, others }

class CreateRequestEntity extends Equatable {
  final String? requestId;

  final String recipientBloodId;

  final String hospitalId;

  final String? postedBy;

  final String? donorId;

  final String recipientDetails;
  final ConditionType recipientCondition;

  final RequestForType requestFor;
  final String? relationToPatient;
  final String? patientName;
  final String? patientPhone;

  final String? requestStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CreateRequestEntity({
    this.requestId,
    required this.recipientBloodId,

    required this.hospitalId,

    this.postedBy,

    this.donorId,

    required this.recipientDetails,
    required this.recipientCondition,

    this.requestFor = RequestForType.self,
    this.relationToPatient,
    this.patientName,
    this.patientPhone,

    this.requestStatus,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    requestId,
    recipientBloodId,
    hospitalId,
    postedBy,
    donorId,
    recipientDetails,
    recipientCondition,
    requestFor,
    relationToPatient,
    patientName,
    patientPhone,
    requestStatus,
    createdAt,
    updatedAt,
  ];
}
