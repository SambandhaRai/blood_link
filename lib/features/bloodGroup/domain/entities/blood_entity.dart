import 'package:equatable/equatable.dart';

class BloodEntity extends Equatable {
  final String? bloodId;
  final String bloodGroup;

  const BloodEntity({this.bloodId, required this.bloodGroup});

  @override
  List<Object?> get props => [bloodId, bloodGroup];
}
