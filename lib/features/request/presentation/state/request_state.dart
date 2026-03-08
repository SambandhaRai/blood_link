import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:equatable/equatable.dart';

enum RequestStatus { initial, loading, loaded, error, created }

class RequestState extends Equatable {
  final RequestStatus status;
  final List<RequestEntity> requests;
  final int page;
  final int size;
  final int total;
  final int totalPages;
  final List<RequestEntity> myPendingRequests;
  final List<RequestEntity> myOngoingRequests;
  final List<RequestEntity> myReceivedRequests;
  final List<RequestEntity> myDonatedRequests;
  final List<RequestEntity> myFinishedRequests;
  final RequestEntity? selectedRequest;
  final String? errorMessage;

  const RequestState({
    this.status = RequestStatus.initial,
    this.requests = const [],
    this.page = 1,
    this.size = 10,
    this.total = 0,
    this.totalPages = 0,
    this.myPendingRequests = const [],
    this.myOngoingRequests = const [],
    this.myReceivedRequests = const [],
    this.myDonatedRequests = const [],
    this.myFinishedRequests = const [],
    this.selectedRequest,
    this.errorMessage,
  });

  RequestState copyWith({
    RequestStatus? status,
    List<RequestEntity>? requests,
    int? page,
    int? size,
    int? total,
    int? totalPages,
    List<RequestEntity>? myPendingRequests,
    List<RequestEntity>? myOngoingRequests,
    List<RequestEntity>? myReceivedRequests,
    List<RequestEntity>? myDonatedRequests,
    List<RequestEntity>? myFinishedRequests,
    RequestEntity? selectedRequest,
    bool resetSelectedRequest = false,
    String? errorMessage,
    bool resetErrorMessage = false,
  }) {
    return RequestState(
      status: status ?? this.status,
      requests: requests ?? this.requests,
      page: page ?? this.page,
      size: size ?? this.size,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      myPendingRequests: myPendingRequests ?? this.myPendingRequests,
      myOngoingRequests: myOngoingRequests ?? this.myOngoingRequests,
      myReceivedRequests: myReceivedRequests ?? this.myReceivedRequests,
      myDonatedRequests: myDonatedRequests ?? this.myDonatedRequests,
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
    page,
    size,
    total,
    totalPages,
    myPendingRequests,
    myOngoingRequests,
    myReceivedRequests,
    myDonatedRequests,
    myFinishedRequests,
    selectedRequest,
    errorMessage,
  ];
}
