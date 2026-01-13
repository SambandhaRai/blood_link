import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String phoneNumber;
  final String dob;
  final String gender;
  final String? bloodId;
  final String? healthCondition;
  final String email;
  final String? password;
  final String? profilePicture;

  const AuthEntity({
    this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    this.bloodId,
    this.healthCondition,
    required this.email,
    this.password,
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
    healthCondition,
    email,
    password,
    profilePicture,
  ];
}
