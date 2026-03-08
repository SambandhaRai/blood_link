import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/usecases/get_all_pending_requests_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRequestRepository extends Mock implements IRequestRepository {}

void main() {
  late GetAllPendingRequestsUsecase usecase;
  late IRequestRepository mockRequestRepository;

  setUp(() {
    mockRequestRepository = MockRequestRepository();
    usecase = GetAllPendingRequestsUsecase(requestRepository: mockRequestRepository);
  });

  const tRequest = RequestEntity(
    requestId: 'req-1',
    recipientBloodId: '1',
    recipientBlood: null,
    hospitalId: 'h1',
    hospital: null,
    recipientDetails: 'Need urgent blood',
    recipientCondition: ConditionType.critical,
    requestFor: RequestForType.self,
  );

  final tResponse = (
    requests: [tRequest],
    page: 1,
    size: 10,
    total: 1,
    totalPages: 1,
  );

  group('Get All Pending Requests Usecase', () {
    test('Should return paginated response when fetch succeeds', () async {
      // Arrange
      const params = PendingRequestsParams(search: 'urgent', page: 1, size: 10);
      when(
        () => mockRequestRepository.getAllPendingRequests(
          page: 1,
          size: 10,
          search: 'urgent',
        ),
      ).thenAnswer((_) async => Right(tResponse));

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, Right(tResponse));
      verify(
        () => mockRequestRepository.getAllPendingRequests(
          page: 1,
          size: 10,
          search: 'urgent',
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });

    test('Should return failure when fetch fails', () async {
      // Arrange
      const params = PendingRequestsParams(page: 1, size: 10);
      const failure = ApiFailure(message: 'Failed to fetch pending requests');
      when(
        () => mockRequestRepository.getAllPendingRequests(
          page: 1,
          size: 10,
          search: null,
        ),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, const Left(failure));
      verify(
        () => mockRequestRepository.getAllPendingRequests(
          page: 1,
          size: 10,
          search: null,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });
  });

  group('Pending Requests Params', () {
    test('Should have correct props', () {
      const params = PendingRequestsParams(search: 'urgent', page: 2, size: 5);
      expect(params.props, ['urgent', 2, 5]);
    });
  });
}
