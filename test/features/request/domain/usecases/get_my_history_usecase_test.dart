import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/usecases/get_my_history_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRequestRepository extends Mock implements IRequestRepository {}

void main() {
  late GetMyHistoryUsecase usecase;
  late IRequestRepository mockRequestRepository;

  setUp(() {
    mockRequestRepository = MockRequestRepository();
    usecase = GetMyHistoryUsecase(requestRepository: mockRequestRepository);
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

  final tHistory = (
    donated: [tRequest],
    ongoing: (
      requestedOngoing: [tRequest],
      donationOngoing: [tRequest],
    ),
    received: [tRequest],
  );

  group('Get My History Usecase', () {
    test('Should return history record when fetch succeeds', () async {
      // Arrange
      when(
        () => mockRequestRepository.getMyHistory(),
      ).thenAnswer((_) async => Right(tHistory));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Right(tHistory));
      verify(() => mockRequestRepository.getMyHistory()).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });

    test('Should return failure when fetch fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to fetch history');
      when(
        () => mockRequestRepository.getMyHistory(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRequestRepository.getMyHistory()).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });
  });
}
