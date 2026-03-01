import 'package:blood_link/features/bloodGroup/data/models/blood_api_model.dart';
import 'package:blood_link/features/hospital/data/model/hospital_api_model.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/user/data/models/user_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_api_model.g.dart';

BloodApiModel? _bloodFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) return BloodApiModel(bloodId: value, bloodGroup: '');
  if (value is Map<String, dynamic>) return BloodApiModel.fromJson(value);
  if (value is Map) {
    return BloodApiModel.fromJson(value.cast<String, dynamic>());
  }
  return null;
}

HospitalApiModel? _hospitalFromJson(dynamic value) {
  if (value == null) return null;
  return HospitalApiModel.fromFlexible(value);
}

UserApiModel? _userFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    return UserApiModel(
      userId: value,
      fullName: '',
      phoneNumber: '',
      email: '',
    );
  }
  if (value is Map<String, dynamic>) return UserApiModel.fromJson(value);
  if (value is Map) return UserApiModel.fromJson(value.cast<String, dynamic>());
  return null;
}

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class RequestApiModel {
  @JsonKey(name: "_id")
  final String? requestId;

  @JsonKey(fromJson: _bloodFromJson)
  final BloodApiModel? recipientBloodId;
  @JsonKey(fromJson: _hospitalFromJson)
  final HospitalApiModel? hospitalId;
  @JsonKey(fromJson: _userFromJson)
  final UserApiModel? postedBy;
  @JsonKey(fromJson: _userFromJson)
  final UserApiModel? donorId;

  final String recipientDetails;
  final String recipientCondition;

  final String requestFor;
  final String? relationToPatient;
  final String? patientName;
  final String? patientPhone;

  final String? requestStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RequestApiModel({
    this.requestId,
    required this.recipientBloodId,
    required this.hospitalId,
    this.postedBy,
    this.donorId,
    required this.recipientDetails,
    required this.recipientCondition,
    required this.requestFor,
    this.relationToPatient,
    this.patientName,
    this.patientPhone,
    this.requestStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory RequestApiModel.fromJson(Map<String, dynamic> json) =>
      _$RequestApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestApiModelToJson(this);

  RequestEntity toEntity() {
    final cond = ConditionType.values.firstWhere(
      (e) => e.name == recipientCondition.trim().toLowerCase(),
      orElse: () => ConditionType.urgent,
    );

    final rf = RequestForType.values.firstWhere(
      (e) => e.name == requestFor.trim().toLowerCase(),
      orElse: () => RequestForType.self,
    );

    return RequestEntity(
      requestId: requestId,

      recipientBloodId: recipientBloodId?.bloodId ?? "",
      hospitalId: hospitalId?.id ?? "",

      recipientBlood: recipientBloodId?.toEntity(),
      hospital: hospitalId?.toEntity(),

      postedBy: postedBy?.userId,
      receiver: postedBy?.toEntity(),
      donorId: donorId?.userId,
      donor: donorId?.toEntity(),

      recipientDetails: recipientDetails,
      recipientCondition: cond,

      requestFor: rf,
      relationToPatient: relationToPatient,
      patientName: patientName,
      patientPhone: patientPhone,

      requestStatus: requestStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory RequestApiModel.fromEntity(RequestEntity entity) {
    return RequestApiModel(
      requestId: entity.requestId,

      recipientBloodId: entity.recipientBlood != null
          ? BloodApiModel.fromEntity(entity.recipientBlood!)
          : null,
      hospitalId: entity.hospital != null
          ? HospitalApiModel.fromEntity(entity.hospital!)
          : null,

      postedBy: entity.receiver == null
          ? null
          : UserApiModel.fromEntity(entity.receiver!),
      donorId: entity.donor == null
          ? null
          : UserApiModel.fromEntity(entity.donor!),

      recipientDetails: entity.recipientDetails,
      recipientCondition: entity.recipientCondition.name,
      requestFor: entity.requestFor.name,

      relationToPatient: entity.requestFor == RequestForType.others
          ? entity.relationToPatient
          : null,
      patientName: entity.requestFor == RequestForType.others
          ? entity.patientName
          : null,
      patientPhone: entity.requestFor == RequestForType.others
          ? entity.patientPhone
          : null,

      requestStatus: entity.requestStatus,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<RequestEntity> toEntityList(List<RequestApiModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }
}
