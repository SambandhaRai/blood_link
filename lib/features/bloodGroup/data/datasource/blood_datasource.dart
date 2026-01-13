import 'package:blood_link/features/bloodGroup/data/models/blood_hive_model.dart';

abstract interface class IBloodDatasource {
  Future<List<BloodHiveModel>> getAllBloodGroup();
  Future<BloodHiveModel> getBloodById(String bloodId);
  Future<bool> createBloodGroup(BloodHiveModel blood);
}
