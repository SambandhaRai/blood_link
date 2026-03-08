import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:blood_link/features/hospital/domain/entities/hospital_entity.dart';
import 'package:blood_link/features/user/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

enum ConditionType { critical, urgent, stable }

enum RequestForType { self, others }

class RequestEntity extends Equatable {
  final String? requestId;

  final String recipientBloodId;
  final BloodEntity? recipientBlood;

  final String hospitalId;
  final HospitalEntity? hospital;

  final String? postedBy;
  final UserEntity? receiver;

  final String? donorId;
  final UserEntity? donor;

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
    required this.recipientBlood,

    required this.hospitalId,
    required this.hospital,

    this.postedBy,
    this.receiver,

    this.donorId,
    this.donor,

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
    recipientBlood,
    hospitalId,
    hospital,
    postedBy,
    receiver,
    donorId,
    donor,
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
