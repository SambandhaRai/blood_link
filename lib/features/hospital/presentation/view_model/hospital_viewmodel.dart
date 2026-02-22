import 'package:blood_link/features/hospital/domain/usecases/get_all_hospitals_usecase.dart';
import 'package:blood_link/features/hospital/domain/usecases/get_hospital_by_id_usecase.dart';
import 'package:blood_link/features/hospital/presentation/state/hospital_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hospitalViewModelProvider =
    NotifierProvider<HospitalViewmodel, HospitalState>(HospitalViewmodel.new);

class HospitalViewmodel extends Notifier<HospitalState> {
  late final GetAllHospitalsUsecase _getAllHospitalsUsecase;
  late final GetHospitalByIdUsecase _getHospitalByIdUsecase;

  @override
  HospitalState build() {
    _getAllHospitalsUsecase = ref.read(getAllHospitalsUsecaseProvider);
    _getHospitalByIdUsecase = ref.read(getHospitalByIdUsecaseProvider);

    return HospitalState();
  }

  Future<void> getAllHospitals() async {
    state = state.copyWith(status: HospitalStatus.loading);

    final result = await _getAllHospitalsUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: HospitalStatus.error,
        errorMessage: failure.message,
      ),
      (hospitals) => state = state.copyWith(
        status: HospitalStatus.loaded,
        hospitals: hospitals,
      ),
    );
  }

  Future<void> getHospitalById(String hospitalId) async {
    state = state.copyWith(status: HospitalStatus.loading);

    final result = await _getHospitalByIdUsecase(
      GetHospitalByIdParams(hospitalId: hospitalId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: HospitalStatus.error,
        errorMessage: failure.message,
      ),
      (hospital) => state = state.copyWith(
        status: HospitalStatus.loaded,
        selectedHospital: hospital,
      ),
    );
  }
}
