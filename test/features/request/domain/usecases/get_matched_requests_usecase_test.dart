import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/usecases/get_matched_requests_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRequestRepository extends Mock implements IRequestRepository {}

void main() {
  late GetMatchedRequestsUsecase usecase;
  late IRequestRepository mockRequestRepository;

  setUp(() {
    mockRequestRepository = MockRequestRepository();
    usecase = GetMatchedRequestsUsecase(requestRepository: mockRequestRepository);
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

  group('Get Matched Requests Usecase', () {
    test('Should return paginated matched requests when fetch succeeds', () async {
      // Arrange
      const params = GetMatchedRequestsParams(
        lng: 85.3240,
        lat: 27.7172,
        km: 5,
        page: 1,
        size: 10,
        search: 'A+',
      );
      when(
        () => mockRequestRepository.getMatchedRequests(
          lng: 85.3240,
          lat: 27.7172,
          km: 5,
          page: 1,
          size: 10,
          search: 'A+',
        ),
      ).thenAnswer((_) async => Right(tResponse));

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, Right(tResponse));
      verify(
        () => mockRequestRepository.getMatchedRequests(
          lng: 85.3240,
          lat: 27.7172,
          km: 5,
          page: 1,
          size: 10,
          search: 'A+',
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });

    test('Should return failure when fetch fails', () async {
      // Arrange
      const params = GetMatchedRequestsParams(lng: 85.3240, lat: 27.7172);
      const failure = ApiFailure(message: 'Failed to fetch matched requests');
      when(
        () => mockRequestRepository.getMatchedRequests(
          lng: 85.3240,
          lat: 27.7172,
          km: 5,
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
        () => mockRequestRepository.getMatchedRequests(
          lng: 85.3240,
          lat: 27.7172,
          km: 5,
          page: 1,
          size: 10,
          search: null,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });
  });

  group('Get Matched Requests Params', () {
    test('Should have correct props', () {
      const params = GetMatchedRequestsParams(
        lng: 1.2,
        lat: 3.4,
        km: 10,
        page: 2,
        size: 20,
        search: 'A+',
      );
      expect(params.props, [1.2, 3.4, 10, 2, 20, 'A+']);
    });
  });
}
