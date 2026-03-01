import 'package:blood_link/features/bloodGroup/data/models/blood_api_model.dart';
import 'package:blood_link/features/user/domain/entities/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserApiModel {
  @JsonKey(name: "_id")
  final String? userId;

  final String fullName;
  final String phoneNumber;
  final String email;

  final String? profilePicture;

  final BloodApiModel? bloodId;

  final String? gender;

  final String? dob;

  final String? healthCondition;

  final dynamic activeAcceptedRequestId;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserApiModel({
    this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    this.profilePicture,
    this.bloodId,
    this.gender,
    this.dob,
    this.healthCondition,
    this.activeAcceptedRequestId,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  UserEntity toEntity() {
    String? activeReqId;
    final v = activeAcceptedRequestId;

    if (v is String && v.isNotEmpty) {
      activeReqId = v;
    } else if (v is Map) {
      final id = v["_id"];
      if (id is String && id.isNotEmpty) activeReqId = id;
    } else {
      activeReqId = null;
    }

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
      activeAcceptedRequestId: activeReqId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      userId: entity.userId,
      fullName: entity.fullName,
      phoneNumber: entity.phoneNumber,
      email: entity.email,
      profilePicture: entity.profilePicture,
      bloodId: entity.bloodGroup != null
          ? BloodApiModel.fromEntity(entity.bloodGroup!)
          : null,
      gender: entity.gender,
      dob: entity.dob,
      healthCondition: entity.healthCondition,
      activeAcceptedRequestId: entity.activeAcceptedRequestId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<UserEntity> toEntityList(List<UserApiModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }
}
