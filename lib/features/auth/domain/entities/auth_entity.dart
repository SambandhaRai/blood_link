import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String fullName;
  final String phoneNumber;
  final String dob;
  final String gender;
  final String bloodGroup;
  final String? healthCondition;
  final String email;
  final String? password;
  final String? profilePicture;

  const AuthEntity({
    this.authId,
    required this.fullName,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    required this.bloodGroup,
    this.healthCondition,
    required this.email,
    this.password,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    authId,
    fullName,
    phoneNumber,
    dob,
    gender,
    bloodGroup,
    healthCondition,
    email,
    password,
    profilePicture,
  ];
}
