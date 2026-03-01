import 'package:blood_link/features/request/domain/entities/create_request_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_request_api_model.g.dart';

@JsonSerializable(includeIfNull: false)
class CreateRequestApiModel {
  final String recipientBloodId;
  final String hospitalId;

  final String recipientDetails;
  final String recipientCondition;
  final String requestFor;

  final String? relationToPatient;
  final String? patientName;
  final String? patientPhone;

  const CreateRequestApiModel({
    required this.recipientBloodId,
    required this.hospitalId,
    required this.recipientDetails,
    required this.recipientCondition,
    required this.requestFor,
    this.relationToPatient,
    this.patientName,
    this.patientPhone,
  });

  factory CreateRequestApiModel.fromJson(Map<String, dynamic> json) =>
      _$CreateRequestApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateRequestApiModelToJson(this);

  factory CreateRequestApiModel.fromEntity(CreateRequestEntity entity) {
    final isOthers = entity.requestFor == RequestForType.others;

    return CreateRequestApiModel(
      recipientBloodId: entity.recipientBloodId,
      hospitalId: entity.hospitalId,
      recipientDetails: entity.recipientDetails,
      recipientCondition: entity.recipientCondition.name,
      requestFor: entity.requestFor.name,
      relationToPatient: isOthers ? entity.relationToPatient : null,
      patientName: isOthers ? entity.patientName : null,
      patientPhone: isOthers ? entity.patientPhone : null,
    );
  }

  CreateRequestEntity toEntity() {
    final cond = ConditionType.values.firstWhere(
      (e) => e.name == recipientCondition.trim().toLowerCase(),
      orElse: () => ConditionType.urgent,
    );

    final rf = RequestForType.values.firstWhere(
      (e) => e.name == requestFor.trim().toLowerCase(),
      orElse: () => RequestForType.self,
    );

    return CreateRequestEntity(
      recipientBloodId: recipientBloodId,
      hospitalId: hospitalId,
      recipientDetails: recipientDetails,
      recipientCondition: cond,
      requestFor: rf,
      relationToPatient: rf == RequestForType.others ? relationToPatient : null,
      patientName: rf == RequestForType.others ? patientName : null,
      patientPhone: rf == RequestForType.others ? patientPhone : null,
    );
  }
}
