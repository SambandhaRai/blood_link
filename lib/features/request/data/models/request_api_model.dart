import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_api_model.g.dart';

String _extractRequiredId(dynamic value) {
  if (value == null) {
    throw const FormatException("Expected an id but got null");
  }
  if (value is Map) {
    final id = value["_id"];
    if (id is String && id.isNotEmpty) return id;
    throw const FormatException("Expected an object with _id");
  }
  if (value is String && value.isNotEmpty) return value;

  throw const FormatException("Expected id as String or {_id: String}");
}

String? _extractOptionalId(dynamic value) {
  if (value == null) return null;
  if (value is Map) return value["_id"] as String?;
  if (value is String) return value;
  return null;
}

Object? _readRecipientBlood(Map json, String _) => json['recipientBloodId'];
Object? _readHospital(Map json, String _) => json['hospitalId'];
Object? _readPostedBy(Map json, String _) => json['postedBy'];

String? _bloodGroupFromRecipient(dynamic v) =>
    (v is Map) ? v['bloodGroup'] as String? : null;

String? _hospitalNameFromHospital(dynamic v) =>
    (v is Map) ? v['name'] as String? : null;

String? _postedByNameFromPostedBy(dynamic v) =>
    (v is Map) ? v['fullName'] as String? : null;

String? _postedByProfileFromPostedBy(dynamic v) =>
    (v is Map) ? v['profilePicture'] as String? : null;

RequestForType _requestForFromString(String value) {
  final normalized = value.trim().toLowerCase();
  return RequestForType.values.firstWhere(
    (e) => e.name == normalized,
    orElse: () => RequestForType.self,
  );
}

ConditionType _conditionFromString(String value) {
  final normalized = value.trim().toLowerCase();
  return ConditionType.values.firstWhere(
    (e) => e.name == normalized,
    orElse: () => ConditionType.urgent,
  );
}

@JsonSerializable()
class RequestApiModel {
  @JsonKey(name: "_id")
  final String? requestId;

  @JsonKey(name: "recipientBloodId", fromJson: _extractRequiredId)
  final String recipientBloodId;

  @JsonKey(name: "hospitalId", fromJson: _extractRequiredId)
  final String hospitalId;

  @JsonKey(name: "postedBy", fromJson: _extractOptionalId)
  final String? postedBy;

  @JsonKey(name: "donorId", fromJson: _extractOptionalId)
  final String? donorId;

  @JsonKey(readValue: _readRecipientBlood, fromJson: _bloodGroupFromRecipient)
  final String? bloodGroup;

  @JsonKey(readValue: _readHospital, fromJson: _hospitalNameFromHospital)
  final String? hospitalName;

  @JsonKey(readValue: _readPostedBy, fromJson: _postedByNameFromPostedBy)
  final String? postedByName;

  @JsonKey(readValue: _readPostedBy, fromJson: _postedByProfileFromPostedBy)
  final String? postedByProfilePicture;

  final String recipientDetails;
  final String recipientCondition;

  final String requestFor;

  @JsonKey(includeIfNull: false)
  final String? relationToPatient;

  @JsonKey(includeIfNull: false)
  final String? patientName;

  @JsonKey(includeIfNull: false)
  final String? patientPhone;

  final String? requestStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RequestApiModel({
    this.requestId,
    required this.recipientBloodId,
    required this.recipientDetails,
    required this.recipientCondition,
    required this.hospitalId,
    this.postedBy,
    this.donorId,

    this.bloodGroup,
    this.hospitalName,
    this.postedByName,
    this.postedByProfilePicture,

    this.requestFor = "self",
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

  RequestEntity toEntity() => RequestEntity(
    requestId: requestId,
    recipientBloodId: recipientBloodId,
    hospitalId: hospitalId,
    postedBy: postedBy,
    donorId: donorId,

    bloodGroup: bloodGroup,
    hospitalName: hospitalName,
    postedByName: postedByName,
    postedByProfilePicture: postedByProfilePicture,

    recipientDetails: recipientDetails,
    recipientCondition: _conditionFromString(recipientCondition),

    requestFor: _requestForFromString(requestFor),
    relationToPatient: relationToPatient,
    patientName: patientName,
    patientPhone: patientPhone,

    requestStatus: requestStatus,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory RequestApiModel.fromEntity(RequestEntity entity) => RequestApiModel(
    requestId: entity.requestId,
    recipientBloodId: entity.recipientBloodId,
    recipientDetails: entity.recipientDetails,
    recipientCondition: entity.recipientCondition.name,
    hospitalId: entity.hospitalId,
    postedBy: entity.postedBy,
    donorId: entity.donorId,

    bloodGroup: entity.bloodGroup,
    hospitalName: entity.hospitalName,
    postedByName: entity.postedByName,
    postedByProfilePicture: entity.postedByProfilePicture,

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

  static List<RequestEntity> toEntityList(List<RequestApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
