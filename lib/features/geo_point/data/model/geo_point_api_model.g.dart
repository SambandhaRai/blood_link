// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_point_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoPointApiModel _$GeoPointApiModelFromJson(Map<String, dynamic> json) =>
    GeoPointApiModel(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$GeoPointApiModelToJson(GeoPointApiModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
