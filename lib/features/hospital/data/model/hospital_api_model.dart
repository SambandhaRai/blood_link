import 'package:blood_link/features/geo_point/data/model/geo_point_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/hospital_entity.dart';

part 'hospital_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
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

  factory HospitalApiModel.fromJson(Map<String, dynamic> json) {
    final rawLocation = json['location'];
    final location = rawLocation is Map<String, dynamic>
        ? GeoPointApiModel.fromJson(rawLocation)
        : const GeoPointApiModel(type: 'Point', coordinates: [0, 0]);

    return HospitalApiModel(
      id: (json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      location: location,
      isActive: (json['isActive'] as bool?) ?? true,
    );
  }

  factory HospitalApiModel.fromFlexible(dynamic json) {
    if (json == null) return _empty();
    if (json is String) {
      return HospitalApiModel(
        id: json,
        name: '',
        location: const GeoPointApiModel(type: 'Point', coordinates: [0, 0]),
        isActive: true,
      );
    }
    if (json is Map<String, dynamic>) return HospitalApiModel.fromJson(json);
    if (json is Map) {
      return HospitalApiModel.fromJson(json.cast<String, dynamic>());
    }
    return _empty();
  }

  static HospitalApiModel _empty() {
    return const HospitalApiModel(
      id: '',
      name: '',
      location: GeoPointApiModel(type: 'Point', coordinates: [0, 0]),
      isActive: true,
    );
  }

  Map<String, dynamic> toJson() => _$HospitalApiModelToJson(this);

  factory HospitalApiModel.fromEntity(HospitalEntity entity) {
    return HospitalApiModel(
      id: entity.id,
      name: entity.name,
      location: GeoPointApiModel.fromEntity(entity.location),
      isActive: entity.isActive,
    );
  }

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
