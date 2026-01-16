import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';

class BloodApiModel {
  final String? bloodId;
  final String bloodGroup;

  BloodApiModel({this.bloodId, required this.bloodGroup});

  // toJson
  Map<String, dynamic> toJson() {
    return {"bloodGroup": bloodGroup};
  }

  // fromJson
  factory BloodApiModel.fromJson(Map<String, dynamic> json) {
    return BloodApiModel(
      bloodId: json['_id'] as String,
      bloodGroup: json['bloodGroup'] as String,
    );
  }

  // toEntity
  BloodEntity toEntity() {
    return BloodEntity(bloodId: bloodId, bloodGroup: bloodGroup);
  }

  // fromEntity
  factory BloodApiModel.fromEntity(BloodEntity entity) {
    return BloodApiModel(
      bloodId: entity.bloodId,
      bloodGroup: entity.bloodGroup,
    );
  }

  // toEntityList
  static List<BloodEntity> toEntityList(List<BloodApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
