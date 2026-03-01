import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;

  final String fullName;
  final String phoneNumber;
  final String email;

  final String? profilePicture;

  final String? bloodId;
  final BloodEntity? bloodGroup;

  final String? gender;
  final String? dob;

  final String? healthCondition;

  final String? activeAcceptedRequestId;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    this.profilePicture,
    this.bloodId,
    this.bloodGroup,
    this.gender,
    this.dob,
    this.healthCondition,
    this.activeAcceptedRequestId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    userId,
    fullName,
    phoneNumber,
    email,
    profilePicture,
    bloodId,
    bloodGroup,
    gender,
    dob,
    healthCondition,
    activeAcceptedRequestId,
    createdAt,
    updatedAt,
  ];
}
