// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HospitalApiModel _$HospitalApiModelFromJson(Map<String, dynamic> json) =>
    HospitalApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      location:
          GeoPointApiModel.fromJson(json['location'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$HospitalApiModelToJson(HospitalApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'isActive': instance.isActive,
    };
