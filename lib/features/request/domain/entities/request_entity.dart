import 'package:equatable/equatable.dart';

enum ConditionType { critical, urgent, stable }

class RequestEntity extends Equatable {
  final String? requestId;
  final String recipientBloodId;
  final String recipientDetails;
  final ConditionType recipientCondition;
  final String hospitalId;
  final String? recipientId;
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
    this.recipientId,
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
    recipientId,
    donorId,
    requestStatus,
    createdAt,
    updatedAt,
  ];
}
