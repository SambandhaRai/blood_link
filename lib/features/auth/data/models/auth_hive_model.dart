import 'package:blood_link/core/constants/hive_table_constant.dart';
import 'package:blood_link/features/auth/domain/entities/auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String phoneNumber;

  @HiveField(3)
  final String dob;

  @HiveField(4)
  final String gender;

  @HiveField(5)
  final String bloodGroup;

  @HiveField(6)
  final String? healthCondition;

  @HiveField(7)
  final String email;

  @HiveField(8)
  final String? password;

  @HiveField(9)
  final String? profilePicture;

  AuthHiveModel({
    String? authId,
    required this.fullName,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    required this.bloodGroup,
    this.healthCondition,
    required this.email,
    this.password,
    this.profilePicture,
  }) : authId = authId ?? Uuid().v4();

  // fromEntity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      fullName: entity.fullName,
      phoneNumber: entity.phoneNumber,
      dob: entity.dob,
      gender: entity.gender,
      bloodGroup: entity.bloodGroup,
      healthCondition: entity.healthCondition,
      email: entity.email,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }

  // toEntity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      dob: dob,
      gender: gender,
      bloodGroup: bloodGroup,
      healthCondition: healthCondition,
      email: email,
      password: password,
      profilePicture: profilePicture,
    );
  }

  // toEntityList
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
