import 'package:blood_link/features/geo_point/data/model/geo_point_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/hospital_entity.dart';

part 'hospital_api_model.g.dart';

@JsonSerializable()
class HospitalApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final GeoPointApiModel location;
  final bool isActive;

  const HospitalApiModel({
    required this.id,
    required this.name,
    required this.location,
    required this.isActive,
  });

  factory HospitalApiModel.fromJson(Map<String, dynamic> json) =>
      _$HospitalApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$HospitalApiModelToJson(this);

  HospitalEntity toEntity() {
    return HospitalEntity(
      id: id,
      name: name,
      location: location.toEntity(),
      isActive: isActive,
    );
  }

  static List<HospitalEntity> toEntityList(List<HospitalApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
