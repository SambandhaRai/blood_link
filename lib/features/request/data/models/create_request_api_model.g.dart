// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_request_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateRequestApiModel _$CreateRequestApiModelFromJson(
  Map<String, dynamic> json,
) => CreateRequestApiModel(
  recipientBloodId: json['recipientBloodId'] as String,
  hospitalId: json['hospitalId'] as String,
  recipientDetails: json['recipientDetails'] as String,
  recipientCondition: json['recipientCondition'] as String,
  requestFor: json['requestFor'] as String,
  relationToPatient: json['relationToPatient'] as String?,
  patientName: json['patientName'] as String?,
  patientPhone: json['patientPhone'] as String?,
);

Map<String, dynamic> _$CreateRequestApiModelToJson(
  CreateRequestApiModel instance,
) {
  final val = <String, dynamic>{
    'recipientBloodId': instance.recipientBloodId,
    'hospitalId': instance.hospitalId,
    'recipientDetails': instance.recipientDetails,
    'recipientCondition': instance.recipientCondition,
    'requestFor': instance.requestFor,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('relationToPatient', instance.relationToPatient);
  writeNotNull('patientName', instance.patientName);
  writeNotNull('patientPhone', instance.patientPhone);
  return val;
}
