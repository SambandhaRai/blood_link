import 'package:blood_link/features/request/domain/entities/create_request_entity.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart'
    hide ConditionType, RequestForType;
import 'package:blood_link/features/request/domain/usecases/accept_request_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/create_request_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/finish_request_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/get_all_pending_requests_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/get_matched_requests_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/get_my_history_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/get_request_by_id_usecase.dart';
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestViewModelProvider =
    NotifierProvider.autoDispose<RequestViewmodel, RequestState>(
      RequestViewmodel.new,
    );

class RequestViewmodel extends Notifier<RequestState> {
  late final GetAllPendingRequestsUsecase _getAllPendingRequestsUsecase;
  late final CreateRequestUsecase _createRequestUsecase;
  late final GetRequestByIdUsecase _getRequestByIdUsecase;
  late final GetMyHistoryUsecase _getMyHistoryUsecase;
  late final AcceptRequestUsecase _acceptRequestUsecase;
  late final FinishRequestUsecase _finishRequestUsecase;
  late final GetMatchedRequestsUsecase _getMatchedRequestsUsecase;

  @override
  RequestState build() {
    _getAllPendingRequestsUsecase = ref.read(
      getAllPendingRequestsUsecaseProvider,
    );
    _createRequestUsecase = ref.read(createRequestUsecaseProvider);
    _getRequestByIdUsecase = ref.read(getRequestByIdUsecaseProvider);
    _getMyHistoryUsecase = ref.read(getMyHistoryUsecaseProvider);
    _acceptRequestUsecase = ref.read(acceptRequestUsecaseProvider);
    _finishRequestUsecase = ref.read(finishRequestUsecaseProvider);
    _getMatchedRequestsUsecase = ref.read(getMatchedRequestsUsecaseProvider);
    return const RequestState();
  }

  Future<void> getAllPendingRequests({
    String? search,
    int page = 1,
    int size = 10,
  }) async {
    state = state.copyWith(
      status: RequestStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _getAllPendingRequestsUsecase(
      PendingRequestsParams(search: search, page: page, size: size),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
      (data) {
        state = state.copyWith(
          status: RequestStatus.loaded,
          requests: data.requests,
          page: data.page,
          size: data.size,
          total: data.total,
          totalPages: data.totalPages,
        );
      },
    );
  }

  Future<void> createRequests({
    required String recipientBloodId,
    required String recipientDetails,
    required ConditionType recipientCondition,
    required String hospitalId,
    RequestForType requestFor = RequestForType.self,
    String? relationToPatient,
    String? patientName,
    String? patientPhone,
  }) async {
    state = state.copyWith(
      status: RequestStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _createRequestUsecase(
      CreateRequestParams(
        recipientBloodId: recipientBloodId,
        recipientDetails: recipientDetails,
        recipientCondition: recipientCondition,
        hospitalId: hospitalId,
        requestFor: requestFor,
        relationToPatient: requestFor == RequestForType.others
            ? relationToPatient
            : null,
        patientName: requestFor == RequestForType.others ? patientName : null,
        patientPhone: requestFor == RequestForType.others ? patientPhone : null,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
      (createdRequest) async {
        state = state.copyWith(
          status: RequestStatus.created,
          requests: [createdRequest, ...state.requests],
        );
        await getAllPendingRequests();
      },
    );
  }

  Future<void> getRequestById(String requestId) async {
    state = state.copyWith(
      status: RequestStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _getRequestByIdUsecase(
      GetRequestByIdParams(requestId: requestId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
      (request) {
        state = state.copyWith(
          status: RequestStatus.loaded,
          selectedRequest: request,
          requests: _upsertById(state.requests, request),
        );
      },
    );
  }

  Future<void> getMyHistory() async {
    state = state.copyWith(
      status: RequestStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _getMyHistoryUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
      (history) {
        final requestedPending = history.ongoing.requestedOngoing
            .where((r) => (r.requestStatus ?? "").toLowerCase() == "pending")
            .toList();

        final requestedAccepted = history.ongoing.requestedOngoing
            .where((r) => (r.requestStatus ?? "").toLowerCase() == "accepted")
            .toList();

        final myOngoing = _mergeUniqueById(
          _mergeUniqueById(requestedPending, requestedAccepted),
          history.ongoing.donationOngoing,
        );

        state = state.copyWith(
          status: RequestStatus.loaded,
          myPendingRequests: requestedPending,
          myOngoingRequests: myOngoing,
          myReceivedRequests: history.received,
          myDonatedRequests: history.donated,
          myFinishedRequests: _mergeUniqueById(
            history.received,
            history.donated,
          ),
        );
      },
    );
  }

  Future<void> acceptRequest(String requestId) async {
    state = state.copyWith(
      status: RequestStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _acceptRequestUsecase(
      AcceptRequestParams(requestId: requestId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
      (updated) {
        state = state.copyWith(
          status: RequestStatus.loaded,
          selectedRequest: updated,
          requests: _upsertById(state.requests, updated),
        );
      },
    );
  }

  Future<void> finishRequest(String requestId) async {
    state = state.copyWith(
      status: RequestStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _finishRequestUsecase(
      FinishRequestParams(requestId: requestId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
      (updated) {
        state = state.copyWith(
          status: RequestStatus.loaded,
          selectedRequest: updated,
          requests: _upsertById(state.requests, updated),
        );
      },
    );
  }

  Future<void> getMatchedRequests({
    required double lng,
    required double lat,
    double km = 5,
    int page = 1,
    int size = 10,
    String? search,
  }) async {
    state = state.copyWith(
      status: RequestStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _getMatchedRequestsUsecase(
      GetMatchedRequestsParams(
        lng: lng,
        lat: lat,
        km: km,
        page: page,
        size: size,
        search: search,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
      (data) {
        state = state.copyWith(
          status: RequestStatus.loaded,
          requests: data.requests,
          page: data.page,
          size: data.size,
          total: data.total,
          totalPages: data.totalPages,
        );
      },
    );
  }

  List<RequestEntity> _upsertById(
    List<RequestEntity> list,
    RequestEntity updated,
  ) {
    final id = updated.requestId;
    if (id == null || id.isEmpty) return list;

    final index = list.indexWhere((r) => r.requestId == id);
    if (index == -1) return [updated, ...list];

    final next = [...list];
    next[index] = updated;
    return next;
  }

  List<RequestEntity> _mergeUniqueById(
    List<RequestEntity> first,
    List<RequestEntity> second,
  ) {
    final map = <String, RequestEntity>{};
    for (final r in [...first, ...second]) {
      final id = r.requestId;
      if (id == null || id.isEmpty) continue;
      map[id] = r;
    }
    return map.values.toList();
  }
}
