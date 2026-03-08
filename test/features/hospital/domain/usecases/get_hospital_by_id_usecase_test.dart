import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/geo_point/domain/entities/geo_point_entity.dart';
import 'package:blood_link/features/hospital/domain/entities/hospital_entity.dart';
import 'package:blood_link/features/hospital/domain/repositories/hospital_repository.dart';
import 'package:blood_link/features/hospital/domain/usecases/get_hospital_by_id_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHospitalRepository extends Mock implements IHospitalRepository {}

void main() {
  late GetHospitalByIdUsecase usecase;
  late IHospitalRepository mockHospitalRepository;

  setUp(() {
    mockHospitalRepository = MockHospitalRepository();
    usecase = GetHospitalByIdUsecase(hospitalRepository: mockHospitalRepository);
  });

  const tHospitalId = 'h1';
  const tHospital = HospitalEntity(
    id: tHospitalId,
    name: 'City Hospital',
    location: GeoPoint(latitude: 27.7172, longitude: 85.3240),
    isActive: true,
  );

  group('Get Hospital By Id Usecase', () {
    test('Should return hospital when fetch succeeds', () async {
      // Arrange
      when(
        () => mockHospitalRepository.getHospitalById(tHospitalId),
      ).thenAnswer((_) async => const Right(tHospital));

      // Act
      final result = await usecase(
        const GetHospitalByIdParams(hospitalId: tHospitalId),
      );

      // Assert
      expect(result, const Right(tHospital));
      verify(() => mockHospitalRepository.getHospitalById(tHospitalId)).called(1);
      verifyNoMoreInteractions(mockHospitalRepository);
    });

    test('Should return failure when repository call fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Hospital not found');
      when(
        () => mockHospitalRepository.getHospitalById(tHospitalId),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const GetHospitalByIdParams(hospitalId: tHospitalId),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockHospitalRepository.getHospitalById(tHospitalId)).called(1);
      verifyNoMoreInteractions(mockHospitalRepository);
    });
  });

  group('Get Hospital By Id Params', () {
    test('Should have correct props', () {
      const params = GetHospitalByIdParams(hospitalId: tHospitalId);
      expect(params.props, [tHospitalId]);
    });

    test('Two params with same values should be equal', () {
      const params1 = GetHospitalByIdParams(hospitalId: tHospitalId);
      const params2 = GetHospitalByIdParams(hospitalId: tHospitalId);
      expect(params1, params2);
    });
  });
}
