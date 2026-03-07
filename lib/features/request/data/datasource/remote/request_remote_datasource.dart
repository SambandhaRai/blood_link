import 'package:blood_link/core/api/api_client.dart';
import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/core/services/storage/token_service.dart';
import 'package:blood_link/features/request/data/datasource/request_datasource.dart';
import 'package:blood_link/features/request/data/models/create_request_api_model.dart';
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

  Options _authOptions(String? token) {
    return Options(headers: {"Authorization": "Bearer $token"});
  }

  @override
  Future<RequestApiModel> createRequest(CreateRequestApiModel request) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.post(
      ApiEndpoints.request,
      data: request.toJson(),
      options: _authOptions(token),
    );

    return RequestApiModel.fromJson(
      response.data["data"] as Map<String, dynamic>,
    );
  }

  @override
  Future<
    ({
      List<RequestApiModel> requests,
      int page,
      int size,
      int total,
      int totalPages,
    })
  >
  getAllPendingRequests({int page = 1, int size = 10, String? search}) async {
    final token = _tokenService.getToken();

    final query = <String, dynamic>{
      "page": page,
      "size": size,
      if (search != null && search.trim().isNotEmpty) "search": search.trim(),
    };

    final response = await _apiClient.get(
      ApiEndpoints.request,
      queryParameters: query,
      options: _authOptions(token),
    );

    final data = (response.data["data"] as List? ?? []);
    final pagination = (response.data["pagination"] as Map? ?? {});

    return (
      requests: data.map((json) => RequestApiModel.fromJson(json)).toList(),
      page: (pagination["page"] ?? page) as int,
      size: (pagination["size"] ?? size) as int,
      total: (pagination["total"] ?? 0) as int,
      totalPages: (pagination["totalPages"] ?? 0) as int,
    );
  }

  @override
  Future<RequestApiModel> getRequestById(String requestId) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.getRequestById(requestId),
      options: _authOptions(token),
    );

    return RequestApiModel.fromJson(response.data["data"]);
  }

  @override
  Future<RequestApiModel> updateRequest(
    String requestId,
    CreateRequestApiModel request,
  ) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.patch(
      ApiEndpoints.updateRequest(requestId),
      data: request.toJson(),
      options: _authOptions(token),
    );

    return RequestApiModel.fromJson(response.data["data"]);
  }

  @override
  Future<void> deleteRequest(String requestId) async {
    final token = _tokenService.getToken();

    await _apiClient.delete(
      ApiEndpoints.deleteRequest(requestId),
      options: _authOptions(token),
    );
  }

  @override
  Future<RequestApiModel> acceptRequest(String requestId) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.patch(
      ApiEndpoints.acceptRequest(requestId),
      options: _authOptions(token),
    );

    return RequestApiModel.fromJson(response.data["data"]);
  }

  @override
  Future<RequestApiModel> finishRequest(String requestId) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.patch(
      ApiEndpoints.finishRequest(requestId),
      options: _authOptions(token),
    );

    return RequestApiModel.fromJson(response.data["data"]);
  }

  @override
  Future<
    ({
      List<RequestApiModel> donated,
      ({
        List<RequestApiModel> requestedOngoing,
        List<RequestApiModel> donationOngoing,
      })
      ongoing,
      List<RequestApiModel> received,
    })
  >
  getMyHistory() async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.getMyRequestHistory,
      options: _authOptions(token),
    );

    final data = (response.data["data"] as Map? ?? {});

    final donated = (data["donated"] as List? ?? [])
        .map((json) => RequestApiModel.fromJson(json))
        .toList();

    final ongoing = (data["ongoing"] as Map? ?? {});
    final requestedOngoing = (ongoing["requestedOngoing"] as List? ?? [])
        .map((json) => RequestApiModel.fromJson(json))
        .toList();
    final donationOngoing = (ongoing["donationOngoing"] as List? ?? [])
        .map((json) => RequestApiModel.fromJson(json))
        .toList();

    final received = (data["received"] as List? ?? [])
        .map((json) => RequestApiModel.fromJson(json))
        .toList();

    return (
      donated: donated,
      ongoing: (
        requestedOngoing: requestedOngoing,
        donationOngoing: donationOngoing,
      ),
      received: received,
    );
  }

  @override
  Future<
    ({
      List<RequestApiModel> requests,
      int page,
      int size,
      int total,
      int totalPages,
    })
  >
  getMatchedRequests({
    required double lng,
    required double lat,
    double km = 5,
    int page = 1,
    int size = 10,
    String? search,
  }) async {
    final token = _tokenService.getToken();

    final query = <String, dynamic>{
      "lng": lng,
      "lat": lat,
      "km": km,
      "page": page,
      "size": size,
      if (search != null && search.trim().isNotEmpty) "search": search.trim(),
    };

    final response = await _apiClient.get(
      ApiEndpoints.getMatchedRequests,
      queryParameters: query,
      options: _authOptions(token),
    );

    final data = (response.data["data"] as List? ?? []);
    final pagination = (response.data["pagination"] as Map? ?? {});

    return (
      requests: data.map((json) => RequestApiModel.fromJson(json)).toList(),
      page: (pagination["page"] ?? page) as int,
      size: (pagination["size"] ?? size) as int,
      total: (pagination["total"] ?? 0) as int,
      totalPages: (pagination["totalPages"] ?? 0) as int,
    );
  }
}
