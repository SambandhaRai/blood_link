import 'package:blood_link/core/constants/hive_table_constant.dart';
import 'package:blood_link/features/auth/data/models/auth_hive_model.dart';
import 'package:blood_link/features/bloodGroup/data/models/blood_hive_model.dart';
import 'package:blood_link/features/hospital/data/model/hospital_hive_model.dart';
import 'package:blood_link/features/request/data/models/request_hive_model.dart';
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
    if (!Hive.isAdapterRegistered(HiveTableConstant.hospitalTypeId)) {
      Hive.registerAdapter(HospitalHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.requestTypeId)) {
      Hive.registerAdapter(RequestHiveModelAdapter());
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
    await Hive.openBox<HospitalHiveModel>(HiveTableConstant.hospitalTable);
    await Hive.openBox<RequestHiveModel>(HiveTableConstant.requestTable);
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

  // Get User by Email
  AuthHiveModel? getUserByEmail(String email) {
    try {
      return _authBox.values.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  // Get User by Phone
  AuthHiveModel? getUserByPhoneNumber(String phoneNumber) {
    try {
      return _authBox.values.firstWhere(
        (user) => user.phoneNumber == phoneNumber,
      );
    } catch (e) {
      return null;
    }
  }

  // ====================== Blood Group Queries ======================
  Box<BloodHiveModel> get _bloodBox =>
      Hive.box<BloodHiveModel>(HiveTableConstant.bloodTable);

  // Create Blood Group
  Future<BloodHiveModel> createBloodGroup(BloodHiveModel blood) async {
    await _bloodBox.put(blood.bloodId, blood);
    return blood;
  }

  // Cache all blood groups (clear existing and replace with new data)
  Future<void> cacheAllBloodGroups(List<BloodHiveModel> bloodGroups) async {
    await _bloodBox.clear();
    for (final blood in bloodGroups) {
      await _bloodBox.put(blood.bloodId, blood);
    }
  }

  // Get All Blood Group
  List<BloodHiveModel> getAllBloodGroup() {
    return _bloodBox.values.toList();
  }

  BloodHiveModel? getBloodGroupById(String? bloodId) {
    return _bloodBox.get(bloodId);
  }

  // ====================== Hospital Queries ======================
  Box<HospitalHiveModel> get _hospitalBox =>
      Hive.box<HospitalHiveModel>(HiveTableConstant.hospitalTable);

  Future<void> cacheAllHospitals(List<HospitalHiveModel> hospitals) async {
    await _hospitalBox.clear();
    for (final hospital in hospitals) {
      await _hospitalBox.put(hospital.id, hospital);
    }
  }

  List<HospitalHiveModel> getAllHospitals() {
    return _hospitalBox.values.toList();
  }

  HospitalHiveModel? getHospitalById(String hospitalId) {
    return _hospitalBox.get(hospitalId);
  }

  // ====================== Request Queries ======================
  Box<RequestHiveModel> get _requestBox =>
      Hive.box<RequestHiveModel>(HiveTableConstant.requestTable);

  Future<void> cachePendingRequests(
    List<RequestHiveModel> requests, {
    int? amount,
  }) async {
    await _removeRequestsByCacheType(RequestHiveModel.cacheTypePending);
    final itemsToCache = (amount != null && amount > 0)
        ? requests.take(amount)
        : requests;
    for (final request in itemsToCache) {
      final model = request.copyWith(
        cacheType: RequestHiveModel.cacheTypePending,
      );
      await _requestBox.put(
        '${RequestHiveModel.cacheTypePending}_${model.requestId}',
        model,
      );
    }
  }

  List<RequestHiveModel> getAllRequests({int? amount}) {
    final requests = _requestBox.values
        .where((request) => request.cacheType == RequestHiveModel.cacheTypePending)
        .toList();
    if (amount == null || amount <= 0) {
      return requests;
    }
    return requests.take(amount).toList();
  }

  Future<void> cacheHistoryRequests({
    required List<RequestHiveModel> donated,
    required List<RequestHiveModel> requestedOngoing,
    required List<RequestHiveModel> donationOngoing,
    required List<RequestHiveModel> received,
    int? amountPerSection,
  }) async {
    await _removeRequestsByCacheType(RequestHiveModel.cacheTypeDonated);
    await _removeRequestsByCacheType(RequestHiveModel.cacheTypeRequestedOngoing);
    await _removeRequestsByCacheType(RequestHiveModel.cacheTypeDonationOngoing);
    await _removeRequestsByCacheType(RequestHiveModel.cacheTypeReceived);

    await _cacheRequestsByType(
      RequestHiveModel.cacheTypeDonated,
      donated,
      amountPerSection,
    );
    await _cacheRequestsByType(
      RequestHiveModel.cacheTypeRequestedOngoing,
      requestedOngoing,
      amountPerSection,
    );
    await _cacheRequestsByType(
      RequestHiveModel.cacheTypeDonationOngoing,
      donationOngoing,
      amountPerSection,
    );
    await _cacheRequestsByType(
      RequestHiveModel.cacheTypeReceived,
      received,
      amountPerSection,
    );
  }

  ({
    List<RequestHiveModel> donated,
    ({
      List<RequestHiveModel> requestedOngoing,
      List<RequestHiveModel> donationOngoing,
    })
    ongoing,
    List<RequestHiveModel> received,
  })
  getCachedHistoryRequests() {
    List<RequestHiveModel> byType(String type) {
      return _requestBox.values.where((request) => request.cacheType == type).toList();
    }

    return (
      donated: byType(RequestHiveModel.cacheTypeDonated),
      ongoing: (
        requestedOngoing: byType(RequestHiveModel.cacheTypeRequestedOngoing),
        donationOngoing: byType(RequestHiveModel.cacheTypeDonationOngoing),
      ),
      received: byType(RequestHiveModel.cacheTypeReceived),
    );
  }

  Future<void> _cacheRequestsByType(
    String cacheType,
    List<RequestHiveModel> requests,
    int? amount,
  ) async {
    final items = (amount != null && amount > 0) ? requests.take(amount) : requests;
    for (final request in items) {
      final model = request.copyWith(cacheType: cacheType);
      await _requestBox.put('${cacheType}_${model.requestId}', model);
    }
  }

  Future<void> _removeRequestsByCacheType(String cacheType) async {
    final keys = _requestBox.keys.where((key) {
      final model = _requestBox.get(key);
      return model?.cacheType == cacheType;
    }).toList();
    await _requestBox.deleteAll(keys);
  }

  // Backward-compatible alias
  List<RequestHiveModel> getCachedPendingRequests() {
    return getAllRequests();
  }
}
