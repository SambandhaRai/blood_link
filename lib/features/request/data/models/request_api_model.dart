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
  final String? recipientId;

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
    this.recipientId,
    this.donorId,
    this.requestStatus,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$RequestApiModelToJson(this);

  factory RequestApiModel.fromJson(Map<String, dynamic> json) =>
      _$RequestApiModelFromJson(json);

  ConditionType _conditionFromString(String value) {
    final normalized = value.trim().toLowerCase();
    return ConditionType.values.firstWhere((e) => e.name == normalized);
  }

  RequestEntity toEntity() => RequestEntity(
    requestId: requestId,
    recipientBloodId: recipientBloodId,
    recipientDetails: recipientDetails,
    recipientCondition: _conditionFromString(recipientCondition),
    hospitalId: hospitalId,
    recipientId: recipientId,
    donorId: donorId,
    requestStatus: requestStatus,
  );

  factory RequestApiModel.fromEntity(RequestEntity entity) => RequestApiModel(
    requestId: entity.requestId,
    recipientBloodId: entity.recipientBloodId,
    recipientDetails: entity.recipientDetails,
    recipientCondition: entity.recipientCondition.name,
    hospitalId: entity.hospitalId,
    recipientId: entity.recipientId,
    donorId: entity.donorId,
    requestStatus: entity.requestStatus,
  );

  // toEntityList
  static List<RequestEntity> toEntityList(List<RequestApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
