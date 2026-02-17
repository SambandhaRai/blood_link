import 'package:blood_link/features/hospital/domain/entities/hospital_entity.dart';
import 'package:equatable/equatable.dart';

enum HospitalStatus { initial, loading, loaded, error }

class HospitalState extends Equatable {
  final HospitalStatus status;
  final List<HospitalEntity> hospitals;
  final HospitalEntity? selectedHospital;
  final String? errorMessage;

  const HospitalState({
    this.status = HospitalStatus.initial,
    this.hospitals = const [],
    this.selectedHospital,
    this.errorMessage,
  });

  HospitalState copyWith({
    HospitalStatus? status,
    List<HospitalEntity>? hospitals,
    HospitalEntity? selectedHospital,
    String? errorMessage,
  }) {
    return HospitalState(
      status: status ?? this.status,
      hospitals: hospitals ?? this.hospitals,
      selectedHospital: selectedHospital ?? this.selectedHospital,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    hospitals,
    selectedHospital,
    errorMessage,
  ];
}
