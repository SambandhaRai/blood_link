// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestApiModel _$RequestApiModelFromJson(Map<String, dynamic> json) =>
    RequestApiModel(
      requestId: json['_id'] as String?,
      recipientBloodId: _bloodFromJson(json['recipientBloodId']),
      hospitalId: _hospitalFromJson(json['hospitalId']),
      postedBy: _userFromJson(json['postedBy']),
      donorId: _userFromJson(json['donorId']),
      recipientDetails: json['recipientDetails'] as String,
      recipientCondition: json['recipientCondition'] as String,
      requestFor: json['requestFor'] as String,
      relationToPatient: json['relationToPatient'] as String?,
      patientName: json['patientName'] as String?,
      patientPhone: json['patientPhone'] as String?,
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
      'recipientBloodId': instance.recipientBloodId?.toJson(),
      'hospitalId': instance.hospitalId?.toJson(),
      'postedBy': instance.postedBy?.toJson(),
      'donorId': instance.donorId?.toJson(),
      'recipientDetails': instance.recipientDetails,
      'recipientCondition': instance.recipientCondition,
      'requestFor': instance.requestFor,
      'relationToPatient': instance.relationToPatient,
      'patientName': instance.patientName,
      'patientPhone': instance.patientPhone,
      'requestStatus': instance.requestStatus,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
