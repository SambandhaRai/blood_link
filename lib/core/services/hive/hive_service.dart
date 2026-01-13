import 'package:blood_link/core/constants/hive_table_constant.dart';
import 'package:blood_link/features/auth/data/models/auth_hive_model.dart';
import 'package:blood_link/features/bloodGroup/data/models/blood_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // init
  Future<void> init() async {
    // find path
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapter();
    await _openBoxes();
    await insertDummyBloodGroup();
  }

  // Register Adapter
  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.bloodTypeId)) {
      Hive.registerAdapter(BloodHiveModelAdapter());
    }
  }

  // Insert Dummy Blood Group
  Future<void> insertDummyBloodGroup() async {
    final bloodBox = Hive.box<BloodHiveModel>(HiveTableConstant.bloodTable);

    if (bloodBox.isNotEmpty) {
      return;
    }

    final dummyBloodGroup = [
      BloodHiveModel(bloodGroup: 'A+'),
      BloodHiveModel(bloodGroup: 'A-'),
      BloodHiveModel(bloodGroup: 'B+'),
      BloodHiveModel(bloodGroup: 'B-'),
      BloodHiveModel(bloodGroup: 'AB+'),
      BloodHiveModel(bloodGroup: 'AB-'),
      BloodHiveModel(bloodGroup: 'O+'),
      BloodHiveModel(bloodGroup: 'O-'),
    ];

    for (var blood in dummyBloodGroup) {
      await bloodBox.put(blood.bloodId, blood);
    }
  }

  // Open Boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.userTable);
    await Hive.openBox<BloodHiveModel>(HiveTableConstant.bloodTable);
  }

  // Close Boxes
  Future<void> close() async {
    await Hive.close();
  }

  // ====================== Auth Queries ======================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.userTable);

  // Register
  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.userId, model);
    return model;
  }

  // Login
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  // Logout
  Future<void> logoutUser() async {}

  // Get Current User
  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  // isEmailExists
  bool isEmailExists(String email) {
    final users = _authBox.values.where((user) => user.email == email);
    return users.isNotEmpty;
  }

  // ====================== Blood Group Queries ======================
  Box<BloodHiveModel> get _bloodBox =>
      Hive.box<BloodHiveModel>(HiveTableConstant.bloodTable);

  // Create Blood Group
  Future<BloodHiveModel> createBloodGroup(BloodHiveModel blood) async {
    await _bloodBox.put(blood.bloodId, blood);
    return blood;
  }

  // Get All Blood Group
  List<BloodHiveModel> getAllBloodGroup() {
    return _bloodBox.values.toList();
  }

  BloodHiveModel? getBloodGroupById(String? bloodId) {
    return _bloodBox.get(bloodId);
  }
}
