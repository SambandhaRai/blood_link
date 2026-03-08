import 'package:blood_link/core/services/hive/hive_service.dart';
import 'package:blood_link/features/hospital/data/datasource/hospital_datasource.dart';
import 'package:blood_link/features/hospital/data/model/hospital_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hospitalLocalDatasourceProvider = Provider<HospitalLocalDatasource>((ref) {
  return HospitalLocalDatasource(hiveService: ref.read(hiveServiceProvider));
});

class HospitalLocalDatasource implements IHospitalLocalDatasource {
  final HiveService _hiveService;

  HospitalLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> cacheAllHospitals(List<HospitalHiveModel> hospitals) async {
    await _hiveService.cacheAllHospitals(hospitals);
  }

  @override
  Future<List<HospitalHiveModel>> getAllHospitals() async {
    try {
      return _hiveService.getAllHospitals();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<HospitalHiveModel?> getHospitalById(String hospitalId) async {
    try {
      return _hiveService.getHospitalById(hospitalId);
    } catch (e) {
      return null;
    }
  }
}
