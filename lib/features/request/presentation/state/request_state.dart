import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:equatable/equatable.dart';

enum RequestStatus { initial, loading, loaded, error, created }

class RequestState extends Equatable {
  final RequestStatus status;
  final List<RequestEntity> requests;
  final List<RequestEntity> myPendingRequests;
  final List<RequestEntity> myOngoingRequests;
  final List<RequestEntity> myFinishedRequests;
  final RequestEntity? selectedRequest;
  final String? errorMessage;

  const RequestState({
    this.status = RequestStatus.initial,
    this.requests = const [],
    this.myPendingRequests = const [],
    this.myOngoingRequests = const [],
    this.myFinishedRequests = const [],
    this.selectedRequest,
    this.errorMessage,
  });

  RequestState copyWith({
    RequestStatus? status,
    List<RequestEntity>? requests,
    List<RequestEntity>? myPendingRequests,
    List<RequestEntity>? myOngoingRequests,
    List<RequestEntity>? myFinishedRequests,
    RequestEntity? selectedRequest,
    bool resetSelectedRequest = false,
    String? errorMessage,
    bool resetErrorMessage = false,
  }) {
    return RequestState(
      status: status ?? this.status,
      requests: requests ?? this.requests,
      myPendingRequests: myPendingRequests ?? this.myPendingRequests,
      myOngoingRequests: myOngoingRequests ?? this.myOngoingRequests,
      myFinishedRequests: myFinishedRequests ?? this.myFinishedRequests,
      selectedRequest: resetSelectedRequest
          ? null
          : (selectedRequest ?? this.selectedRequest),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    requests,
    myPendingRequests,
    myOngoingRequests,
    myFinishedRequests,
    selectedRequest,
    errorMessage,
  ];
}
