import 'package:equatable/equatable.dart';

enum ConditionType { critical, urgent, stable }

enum RequestForType { self, others }

class RequestEntity extends Equatable {
  final String? requestId;

  final String recipientBloodId;
  final String hospitalId;
  final String? postedBy;
  final String? donorId;

  final String? bloodGroup;
  final String? hospitalName;
  final String? postedByName;
  final String? postedByProfilePicture;

  final String recipientDetails;
  final ConditionType recipientCondition;

  final RequestForType requestFor;
  final String? relationToPatient;
  final String? patientName;
  final String? patientPhone;

  final String? requestStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RequestEntity({
    this.requestId,
    required this.recipientBloodId,
    required this.hospitalId,
    this.postedBy,
    this.donorId,

    this.bloodGroup,
    this.hospitalName,
    this.postedByName,
    this.postedByProfilePicture,

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
    bloodGroup,
    hospitalName,
    postedByName,
    postedByProfilePicture,
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
