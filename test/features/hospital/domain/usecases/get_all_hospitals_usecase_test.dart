import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/geo_point/domain/entities/geo_point_entity.dart';
import 'package:blood_link/features/hospital/domain/entities/hospital_entity.dart';
import 'package:blood_link/features/hospital/domain/repositories/hospital_repository.dart';
import 'package:blood_link/features/hospital/domain/usecases/get_all_hospitals_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHospitalRepository extends Mock implements IHospitalRepository {}

void main() {
  late GetAllHospitalsUsecase usecase;
  late IHospitalRepository mockHospitalRepository;

  setUp(() {
    mockHospitalRepository = MockHospitalRepository();
    usecase = GetAllHospitalsUsecase(hospitalRepository: mockHospitalRepository);
  });

  const tHospitals = [
    HospitalEntity(
      id: 'h1',
      name: 'City Hospital',
      location: GeoPoint(latitude: 27.7172, longitude: 85.3240),
      isActive: true,
    ),
    HospitalEntity(
      id: 'h2',
      name: 'County Hospital',
      location: GeoPoint(latitude: 27.7000, longitude: 85.3333),
      isActive: true,
    ),
  ];

  group('Get All Hospitals Usecase', () {
    test('Should return list of hospitals when fetch succeeds', () async {
      // Arrange
      when(
        () => mockHospitalRepository.getAllHospitals(),
      ).thenAnswer((_) async => const Right(tHospitals));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(tHospitals));
      verify(() => mockHospitalRepository.getAllHospitals()).called(1);
      verifyNoMoreInteractions(mockHospitalRepository);
    });

    test('Should return failure when repository call fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to fetch hospitals');
      when(
        () => mockHospitalRepository.getAllHospitals(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockHospitalRepository.getAllHospitals()).called(1);
      verifyNoMoreInteractions(mockHospitalRepository);
    });
  });
}
