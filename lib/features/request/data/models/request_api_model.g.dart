// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestApiModel _$RequestApiModelFromJson(Map<String, dynamic> json) =>
    RequestApiModel(
      requestId: json['_id'] as String?,
      recipientBloodId: _extractRequiredId(json['recipientBloodId']),
      recipientDetails: json['recipientDetails'] as String,
      recipientCondition: json['recipientCondition'] as String,
      hospitalId: _extractRequiredId(json['hospitalId']),
      recipientId: _extractOptionalId(json['recipientId']),
      donorId: _extractOptionalId(json['donorId']),
      requestStatus: json['requestStatus'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RequestApiModelToJson(RequestApiModel instance) =>
    <String, dynamic>{
      '_id': instance.requestId,
      'recipientBloodId': instance.recipientBloodId,
      'recipientDetails': instance.recipientDetails,
      'recipientCondition': instance.recipientCondition,
      'hospitalId': instance.hospitalId,
      'recipientId': instance.recipientId,
      'donorId': instance.donorId,
      'requestStatus': instance.requestStatus,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
