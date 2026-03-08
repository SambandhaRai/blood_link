import 'package:blood_link/features/hospital/data/model/hospital_api_model.dart';
import 'package:blood_link/features/hospital/data/model/hospital_hive_model.dart';

abstract interface class IHospitalLocalDatasource {
  Future<List<HospitalHiveModel>> getAllHospitals();
  Future<HospitalHiveModel?> getHospitalById(String hospitalId);
  Future<void> cacheAllHospitals(List<HospitalHiveModel> hospitals);
}

abstract interface class IRemoteHospitalDatasource {
  Future<List<HospitalApiModel>> getAllHospitals();
  Future<HospitalApiModel?> getHospitalById(String hospitalId);
}
