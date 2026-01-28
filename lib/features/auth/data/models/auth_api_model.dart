import 'package:blood_link/features/auth/domain/entities/auth_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel {
  @JsonKey(name: "_id")
  final String? userId;
  final String fullName;
  final String phoneNumber;
  final String dob;
  final String gender;
  final String? bloodId;
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
  // {
  //   return {
  //     "fullName": fullName,
  //     "phoneNumber": phoneNumber,
  //     "dob": _toIsoDob(dob),
  //     "gender": gender,
  //     "bloodId": bloodId,
  //     "healthCondition": healthCondition,
  //     "email": email,
  //     "password": password,
  //     "confirmPassword": confirmPassword,
  //     "profilePicture": profilePicture,
  //   };
  // }

  // fromJson
  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);
  // {
  //   return AuthApiModel(
  //     userId: json['_id'] as String?,
  //     fullName: json['fullName'] as String,
  //     phoneNumber: json['phoneNumber'] as String,
  //     dob: json['dob'] as String,
  //     gender: json['gender'] as String,
  //     bloodId: json['bloodId'] as String?,
  //     healthCondition: json['healthCondition'] as String?,
  //     email: json['email'] as String,
  //     password: json['password'] as String?,
  //     confirmPassword: json['confirmPassword'] as String?,
  //     profilePicture: json['profilePicture'] as String?,
  //   );
  // }

  // toEntity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      dob: dob,
      gender: gender,
      bloodId: bloodId,
      healthCondition: healthCondition,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      profilePicture: profilePicture,
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
      bloodId: entity.bloodId,
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
