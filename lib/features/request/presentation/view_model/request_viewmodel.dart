import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/usecases/create_request_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/get_all_requests_usecase.dart';
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestViewmodel extends Notifier<RequestState> {
  late final GetAllRequestsUsecase _getAllRequestsUsecase;
  late final CreateRequestUsecase _createRequestUsecase;

  @override
  RequestState build() {
    _getAllRequestsUsecase = ref.read(getAllRequestsUsecaseProvider);
    _createRequestUsecase = ref.read(createRequestUsecaseProvider);
    return const RequestState();
  }

  Future<void> getAllRequests() async {
    state = state.copyWith(status: RequestStatus.loading);

    final result = await _getAllRequestsUsecase();

    result.fold(
      (failure) => state.copyWith(
        status: RequestStatus.error,
        errorMessage: failure.message,
      ),
      (requests) {
        state = state.copyWith(
          status: RequestStatus.loaded,
          requests: requests,
        );
      },
    );
  }

  Future<void> createRequests({
    required String recipientBloodId,
    required String recipientDetails,
    required ConditionType recipientCondition,
    required String hospitalId,
  }) async {
    state = state.copyWith(status: RequestStatus.loading);

    final result = await _createRequestUsecase(
      CreateRequestParams(
        recipientBloodId: recipientBloodId,
        recipientDetails: recipientDetails,
        recipientCondition: recipientCondition,
        hospitalId: hospitalId,
      ),
    );

    result.fold(
      (failure) => state.copyWith(
        status: RequestStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: RequestStatus.created);
        getAllRequests();
      },
    );
  }
}
