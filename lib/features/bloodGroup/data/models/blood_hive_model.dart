import 'package:blood_link/core/constants/hive_table_constant.dart';
import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'blood_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.bloodTypeId)
class BloodHiveModel extends HiveObject {
  @HiveField(0)
  final String? bloodId;

  @HiveField(1)
  final String bloodGroup;

  BloodHiveModel({String? bloodId, required this.bloodGroup})
    : bloodId = bloodId ?? Uuid().v4();

  // fromEntity
  factory BloodHiveModel.fromEntity(BloodEntity entity) {
    return BloodHiveModel(
      bloodId: entity.bloodId,
      bloodGroup: entity.bloodGroup,
    );
  }

  // toEntity
  BloodEntity toEntity() {
    return BloodEntity(bloodId: bloodId, bloodGroup: bloodGroup);
  }

  // toEntityList
  static List<BloodEntity> toEntityList(List<BloodHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
