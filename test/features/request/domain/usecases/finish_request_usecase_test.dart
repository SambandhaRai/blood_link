import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/usecases/finish_request_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRequestRepository extends Mock implements IRequestRepository {}

void main() {
  late FinishRequestUsecase usecase;
  late IRequestRepository mockRequestRepository;

  setUp(() {
    mockRequestRepository = MockRequestRepository();
    usecase = FinishRequestUsecase(requestRepository: mockRequestRepository);
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

  group('Finish Request Usecase', () {
    test('Should return RequestEntity when finish succeeds', () async {
      // Arrange
      when(
        () => mockRequestRepository.finishRequest(tRequestId),
      ).thenAnswer((_) async => const Right(tRequest));

      // Act
      final result = await usecase(const FinishRequestParams(requestId: tRequestId));

      // Assert
      expect(result, const Right(tRequest));
      verify(() => mockRequestRepository.finishRequest(tRequestId)).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });

    test('Should return failure when finish fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Unable to finish request');
      when(
        () => mockRequestRepository.finishRequest(tRequestId),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(const FinishRequestParams(requestId: tRequestId));

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRequestRepository.finishRequest(tRequestId)).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });
  });

  group('Finish Request Params', () {
    test('Should have correct props', () {
      const params = FinishRequestParams(requestId: tRequestId);
      expect(params.props, [tRequestId]);
    });
  });
}
