// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
  userId: json['_id'] as String?,
  fullName: json['fullName'] as String,
  phoneNumber: json['phoneNumber'] as String,
  email: json['email'] as String,
  profilePicture: json['profilePicture'] as String?,
  bloodId: _bloodFromJson(json['bloodId']),
  location: _locationFromJson(json['location']),
  gender: json['gender'] as String?,
  dob: json['dob'] as String?,
  healthCondition: json['healthCondition'] as String?,
  activeAcceptedRequestId: json['activeAcceptedRequestId'],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

String? _toIsoDob(String? value) {
  if (value == null || value.trim().isEmpty) return value;
  final parts = value.split('/');
  if (parts.length == 3) {
    final yyyy = parts[2].padLeft(4, '0');
    final mm = parts[1].padLeft(2, '0');
    final dd = parts[0].padLeft(2, '0');
    return '$yyyy-$mm-$dd';
  }
  // fallback: return the trimmed string as‑is
  return value.trim();
}

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'profilePicture': instance.profilePicture,
      'bloodId': instance.bloodId?.toJson(),
      'location': instance.location?.toJson(),
      'gender': instance.gender,
      'dob': _toIsoDob(instance.dob),
      'healthCondition': instance.healthCondition,
      'activeAcceptedRequestId': instance.activeAcceptedRequestId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
