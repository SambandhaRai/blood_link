import 'package:blood_link/core/api/api_client.dart';
import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/core/services/storage/token_service.dart';
import 'package:blood_link/features/hospital/data/datasource/hospital_datasource.dart';
import 'package:blood_link/features/hospital/data/model/hospital_api_model.dart';
import 'package:dio/dio.dart';

class HospitalRemoteDatasource implements IRemoteHospitalDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  HospitalRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<List<HospitalApiModel>> getAllHospitals() async {
    final token = _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.hospital,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    final data = response.data['data'] as List;
    return data.map((json) => HospitalApiModel.fromJson(json)).toList();
  }

  @override
  Future<HospitalApiModel?> getHospitalById(String hospitalId) async {
    final token = _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.hospitalById(hospitalId),
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return response.data['data'];
  }
}
