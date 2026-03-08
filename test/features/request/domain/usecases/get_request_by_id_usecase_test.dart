import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/usecases/get_request_by_id_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRequestRepository extends Mock implements IRequestRepository {}

void main() {
  late GetRequestByIdUsecase usecase;
  late IRequestRepository mockRequestRepository;

  setUp(() {
    mockRequestRepository = MockRequestRepository();
    usecase = GetRequestByIdUsecase(requestRepository: mockRequestRepository);
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

  group('Get Request By Id Usecase', () {
    test('Should return RequestEntity when fetch succeeds', () async {
      // Arrange
      when(
        () => mockRequestRepository.getRequestById(tRequestId),
      ).thenAnswer((_) async => const Right(tRequest));

      // Act
      final result = await usecase(
        const GetRequestByIdParams(requestId: tRequestId),
      );

      // Assert
      expect(result, const Right(tRequest));
      verify(() => mockRequestRepository.getRequestById(tRequestId)).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });

    test('Should return failure when fetch fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Request not found');
      when(
        () => mockRequestRepository.getRequestById(tRequestId),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const GetRequestByIdParams(requestId: tRequestId),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRequestRepository.getRequestById(tRequestId)).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });
  });

  group('Get Request By Id Params', () {
    test('Should have correct props', () {
      const params = GetRequestByIdParams(requestId: tRequestId);
      expect(params.props, [tRequestId]);
    });
  });
}
