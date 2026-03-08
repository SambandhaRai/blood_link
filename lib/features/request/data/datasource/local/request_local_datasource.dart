import 'package:blood_link/core/services/hive/hive_service.dart';
import 'package:blood_link/features/request/data/datasource/request_datasource.dart';
import 'package:blood_link/features/request/data/models/request_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestLocalDatasourceProvider = Provider<RequestLocalDatasource>((ref) {
  return RequestLocalDatasource(hiveService: ref.read(hiveServiceProvider));
});

class RequestLocalDatasource implements IRequestLocalDatasource {
  final HiveService _hiveService;

  RequestLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<List<RequestHiveModel>> getAllRequests({int? amount}) async {
    try {
      return _hiveService.getAllRequests(amount: amount);
    } catch (e) {
      return [];
    }
  }

  Future<void> cachePendingRequests(
    List<RequestHiveModel> requests, {
    int? amount,
  }) async {
    await _hiveService.cachePendingRequests(requests, amount: amount);
  }

  Future<void> cacheHistoryRequests({
    required List<RequestHiveModel> donated,
    required List<RequestHiveModel> requestedOngoing,
    required List<RequestHiveModel> donationOngoing,
    required List<RequestHiveModel> received,
    int? amountPerSection,
  }) async {
    await _hiveService.cacheHistoryRequests(
      donated: donated,
      requestedOngoing: requestedOngoing,
      donationOngoing: donationOngoing,
      received: received,
      amountPerSection: amountPerSection,
    );
  }

  Future<
    ({
      List<RequestHiveModel> donated,
      ({
        List<RequestHiveModel> requestedOngoing,
        List<RequestHiveModel> donationOngoing,
      })
      ongoing,
      List<RequestHiveModel> received,
    })
  >
  getCachedHistoryRequests() async {
    return _hiveService.getCachedHistoryRequests();
  }
}
