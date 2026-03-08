import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/geo_point/domain/entities/geo_point_entity.dart';
import 'package:blood_link/features/hospital/domain/entities/hospital_entity.dart';
import 'package:blood_link/features/hospital/domain/usecases/get_all_hospitals_usecase.dart';
import 'package:blood_link/features/hospital/domain/usecases/get_hospital_by_id_usecase.dart';
import 'package:blood_link/features/hospital/presentation/state/hospital_state.dart';
import 'package:blood_link/features/hospital/presentation/view_model/hospital_viewmodel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllHospitalsUsecase extends Mock implements GetAllHospitalsUsecase {}

class MockGetHospitalByIdUsecase extends Mock implements GetHospitalByIdUsecase {}

void main() {
  late MockGetAllHospitalsUsecase mockGetAllHospitalsUsecase;
  late MockGetHospitalByIdUsecase mockGetHospitalByIdUsecase;
  late ProviderContainer container;

  const tHospital = HospitalEntity(
    id: 'h1',
    name: 'City Hospital',
    location: GeoPoint(latitude: 27.7172, longitude: 85.3240),
    isActive: true,
  );
  const tHospitalId = 'h1';

  setUpAll(() {
    registerFallbackValue(const GetHospitalByIdParams(hospitalId: 'fallback'));
  });

  setUp(() {
    mockGetAllHospitalsUsecase = MockGetAllHospitalsUsecase();
    mockGetHospitalByIdUsecase = MockGetHospitalByIdUsecase();

    container = ProviderContainer(
      overrides: [
        getAllHospitalsUsecaseProvider.overrideWithValue(
          mockGetAllHospitalsUsecase,
        ),
        getHospitalByIdUsecaseProvider.overrideWithValue(
          mockGetHospitalByIdUsecase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('HospitalViewmodel', () {
    test('getAllHospitals should set loaded state when successful', () async {
      // Arrange
      when(
        () => mockGetAllHospitalsUsecase(),
      ).thenAnswer((_) async => const Right([tHospital]));
      final notifier = container.read(hospitalViewModelProvider.notifier);

      // Act
      await notifier.getAllHospitals();

      // Assert
      final state = container.read(hospitalViewModelProvider);
      expect(state.status, HospitalStatus.loaded);
      expect(state.hospitals, const [tHospital]);
      verify(() => mockGetAllHospitalsUsecase()).called(1);
    });

    test('getAllHospitals should set error state on failure', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to load hospitals');
      when(
        () => mockGetAllHospitalsUsecase(),
      ).thenAnswer((_) async => const Left(failure));
      final notifier = container.read(hospitalViewModelProvider.notifier);

      // Act
      await notifier.getAllHospitals();

      // Assert
      final state = container.read(hospitalViewModelProvider);
      expect(state.status, HospitalStatus.error);
      expect(state.errorMessage, 'Failed to load hospitals');
      verify(() => mockGetAllHospitalsUsecase()).called(1);
    });

    test('getHospitalById should set selectedHospital when successful', () async {
      // Arrange
      when(
        () => mockGetHospitalByIdUsecase(any()),
      ).thenAnswer((_) async => const Right(tHospital));
      final notifier = container.read(hospitalViewModelProvider.notifier);

      // Act
      await notifier.getHospitalById(tHospitalId);

      // Assert
      final state = container.read(hospitalViewModelProvider);
      expect(state.status, HospitalStatus.loaded);
      expect(state.selectedHospital, tHospital);
      verify(() => mockGetHospitalByIdUsecase(any())).called(1);
    });
  });
}
