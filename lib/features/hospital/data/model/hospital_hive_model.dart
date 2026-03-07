import 'package:blood_link/core/constants/hive_table_constant.dart';
import 'package:blood_link/features/geo_point/domain/entities/geo_point_entity.dart';
import 'package:blood_link/features/hospital/data/model/hospital_api_model.dart';
import 'package:blood_link/features/hospital/domain/entities/hospital_entity.dart';
import 'package:hive/hive.dart';

part 'hospital_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.hospitalTypeId)
class HospitalHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double latitude;

  @HiveField(3)
  final double longitude;

  @HiveField(4)
  final bool isActive;

  HospitalHiveModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.isActive,
  });

  factory HospitalHiveModel.fromApiModel(HospitalApiModel apiModel) {
    final loc = apiModel.location.toEntity();
    return HospitalHiveModel(
      id: apiModel.id,
      name: apiModel.name,
      latitude: loc.latitude,
      longitude: loc.longitude,
      isActive: apiModel.isActive,
    );
  }

  static List<HospitalHiveModel> fromApiModelList(
    List<HospitalApiModel> apiModels,
  ) {
    return apiModels.map(HospitalHiveModel.fromApiModel).toList();
  }

  HospitalEntity toEntity() {
    return HospitalEntity(
      id: id,
      name: name,
      location: GeoPoint(latitude: latitude, longitude: longitude),
      isActive: isActive,
    );
  }

  static List<HospitalEntity> toEntityList(List<HospitalHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
