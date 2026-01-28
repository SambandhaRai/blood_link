// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
  userId: json['_id'] as String?,
  fullName: json['fullName'] as String,
  phoneNumber: json['phoneNumber'] as String,
  dob: json['dob'] as String,
  gender: json['gender'] as String,
  bloodId: json['bloodId'] as String?,
  healthCondition: json['healthCondition'] as String?,
  email: json['email'] as String,
  password: json['password'] as String?,
  confirmPassword: json['confirmPassword'] as String?,
  profilePicture: json['profilePicture'] as String?,
);

String _toIsoDob(String value) {
  // If already ISO (YYYY-MM-DD), return as-is
  final iso = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  if (iso.hasMatch(value.trim())) return value.trim();

  // If it's "DD / MM / YYYY", convert to "YYYY-MM-DD"
  final parts = value.split('/').map((e) => e.trim()).toList();
  if (parts.length == 3) {
    final dd = parts[0].padLeft(2, '0');
    final mm = parts[1].padLeft(2, '0');
    final yyyy = parts[2];
    return "$yyyy-$mm-$dd";
  }

  // Fallback: send as-is
  return value.trim();
}

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'dob': _toIsoDob(instance.dob),
      'gender': instance.gender,
      'bloodId': instance.bloodId,
      'healthCondition': instance.healthCondition,
      'email': instance.email,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'profilePicture': instance.profilePicture,
    };
