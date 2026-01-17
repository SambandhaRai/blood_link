import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:equatable/equatable.dart';

enum BloodGroupStatus { initial, loading, loaded, error, created }

class BloodGroupState extends Equatable {
  final BloodGroupStatus status;
  final List<BloodEntity> bloodGroups;
  final BloodEntity? selectedBloodGroup;
  final String? errorMessage;

  const BloodGroupState({
    this.status = BloodGroupStatus.initial,
    this.bloodGroups = const [],
    this.selectedBloodGroup,
    this.errorMessage,
  });

  BloodGroupState copyWith({
    BloodGroupStatus? status,
    List<BloodEntity>? bloodGroups,
    BloodEntity? selectedBloodGroup,
    String? errorMessage,
  }) {
    return BloodGroupState(
      status: status ?? this.status,
      bloodGroups: bloodGroups ?? this.bloodGroups,
      selectedBloodGroup: selectedBloodGroup ?? this.selectedBloodGroup,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    bloodGroups,
    selectedBloodGroup,
    errorMessage,
  ];
}
