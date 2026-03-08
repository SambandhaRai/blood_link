import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/usecases/delete_request_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRequestRepository extends Mock implements IRequestRepository {}

void main() {
  late DeleteRequestUsecase usecase;
  late IRequestRepository mockRequestRepository;

  setUp(() {
    mockRequestRepository = MockRequestRepository();
    usecase = DeleteRequestUsecase(requestRepository: mockRequestRepository);
  });

  const tRequestId = 'req-1';

  group('Delete Request Usecase', () {
    test('Should return success when delete succeeds', () async {
      // Arrange
      when(
        () => mockRequestRepository.deleteRequest(tRequestId),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase(const DeleteRequestParams(requestId: tRequestId));

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(() => mockRequestRepository.deleteRequest(tRequestId)).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });

    test('Should return failure when delete fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Delete failed');
      when(
        () => mockRequestRepository.deleteRequest(tRequestId),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(const DeleteRequestParams(requestId: tRequestId));

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRequestRepository.deleteRequest(tRequestId)).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });
  });

  group('Delete Request Params', () {
    test('Should have correct props', () {
      const params = DeleteRequestParams(requestId: tRequestId);
      expect(params.props, [tRequestId]);
    });
  });
}
