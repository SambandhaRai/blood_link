import 'package:blood_link/features/bloodGroup/data/models/blood_api_model.dart';
import 'package:blood_link/features/bloodGroup/data/models/blood_hive_model.dart';

abstract interface class IBloodLocalDatasource {
  Future<List<BloodHiveModel>> getAllBloodGroup();
  Future<BloodHiveModel> getBloodById(String bloodId);
  Future<bool> createBloodGroup(BloodHiveModel blood);
  Future<void> cacheAllBloodGroups(List<BloodHiveModel> bloodGroups);
}

abstract interface class IBloodRemoteDatasource {
  Future<List<BloodApiModel>> getAllBloodGroup();
  Future<BloodApiModel> getBloodById(String bloodId);
  Future<bool> createBloodGroup(BloodApiModel blood);
}
