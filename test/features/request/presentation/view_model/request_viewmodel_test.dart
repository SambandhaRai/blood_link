import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/request/domain/entities/create_request_entity.dart'
    as cre;
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/usecases/accept_request_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/create_request_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/delete_request_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/finish_request_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/get_all_pending_requests_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/get_matched_requests_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/get_my_history_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/get_request_by_id_usecase.dart';
import 'package:blood_link/features/request/domain/usecases/update_request_usecase.dart';
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:blood_link/features/request/presentation/view_model/request_viewmodel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllPendingRequestsUsecase extends Mock
    implements GetAllPendingRequestsUsecase {}

class MockCreateRequestUsecase extends Mock implements CreateRequestUsecase {}

class MockGetRequestByIdUsecase extends Mock implements GetRequestByIdUsecase {}

class MockGetMyHistoryUsecase extends Mock implements GetMyHistoryUsecase {}

class MockAcceptRequestUsecase extends Mock implements AcceptRequestUsecase {}

class MockFinishRequestUsecase extends Mock implements FinishRequestUsecase {}

class MockGetMatchedRequestsUsecase extends Mock
    implements GetMatchedRequestsUsecase {}

class MockUpdateRequestUsecase extends Mock implements UpdateRequestUsecase {}

class MockDeleteRequestUsecase extends Mock implements DeleteRequestUsecase {}

void main() {
  late MockGetAllPendingRequestsUsecase mockGetAllPendingRequestsUsecase;
  late MockCreateRequestUsecase mockCreateRequestUsecase;
  late MockGetRequestByIdUsecase mockGetRequestByIdUsecase;
  late MockGetMyHistoryUsecase mockGetMyHistoryUsecase;
  late MockAcceptRequestUsecase mockAcceptRequestUsecase;
  late MockFinishRequestUsecase mockFinishRequestUsecase;
  late MockGetMatchedRequestsUsecase mockGetMatchedRequestsUsecase;
  late MockUpdateRequestUsecase mockUpdateRequestUsecase;
  late MockDeleteRequestUsecase mockDeleteRequestUsecase;
  late ProviderContainer container;
  late ProviderSubscription<RequestState> subscription;

  const tRequest = RequestEntity(
    requestId: 'req-1',
    recipientBloodId: '1',
    recipientBlood: null,
    hospitalId: 'h1',
    hospital: null,
    recipientDetails: 'Need urgent blood',
    recipientCondition: ConditionType.critical,
    requestFor: RequestForType.self,
    requestStatus: 'pending',
  );

  const tAcceptedRequest = RequestEntity(
    requestId: 'req-1',
    recipientBloodId: '1',
    recipientBlood: null,
    hospitalId: 'h1',
    hospital: null,
    recipientDetails: 'Need urgent blood',
    recipientCondition: ConditionType.critical,
    requestFor: RequestForType.self,
    requestStatus: 'accepted',
  );

  setUpAll(() {
    registerFallbackValue(const PendingRequestsParams());
    registerFallbackValue(
      const CreateRequestParams(
        recipientBloodId: 'fallback',
        recipientDetails: 'fallback',
        recipientCondition: cre.ConditionType.critical,
        hospitalId: 'fallback',
      ),
    );
    registerFallbackValue(const GetRequestByIdParams(requestId: 'fallback'));
    registerFallbackValue(const AcceptRequestParams(requestId: 'fallback'));
    registerFallbackValue(const FinishRequestParams(requestId: 'fallback'));
    registerFallbackValue(
      const GetMatchedRequestsParams(lng: 0, lat: 0),
    );
    registerFallbackValue(
      const UpdateRequestParams(
        requestId: 'fallback',
        recipientBloodId: 'fallback',
        recipientDetails: 'fallback',
        recipientCondition: cre.ConditionType.critical,
        hospitalId: 'fallback',
      ),
    );
    registerFallbackValue(const DeleteRequestParams(requestId: 'fallback'));
  });

  setUp(() {
    mockGetAllPendingRequestsUsecase = MockGetAllPendingRequestsUsecase();
    mockCreateRequestUsecase = MockCreateRequestUsecase();
    mockGetRequestByIdUsecase = MockGetRequestByIdUsecase();
    mockGetMyHistoryUsecase = MockGetMyHistoryUsecase();
    mockAcceptRequestUsecase = MockAcceptRequestUsecase();
    mockFinishRequestUsecase = MockFinishRequestUsecase();
    mockGetMatchedRequestsUsecase = MockGetMatchedRequestsUsecase();
    mockUpdateRequestUsecase = MockUpdateRequestUsecase();
    mockDeleteRequestUsecase = MockDeleteRequestUsecase();

    container = ProviderContainer(
      overrides: [
        getAllPendingRequestsUsecaseProvider.overrideWithValue(
          mockGetAllPendingRequestsUsecase,
        ),
        createRequestUsecaseProvider.overrideWithValue(mockCreateRequestUsecase),
        getRequestByIdUsecaseProvider.overrideWithValue(mockGetRequestByIdUsecase),
        getMyHistoryUsecaseProvider.overrideWithValue(mockGetMyHistoryUsecase),
        acceptRequestUsecaseProvider.overrideWithValue(mockAcceptRequestUsecase),
        finishRequestUsecaseProvider.overrideWithValue(mockFinishRequestUsecase),
        getMatchedRequestsUsecaseProvider.overrideWithValue(
          mockGetMatchedRequestsUsecase,
        ),
        updateRequestUsecaseProvider.overrideWithValue(mockUpdateRequestUsecase),
        deleteRequestUsecaseProvider.overrideWithValue(mockDeleteRequestUsecase),
      ],
    );

    subscription = container.listen<RequestState>(
      requestViewModelProvider,
      (_, __) {},
      fireImmediately: true,
    );
  });

  tearDown(() {
    subscription.close();
    container.dispose();
  });

  group('RequestViewmodel', () {
    test('getAllPendingRequests should set loaded state with pagination', () async {
      // Arrange
      final response = (
        requests: const [tRequest],
        page: 1,
        size: 10,
        total: 1,
        totalPages: 1,
      );
      when(
        () => mockGetAllPendingRequestsUsecase(any()),
      ).thenAnswer((_) async => Right(response));

      final notifier = container.read(requestViewModelProvider.notifier);

      // Act
      await notifier.getAllPendingRequests(search: 'A+', page: 1, size: 10);

      // Assert
      final state = container.read(requestViewModelProvider);
      expect(state.status, RequestStatus.loaded);
      expect(state.requests, const [tRequest]);
      expect(state.total, 1);
      verify(() => mockGetAllPendingRequestsUsecase(any())).called(1);
    });

    test('createRequests should create and then refresh pending requests', () async {
      // Arrange
      final response = (
        requests: const [tRequest],
        page: 1,
        size: 10,
        total: 1,
        totalPages: 1,
      );
      when(
        () => mockCreateRequestUsecase(any()),
      ).thenAnswer((_) async => const Right(tRequest));
      when(
        () => mockGetAllPendingRequestsUsecase(any()),
      ).thenAnswer((_) async => Right(response));

      final notifier = container.read(requestViewModelProvider.notifier);

      // Act
      await notifier.createRequests(
        recipientBloodId: '1',
        recipientDetails: 'Need urgent blood',
        recipientCondition: cre.ConditionType.critical,
        hospitalId: 'h1',
      );
      await Future<void>.delayed(Duration.zero);

      // Assert
      final state = container.read(requestViewModelProvider);
      expect(state.status, RequestStatus.loaded);
      expect(state.requests, const [tRequest]);
      verify(() => mockCreateRequestUsecase(any())).called(1);
      verify(() => mockGetAllPendingRequestsUsecase(any())).called(1);
    });

    test('getRequestById should set error state on failure', () async {
      // Arrange
      const failure = ApiFailure(message: 'Request not found');
      when(
        () => mockGetRequestByIdUsecase(any()),
      ).thenAnswer((_) async => const Left(failure));
      final notifier = container.read(requestViewModelProvider.notifier);

      // Act
      await notifier.getRequestById('req-404');

      // Assert
      final state = container.read(requestViewModelProvider);
      expect(state.status, RequestStatus.error);
      expect(state.errorMessage, 'Request not found');
      verify(() => mockGetRequestByIdUsecase(any())).called(1);
    });

    test('acceptRequest should upsert request and select it', () async {
      // Arrange
      final notifier = container.read(requestViewModelProvider.notifier);
      notifier.state = notifier.state.copyWith(requests: const [tRequest]);

      when(
        () => mockAcceptRequestUsecase(any()),
      ).thenAnswer((_) async => const Right(tAcceptedRequest));

      // Act
      await notifier.acceptRequest('req-1');

      // Assert
      final state = container.read(requestViewModelProvider);
      expect(state.status, RequestStatus.loaded);
      expect(state.selectedRequest, tAcceptedRequest);
      expect(state.requests.first, tAcceptedRequest);
      verify(() => mockAcceptRequestUsecase(any())).called(1);
    });

    test('deleteRequest should remove request from lists and clear selected', () async {
      // Arrange
      final notifier = container.read(requestViewModelProvider.notifier);
      notifier.state = notifier.state.copyWith(
        requests: const [tRequest],
        myPendingRequests: const [tRequest],
        selectedRequest: tRequest,
      );
      when(
        () => mockDeleteRequestUsecase(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      await notifier.deleteRequest('req-1');

      // Assert
      final state = container.read(requestViewModelProvider);
      expect(state.status, RequestStatus.loaded);
      expect(state.requests, isEmpty);
      expect(state.myPendingRequests, isEmpty);
      expect(state.selectedRequest, isNull);
      verify(() => mockDeleteRequestUsecase(any())).called(1);
    });

    test('getMatchedRequests should set loaded state with matched data', () async {
      // Arrange
      final response = (
        requests: const [tRequest],
        page: 2,
        size: 5,
        total: 11,
        totalPages: 3,
      );
      when(
        () => mockGetMatchedRequestsUsecase(any()),
      ).thenAnswer((_) async => Right(response));
      final notifier = container.read(requestViewModelProvider.notifier);

      // Act
      await notifier.getMatchedRequests(
        lng: 85.3240,
        lat: 27.7172,
        km: 5,
        page: 2,
        size: 5,
        search: 'A+',
      );

      // Assert
      final state = container.read(requestViewModelProvider);
      expect(state.status, RequestStatus.loaded);
      expect(state.requests, const [tRequest]);
      expect(state.page, 2);
      expect(state.totalPages, 3);
      verify(() => mockGetMatchedRequestsUsecase(any())).called(1);
    });

    test('getMyHistory should classify pending and ongoing requests', () async {
      // Arrange
      const requestedAccepted = RequestEntity(
        requestId: 'req-2',
        recipientBloodId: '1',
        recipientBlood: null,
        hospitalId: 'h1',
        hospital: null,
        recipientDetails: 'Accepted one',
        recipientCondition: ConditionType.urgent,
        requestFor: RequestForType.self,
        requestStatus: 'accepted',
      );
      const donationOngoing = RequestEntity(
        requestId: 'req-3',
        recipientBloodId: '1',
        recipientBlood: null,
        hospitalId: 'h1',
        hospital: null,
        recipientDetails: 'Donation ongoing',
        recipientCondition: ConditionType.stable,
        requestFor: RequestForType.self,
        requestStatus: 'accepted',
      );

      final history = (
        donated: const [donationOngoing],
        ongoing: (
          requestedOngoing: const [tRequest, requestedAccepted],
          donationOngoing: const [donationOngoing],
        ),
        received: const [tAcceptedRequest],
      );

      when(() => mockGetMyHistoryUsecase()).thenAnswer((_) async => Right(history));
      final notifier = container.read(requestViewModelProvider.notifier);

      // Act
      await notifier.getMyHistory();

      // Assert
      final state = container.read(requestViewModelProvider);
      expect(state.status, RequestStatus.loaded);
      expect(state.myPendingRequests, const [tRequest]);
      expect(state.myOngoingRequests.length, 3);
      expect(state.myReceivedRequests, const [tAcceptedRequest]);
      expect(state.myDonatedRequests, const [donationOngoing]);
      verify(() => mockGetMyHistoryUsecase()).called(1);
    });
  });
}
