import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String phoneNumber;
  final String dob;
  final String gender;
  final String? bloodId;
  final BloodEntity? bloodGroup;
  final String? healthCondition;
  final String email;
  final String? password;
  final String? confirmPassword;
  final String? profilePicture;

  const AuthEntity({
    this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    this.bloodId,
    this.bloodGroup,
    this.healthCondition,
    required this.email,
    this.password,
    this.confirmPassword,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    userId,
    fullName,
    phoneNumber,
    dob,
    gender,
    bloodId,
    bloodGroup,
    healthCondition,
    email,
    password,
    confirmPassword,
    profilePicture,
  ];
}
