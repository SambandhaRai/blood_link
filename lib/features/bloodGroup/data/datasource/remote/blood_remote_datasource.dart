import 'package:blood_link/core/api/api_client.dart';
import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/features/bloodGroup/data/datasource/blood_datasource.dart';
import 'package:blood_link/features/bloodGroup/data/models/blood_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bloodRemoteDatasourceProvider = Provider<BloodRemoteDatasource>((ref) {
  return BloodRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class BloodRemoteDatasource implements IBloodRemoteDatasource {
  final ApiClient _apiClient;

  BloodRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<bool> createBloodGroup(BloodApiModel blood) async {
    final response = await _apiClient.post(ApiEndpoints.adminCreateBloodGroup);
    return response.data['success'] == true;
  }

  @override
  Future<List<BloodApiModel>> getAllBloodGroup() async {
    final response = await _apiClient.get(ApiEndpoints.bloodGroup);
    final data = response.data['data'] as List;
    return data.map((json) => BloodApiModel.fromJson(json)).toList();
  }

  @override
  Future<BloodApiModel> getBloodById(String bloodId) async {
    final response = await _apiClient.get(ApiEndpoints.bloodGroupById(bloodId));
    return response.data['data'];
  }
}
