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
  return value as String?;
}

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

  @JsonKey(fromJson: _extractRequiredId)
  final String recipientBloodId;
  final String recipientDetails;
  final String recipientCondition;
  @JsonKey(fromJson: _extractRequiredId)
  final String hospitalId;

  @JsonKey(fromJson: _extractOptionalId)
  final String? postedBy;

  final String requestFor;

  @JsonKey(includeIfNull: false)
  final String? relationToPatient;
  @JsonKey(includeIfNull: false)
  final String? patientName;
  @JsonKey(includeIfNull: false)
  final String? patientPhone;

  @JsonKey(fromJson: _extractOptionalId)
  final String? donorId;

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
    this.requestFor = "self",
    this.relationToPatient,
    this.patientName,
    this.patientPhone,
    this.donorId,
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
    recipientDetails: recipientDetails,
    recipientCondition: _conditionFromString(recipientCondition),
    hospitalId: hospitalId,
    postedBy: postedBy,
    requestFor: _requestForFromString(requestFor),
    relationToPatient: relationToPatient,
    patientName: patientName,
    patientPhone: patientPhone,
    donorId: donorId,
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

    donorId: entity.donorId,
    requestStatus: entity.requestStatus,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );

  static List<RequestEntity> toEntityList(List<RequestApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
