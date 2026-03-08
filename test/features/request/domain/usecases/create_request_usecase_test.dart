import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/request/domain/entities/create_request_entity.dart'
    as cre;
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/domain/repositories/request_repository.dart';
import 'package:blood_link/features/request/domain/usecases/create_request_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRequestRepository extends Mock implements IRequestRepository {}

void main() {
  late CreateRequestUsecase usecase;
  late IRequestRepository mockRequestRepository;

  setUp(() {
    mockRequestRepository = MockRequestRepository();
    usecase = CreateRequestUsecase(requestRepository: mockRequestRepository);
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

  group('Create Request Usecase', () {
    test('Should return RequestEntity when create succeeds', () async {
      // Arrange
      const params = CreateRequestParams(
        recipientBloodId: '1',
        recipientDetails: 'Need urgent blood',
        recipientCondition: cre.ConditionType.critical,
        hospitalId: 'h1',
      );
      const requestEntity = cre.CreateRequestEntity(
        recipientBloodId: '1',
        hospitalId: 'h1',
        recipientDetails: 'Need urgent blood',
        recipientCondition: cre.ConditionType.critical,
        requestFor: cre.RequestForType.self,
      );
      when(
        () => mockRequestRepository.createRequest(requestEntity),
      ).thenAnswer((_) async => const Right(tRequest));

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, const Right(tRequest));
      verify(() => mockRequestRepository.createRequest(requestEntity)).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });

    test('Should map patient fields for requestFor others', () async {
      // Arrange
      const params = CreateRequestParams(
        recipientBloodId: '2',
        recipientDetails: 'Need blood for family',
        recipientCondition: cre.ConditionType.urgent,
        hospitalId: 'h2',
        requestFor: cre.RequestForType.others,
        relationToPatient: 'Brother',
        patientName: 'John Doe',
        patientPhone: '1234567890',
      );
      const requestEntity = cre.CreateRequestEntity(
        recipientBloodId: '2',
        hospitalId: 'h2',
        recipientDetails: 'Need blood for family',
        recipientCondition: cre.ConditionType.urgent,
        requestFor: cre.RequestForType.others,
        relationToPatient: 'Brother',
        patientName: 'John Doe',
        patientPhone: '1234567890',
      );
      when(
        () => mockRequestRepository.createRequest(requestEntity),
      ).thenAnswer((_) async => const Right(tRequest));

      // Act
      await usecase(params);

      // Assert
      verify(() => mockRequestRepository.createRequest(requestEntity)).called(1);
    });

    test('Should return failure when create fails', () async {
      // Arrange
      const params = CreateRequestParams(
        recipientBloodId: '1',
        recipientDetails: 'Need urgent blood',
        recipientCondition: cre.ConditionType.critical,
        hospitalId: 'h1',
      );
      const requestEntity = cre.CreateRequestEntity(
        recipientBloodId: '1',
        hospitalId: 'h1',
        recipientDetails: 'Need urgent blood',
        recipientCondition: cre.ConditionType.critical,
        requestFor: cre.RequestForType.self,
      );
      const failure = ApiFailure(message: 'Create request failed');
      when(
        () => mockRequestRepository.createRequest(requestEntity),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRequestRepository.createRequest(requestEntity)).called(1);
      verifyNoMoreInteractions(mockRequestRepository);
    });
  });

  group('Create Request Params', () {
    test('Should have correct props', () {
      const params = CreateRequestParams(
        recipientBloodId: '1',
        recipientDetails: 'Need urgent blood',
        recipientCondition: cre.ConditionType.critical,
        hospitalId: 'h1',
      );
      expect(params.props, [
        '1',
        'Need urgent blood',
        cre.ConditionType.critical,
        'h1',
        cre.RequestForType.self,
        null,
        null,
        null,
      ]);
    });
  });
}
