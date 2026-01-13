import 'package:blood_link/core/constants/hive_table_constant.dart';
import 'package:blood_link/features/auth/domain/entities/auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String phoneNumber;

  @HiveField(3)
  final String dob;

  @HiveField(4)
  final String gender;

  @HiveField(5)
  final String? bloodId;

  @HiveField(6)
  final String? healthCondition;

  @HiveField(7)
  final String email;

  @HiveField(8)
  final String? password;

  @HiveField(9)
  final String? profilePicture;

  AuthHiveModel({
    String? userId,
    required this.fullName,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    this.bloodId,
    this.healthCondition,
    required this.email,
    this.password,
    this.profilePicture,
  }) : userId = userId ?? Uuid().v4();

  // fromEntity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      userId: entity.userId,
      fullName: entity.fullName,
      phoneNumber: entity.phoneNumber,
      dob: entity.dob,
      gender: entity.gender,
      bloodId: entity.bloodId,
      healthCondition: entity.healthCondition,
      email: entity.email,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }

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
      profilePicture: profilePicture,
    );
  }

  // toEntityList
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
