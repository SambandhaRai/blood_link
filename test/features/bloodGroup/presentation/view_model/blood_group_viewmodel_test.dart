import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:blood_link/features/bloodGroup/domain/usecases/create_blood_group_usecase.dart';
import 'package:blood_link/features/bloodGroup/domain/usecases/get_all_blood_group_usecase.dart';
import 'package:blood_link/features/bloodGroup/domain/usecases/get_blood_group_byid_usecase.dart';
import 'package:blood_link/features/bloodGroup/presentation/state/blood_group_state.dart';
import 'package:blood_link/features/bloodGroup/presentation/view_model/blood_group_viewmodel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllBloodGroupUsecase extends Mock implements GetAllBloodGroupUsecase {}

class MockCreateBloodGroupUsecase extends Mock implements CreateBloodGroupUsecase {}

class MockGetBloodGroupByIdUsecase extends Mock
    implements GetBloodGroupByIdUsecase {}

void main() {
  late MockGetAllBloodGroupUsecase mockGetAllBloodGroupUsecase;
  late MockCreateBloodGroupUsecase mockCreateBloodGroupUsecase;
  late MockGetBloodGroupByIdUsecase mockGetBloodGroupByIdUsecase;
  late ProviderContainer container;

  const tBlood = BloodEntity(bloodId: '1', bloodGroup: 'A+');
  const tBloodId = '1';
  const tNewBloodGroup = 'AB+';
  final tBloodGroups = [tBlood, const BloodEntity(bloodId: '2', bloodGroup: 'B+')];

  setUpAll(() {
    registerFallbackValue(const CreateBloodGroupParams(bloodGroup: 'fallback'));
    registerFallbackValue(const GetBloodGroupByIdParams(bloodId: 'fallback'));
  });

  setUp(() {
    mockGetAllBloodGroupUsecase = MockGetAllBloodGroupUsecase();
    mockCreateBloodGroupUsecase = MockCreateBloodGroupUsecase();
    mockGetBloodGroupByIdUsecase = MockGetBloodGroupByIdUsecase();

    container = ProviderContainer(
      overrides: [
        getAllBloodGroupUsecaseProvider.overrideWithValue(
          mockGetAllBloodGroupUsecase,
        ),
        createBloodGroupUsecaseProvider.overrideWithValue(
          mockCreateBloodGroupUsecase,
        ),
        getBloodGroupByIdUsecaseProvider.overrideWithValue(
          mockGetBloodGroupByIdUsecase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('BloodGroupViewmodel', () {
    test('getAllBloodGroups should set loaded state when successful', () async {
      // Arrange
      when(() => mockGetAllBloodGroupUsecase()).thenAnswer(
        (_) async => Right(tBloodGroups),
      );
      final notifier = container.read(bloodGroupViewModelProvider.notifier);

      // Act
      await notifier.getAllBloodGroups();

      // Assert
      final state = container.read(bloodGroupViewModelProvider);
      expect(state.status, BloodGroupStatus.loaded);
      expect(state.bloodGroups, tBloodGroups);
      verify(() => mockGetAllBloodGroupUsecase()).called(1);
    });

    test('getAllBloodGroups should set error state on failure', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to fetch Blood Groups');
      when(
        () => mockGetAllBloodGroupUsecase(),
      ).thenAnswer((_) async => const Left(failure));
      final notifier = container.read(bloodGroupViewModelProvider.notifier);

      // Act
      await notifier.getAllBloodGroups();

      // Assert
      final state = container.read(bloodGroupViewModelProvider);
      expect(state.status, BloodGroupStatus.error);
      expect(state.errorMessage, 'Failed to fetch Blood Groups');
      verify(() => mockGetAllBloodGroupUsecase()).called(1);
    });

    test('getBloodGroupById should set selected blood group when successful', () async {
      // Arrange
      when(() => mockGetBloodGroupByIdUsecase(any())).thenAnswer(
        (_) async => const Right(tBlood),
      );
      final notifier = container.read(bloodGroupViewModelProvider.notifier);

      // Act
      await notifier.getBloodGroupById(tBloodId);

      // Assert
      final state = container.read(bloodGroupViewModelProvider);
      expect(state.status, BloodGroupStatus.loaded);
      expect(state.selectedBloodGroup, tBlood);
      verify(() => mockGetBloodGroupByIdUsecase(any())).called(1);
    });

    test('createBloodGroup should set error state when create fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to create Blood Group');
      when(
        () => mockCreateBloodGroupUsecase(any()),
      ).thenAnswer((_) async => const Left(failure));
      final notifier = container.read(bloodGroupViewModelProvider.notifier);

      // Act
      await notifier.createBloodGroup(tNewBloodGroup);

      // Assert
      final state = container.read(bloodGroupViewModelProvider);
      expect(state.status, BloodGroupStatus.error);
      expect(state.errorMessage, 'Failed to create Blood Group');
      verify(() => mockCreateBloodGroupUsecase(any())).called(1);
      verifyNever(() => mockGetAllBloodGroupUsecase());
    });

    test('createBloodGroup should refresh list after successful creation', () async {
      // Arrange
      when(
        () => mockCreateBloodGroupUsecase(any()),
      ).thenAnswer((_) async => const Right(true));
      when(() => mockGetAllBloodGroupUsecase()).thenAnswer(
        (_) async => Right(tBloodGroups),
      );
      final notifier = container.read(bloodGroupViewModelProvider.notifier);

      // Act
      await notifier.createBloodGroup(tNewBloodGroup);
      await Future<void>.delayed(Duration.zero);

      // Assert
      final state = container.read(bloodGroupViewModelProvider);
      expect(state.status, BloodGroupStatus.loaded);
      expect(state.bloodGroups, tBloodGroups);
      verify(() => mockCreateBloodGroupUsecase(any())).called(1);
      verify(() => mockGetAllBloodGroupUsecase()).called(1);
    });
  });
}
