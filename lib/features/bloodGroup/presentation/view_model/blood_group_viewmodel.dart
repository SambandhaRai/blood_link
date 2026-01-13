import 'package:blood_link/features/bloodGroup/domain/usecases/create_blood_group_usecase.dart';
import 'package:blood_link/features/bloodGroup/domain/usecases/get_all_blood_group_usecase.dart';
import 'package:blood_link/features/bloodGroup/domain/usecases/get_blood_group_byid_usecase.dart';
import 'package:blood_link/features/bloodGroup/presentation/state/blood_group_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bloodGroupViewModelProvider =
    NotifierProvider<BloodGroupViewmodel, BloodGroupState>(
      BloodGroupViewmodel.new,
    );

class BloodGroupViewmodel extends Notifier<BloodGroupState> {
  late final GetAllBloodGroupUsecase _getAllBloodGroupUsecase;
  late final CreateBloodGroupUsecase _createBloodGroupUsecase;
  late final GetBloodGroupByIdUsecase _getBloodGroupByIdUsecase;

  @override
  BloodGroupState build() {
    _getAllBloodGroupUsecase = ref.read(getAllBloodGroupUsecaseProvider);
    _createBloodGroupUsecase = ref.read(createBloodGroupUsecaseProvider);
    _getBloodGroupByIdUsecase = ref.read(getBloodGroupByIdUsecaseProvider);
    return const BloodGroupState();
  }

  Future<void> getAllBloodGroups() async {
    state = state.copyWith(status: BloodGroupStatus.loading);

    final result = await _getAllBloodGroupUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: BloodGroupStatus.error,
        errorMessage: failure.message,
      ),
      (bloodGroups) => state = state.copyWith(
        status: BloodGroupStatus.loaded,
        bloodGroups: bloodGroups,
      ),
    );
  }

  Future<void> getBloodGroupById(String bloodId) async {
    state = state.copyWith(status: BloodGroupStatus.loading);

    final result = await _getBloodGroupByIdUsecase(
      GetBloodGroupByIdParams(bloodId: bloodId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: BloodGroupStatus.error,
        errorMessage: failure.message,
      ),
      (bloodGroup) => state = state.copyWith(
        status: BloodGroupStatus.loaded,
        selectedBloodGroup: bloodGroup,
      ),
    );
  }

  Future<void> createBloodGroup(String bloodGroup) async {
    state = state.copyWith(status: BloodGroupStatus.loading);

    final result = await _createBloodGroupUsecase(
      CreateBloodGroupParams(bloodGroup: bloodGroup),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: BloodGroupStatus.error,
        errorMessage: failure.message,
      ),
      (sucess) {
        state = state.copyWith(status: BloodGroupStatus.created);
        getAllBloodGroups();
      },
    );
  }
}
