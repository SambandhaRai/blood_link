import 'package:blood_link/core/services/hive/hive_service.dart';
import 'package:blood_link/features/bloodGroup/data/datasource/blood_datasource.dart';
import 'package:blood_link/features/bloodGroup/data/models/blood_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bloodLocalDatasourceProvider = Provider<BloodLocalDatasource>((ref) {
  return BloodLocalDatasource(hiveService: ref.read(hiveServiceProvider));
});

class BloodLocalDatasource implements IBloodLocalDatasource {
  final HiveService _hiveService;

  BloodLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> createBloodGroup(BloodHiveModel blood) async {
    try {
      await _hiveService.createBloodGroup(blood);
      return true;
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<List<BloodHiveModel>> getAllBloodGroup() async {
    try {
      return _hiveService.getAllBloodGroup();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<BloodHiveModel> getBloodById(String bloodId) {
    throw UnimplementedError();
  }
}
