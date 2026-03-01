import 'package:blood_link/features/auth/domain/entities/auth_entity.dart';
import 'package:blood_link/features/bloodGroup/data/models/blood_api_model.dart';
import 'package:blood_link/features/user/domain/entities/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthApiModel {
  @JsonKey(name: "_id")
  final String? userId;
  final String fullName;
  final String phoneNumber;
  final String dob;
  final String gender;
  final BloodApiModel? bloodId;
  final String? healthCondition;
  final String email;
  final String? password;
  final String? confirmPassword;
  final String? profilePicture;

  AuthApiModel({
    this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    this.bloodId,
    this.healthCondition,
    required this.email,
    this.password,
    this.confirmPassword,
    this.profilePicture,
  });

  // toJson
  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  // fromJson
  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  // toEntity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      dob: dob,
      gender: gender,
      bloodId: bloodId?.bloodId,
      bloodGroup: bloodId?.toEntity(),
      healthCondition: healthCondition,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      profilePicture: profilePicture,
    );
  }

  UserEntity toUserEntity() {
    return UserEntity(
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      profilePicture: profilePicture,
      bloodId: bloodId?.bloodId,
      bloodGroup: bloodId?.toEntity(),
      gender: gender,
      dob: dob,
      healthCondition: healthCondition,
    );
  }

  // fromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      userId: entity.userId,
      fullName: entity.fullName,
      phoneNumber: entity.phoneNumber,
      dob: entity.dob,
      gender: entity.gender,
      bloodId: entity.bloodGroup != null
          ? BloodApiModel.fromEntity(entity.bloodGroup!)
          : null,
      healthCondition: entity.healthCondition,
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      profilePicture: entity.profilePicture,
    );
  }

  // toEntityList
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
