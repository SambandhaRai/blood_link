import 'package:blood_link/features/request/data/models/request_api_model.dart';

abstract interface class IRequestRemoteDatasource {
  Future<RequestApiModel> createRequest(RequestApiModel request);
  Future<List<RequestApiModel>> getAllRequests();
}
