import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/usecases/accept_request_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRequestRepository extends Mock implements IRequestRepository {}

void main() {
  late AcceptRequestUsecase usecase;
  late IRequestRepository mockRequestRepository;

  setUp(() {
    mockRequestRepository = MockRequestRepository();
    usecase = AcceptRequestUsecase(requestRepository: mockRequestRepository);
  });

  const tRequestId = 'req-1';
  const tRequest = RequestEntity(
    requestId: tRequestId,
    recipientBloodId: '1',
    recipientBlood: null,
    hospitalId: 'h1',
    hospital: null,
    recipientDetails: 'Need urgent blood',
    recipientCondition: ConditionType.critical,
    requestFor: RequestForType.self,
  );

  group('Accept Request Usecase', () {
    test('Should return RequestEntity when accept succeeds', () async {
      // Arrange
      when(
        () => mockRequestRepository.acceptRequest(tRequestId),
      ).thenAnswer((_) async => const Right(tRequest));

      // Act
      final result = await usecase(const AcceptRequestParams(requestId: tRequestId));

      // Assert
      expect(result, const Right(tRequest));
      verify(() => mockRequestRepository.acceptRequest(tRequestId)).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });

    test('Should return failure when accept fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Unable to accept request');
      when(
        () => mockRequestRepository.acceptRequest(tRequestId),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(const AcceptRequestParams(requestId: tRequestId));

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRequestRepository.acceptRequest(tRequestId)).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });
  });

  group('Accept Request Params', () {
    test('Should have correct props', () {
      const params = AcceptRequestParams(requestId: tRequestId);
      expect(params.props, [tRequestId]);
    });
  });
}
