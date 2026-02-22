import 'package:blood_link/core/api/api_client.dart';
import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/core/services/storage/token_service.dart';
import 'package:blood_link/features/request/data/datasource/request_datasource.dart';
import 'package:blood_link/features/request/data/models/request_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestRemoteDatasourceProvider = Provider<RequestRemoteDatasource>((
  ref,
) {
  return RequestRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class RequestRemoteDatasource implements IRequestRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  RequestRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<RequestApiModel> createRequest(RequestApiModel request) async {
    final token = _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.request,
      data: request.toJson(),
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return RequestApiModel.fromJson(response.data["data"]);
  }

  @override
  Future<List<RequestApiModel>> getAllRequests() async {
    final token = _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.request,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    final data = response.data["data"] as List;
    return data.map((json) => RequestApiModel.fromJson(json)).toList();
  }
}
