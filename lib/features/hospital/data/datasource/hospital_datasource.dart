import 'package:blood_link/features/hospital/data/model/hospital_api_model.dart';

abstract interface class IRemoteHospitalDatasource {
  Future<List<HospitalApiModel>> getAllHospitals();
  Future<HospitalApiModel?> getHospitalById(String hospitalId);
}
