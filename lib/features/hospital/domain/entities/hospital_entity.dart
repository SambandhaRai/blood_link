import 'package:equatable/equatable.dart';
import '../../../geo_point/domain/entities/geo_point_entity.dart';

class HospitalEntity extends Equatable {
  final String id;
  final String name;
  final GeoPoint location;
  final bool isActive;

  const HospitalEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.isActive,
  });

  @override
  List<Object> get props => [id, name, location, isActive];
}
