import 'package:blood_link/core/constants/hive_table_constant.dart';
import 'package:blood_link/features/request/data/models/request_api_model.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'request_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.requestTypeId)
class RequestHiveModel extends HiveObject {
  static const String cacheTypePending = 'pending';
  static const String cacheTypeDonated = 'history_donated';
  static const String cacheTypeRequestedOngoing = 'history_requested_ongoing';
  static const String cacheTypeDonationOngoing = 'history_donation_ongoing';
  static const String cacheTypeReceived = 'history_received';

  @HiveField(0)
  final String? requestId;

  @HiveField(1)
  final String recipientBloodId;

  @HiveField(2)
  final String hospitalId;

  @HiveField(3)
  final String? postedBy;

  @HiveField(4)
  final String? donorId;

  @HiveField(5)
  final String recipientDetails;

  @HiveField(6)
  final String recipientCondition;

  @HiveField(7)
  final String requestFor;

  @HiveField(8)
  final String? relationToPatient;

  @HiveField(9)
  final String? patientName;

  @HiveField(10)
  final String? patientPhone;

  @HiveField(11)
  final String? requestStatus;

  @HiveField(12)
  final DateTime? createdAt;

  @HiveField(13)
  final DateTime? updatedAt;

  @HiveField(14)
  final String cacheType;

  RequestHiveModel({
    String? requestId,
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
    this.cacheType = cacheTypePending,
  }) : requestId = requestId ?? const Uuid().v4();

  factory RequestHiveModel.fromEntity(
    RequestEntity entity, {
    String cacheType = cacheTypePending,
  }) {
    return RequestHiveModel(
      requestId: entity.requestId,
      recipientBloodId: entity.recipientBloodId,
      hospitalId: entity.hospitalId,
      postedBy: entity.postedBy,
      donorId: entity.donorId,
      recipientDetails: entity.recipientDetails,
      recipientCondition: entity.recipientCondition.name,
      requestFor: entity.requestFor.name,
      relationToPatient: entity.relationToPatient,
      patientName: entity.patientName,
      patientPhone: entity.patientPhone,
      requestStatus: entity.requestStatus,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      cacheType: cacheType,
    );
  }

  static List<RequestHiveModel> fromEntityList(
    List<RequestEntity> entities, {
    String cacheType = cacheTypePending,
  }) {
    return entities
        .map((entity) => RequestHiveModel.fromEntity(entity, cacheType: cacheType))
        .toList();
  }

  factory RequestHiveModel.fromApiModel(
    RequestApiModel apiModel, {
    String cacheType = cacheTypePending,
  }) {
    return RequestHiveModel(
      requestId: apiModel.requestId,
      recipientBloodId: apiModel.recipientBloodId?.bloodId ?? '',
      hospitalId: apiModel.hospitalId?.id ?? '',
      postedBy: apiModel.postedBy?.userId,
      donorId: apiModel.donorId?.userId,
      recipientDetails: apiModel.recipientDetails,
      recipientCondition: apiModel.recipientCondition,
      requestFor: apiModel.requestFor,
      relationToPatient: apiModel.relationToPatient,
      patientName: apiModel.patientName,
      patientPhone: apiModel.patientPhone,
      requestStatus: apiModel.requestStatus,
      createdAt: apiModel.createdAt,
      updatedAt: apiModel.updatedAt,
      cacheType: cacheType,
    );
  }

  static List<RequestHiveModel> fromApiModelList(
    List<RequestApiModel> apiModels, {
    String cacheType = cacheTypePending,
  }) {
    return apiModels
        .map((model) => RequestHiveModel.fromApiModel(model, cacheType: cacheType))
        .toList();
  }

  RequestEntity toEntity() {
    final cond = ConditionType.values.firstWhere(
      (e) => e.name == recipientCondition.trim().toLowerCase(),
      orElse: () => ConditionType.urgent,
    );
    final reqFor = RequestForType.values.firstWhere(
      (e) => e.name == requestFor.trim().toLowerCase(),
      orElse: () => RequestForType.self,
    );

    return RequestEntity(
      requestId: requestId,
      recipientBloodId: recipientBloodId,
      recipientBlood: null,
      hospitalId: hospitalId,
      hospital: null,
      postedBy: postedBy,
      receiver: null,
      donorId: donorId,
      donor: null,
      recipientDetails: recipientDetails,
      recipientCondition: cond,
      requestFor: reqFor,
      relationToPatient: relationToPatient,
      patientName: patientName,
      patientPhone: patientPhone,
      requestStatus: requestStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static List<RequestEntity> toEntityList(List<RequestHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  RequestHiveModel copyWith({String? cacheType}) {
    return RequestHiveModel(
      requestId: requestId,
      recipientBloodId: recipientBloodId,
      hospitalId: hospitalId,
      postedBy: postedBy,
      donorId: donorId,
      recipientDetails: recipientDetails,
      recipientCondition: recipientCondition,
      requestFor: requestFor,
      relationToPatient: relationToPatient,
      patientName: patientName,
      patientPhone: patientPhone,
      requestStatus: requestStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
      cacheType: cacheType ?? this.cacheType,
    );
  }
}
