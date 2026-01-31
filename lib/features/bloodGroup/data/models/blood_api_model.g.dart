// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BloodApiModel _$BloodApiModelFromJson(Map<String, dynamic> json) =>
    BloodApiModel(
      bloodId: json['_id'] as String?,
      bloodGroup: json['bloodGroup'] as String,
    );

Map<String, dynamic> _$BloodApiModelToJson(BloodApiModel instance) =>
    <String, dynamic>{
      '_id': instance.bloodId,
      'bloodGroup': instance.bloodGroup,
    };
