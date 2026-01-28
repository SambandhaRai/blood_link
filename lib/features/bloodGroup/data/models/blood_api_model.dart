import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blood_api_model.g.dart';

@JsonSerializable()
class BloodApiModel {
  @JsonKey(name: "_id")
  final String? bloodId;
  final String bloodGroup;

  BloodApiModel({this.bloodId, required this.bloodGroup});

  // toJson
  Map<String, dynamic> toJson() => _$BloodApiModelToJson(this);

  // fromJson
  factory BloodApiModel.fromJson(Map<String, dynamic> json) =>
      _$BloodApiModelFromJson(json);

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
