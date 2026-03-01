import 'package:blood_link/features/request/data/models/create_request_api_model.dart';
import 'package:blood_link/features/request/data/models/request_api_model.dart';

abstract interface class IRequestRemoteDatasource {
  Future<RequestApiModel> createRequest(CreateRequestApiModel request);
  Future<
    ({
      List<RequestApiModel> requests,
      int page,
      int size,
      int total,
      int totalPages,
    })
  >
  getAllPendingRequests({int page = 1, int size = 10, String? search});
  Future<RequestApiModel> getRequestById(String requestId);
  Future<RequestApiModel> acceptRequest(String requestId);
  Future<RequestApiModel> finishRequest(String requestId);

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
  getMyHistory();
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
  });
}
