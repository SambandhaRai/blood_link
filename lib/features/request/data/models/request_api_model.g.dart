// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestApiModel _$RequestApiModelFromJson(
  Map<String, dynamic> json,
) => RequestApiModel(
  requestId: json['_id'] as String?,
  recipientBloodId: _extractRequiredId(json['recipientBloodId']),
  recipientDetails: json['recipientDetails'] as String,
  recipientCondition: json['recipientCondition'] as String,
  hospitalId: _extractRequiredId(json['hospitalId']),
  postedBy: _extractOptionalId(json['postedBy']),
  donorId: _extractOptionalId(json['donorId']),
  bloodGroup: _bloodGroupFromRecipient(_readRecipientBlood(json, 'bloodGroup')),
  hospitalName: _hospitalNameFromHospital(_readHospital(json, 'hospitalName')),
  postedByName: _postedByNameFromPostedBy(_readPostedBy(json, 'postedByName')),
  postedByProfilePicture: _postedByProfileFromPostedBy(
    _readPostedBy(json, 'postedByProfilePicture'),
  ),
  requestFor: json['requestFor'] as String? ?? "self",
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

Map<String, dynamic> _$RequestApiModelToJson(RequestApiModel instance) {
  final val = <String, dynamic>{
    '_id': instance.requestId,
    'recipientBloodId': instance.recipientBloodId,
    'hospitalId': instance.hospitalId,
    'postedBy': instance.postedBy,
    'donorId': instance.donorId,
    'bloodGroup': instance.bloodGroup,
    'hospitalName': instance.hospitalName,
    'postedByName': instance.postedByName,
    'postedByProfilePicture': instance.postedByProfilePicture,
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
  val['requestStatus'] = instance.requestStatus;
  val['createdAt'] = instance.createdAt?.toIso8601String();
  val['updatedAt'] = instance.updatedAt?.toIso8601String();
  return val;
}
