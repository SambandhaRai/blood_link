import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/geo_point_entity.dart';

part 'geo_point_api_model.g.dart';

@JsonSerializable()
class GeoPointApiModel {
  final String type;

  /// GeoJSON: [longitude, latitude]
  final List<double> coordinates;

  const GeoPointApiModel({required this.type, required this.coordinates});

  factory GeoPointApiModel.fromJson(Map<String, dynamic> json) =>
      _$GeoPointApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeoPointApiModelToJson(this);

  GeoPoint toEntity() {
    return GeoPoint(latitude: coordinates[1], longitude: coordinates[0]);
  }
}
