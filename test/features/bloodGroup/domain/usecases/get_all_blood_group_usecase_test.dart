import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:blood_link/features/bloodGroup/domain/repositories/blood_repository.dart';
import 'package:blood_link/features/bloodGroup/domain/usecases/get_all_blood_group_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBloodRepository extends Mock implements IBloodRepository {}

void main() {
  late GetAllBloodGroupUsecase usecase;
  late IBloodRepository mockBloodRepository;

  setUp(() {
    mockBloodRepository = MockBloodRepository();
    usecase = GetAllBloodGroupUsecase(bloodRepository: mockBloodRepository);
  });

  final tBloodGroups = [
    const BloodEntity(bloodId: "1", bloodGroup: "A+"),
    const BloodEntity(bloodId: "2", bloodGroup: "A-"),
    const BloodEntity(bloodId: "3", bloodGroup: "B+"),
    const BloodEntity(bloodId: "4", bloodGroup: "B-"),
  ];

  group("Get All Blood Usecase", () {
    test(
      "Should return List of Blood Group if it is fetched successfully ",
      () async {
        // Arrange
        when(
          () => mockBloodRepository.getAllBloodGroup(),
        ).thenAnswer((_) async => Right(tBloodGroups));

        // Act
        final result = await usecase();

        // Assert
        expect(result, Right(tBloodGroups));

        // Verify
        verify(() => mockBloodRepository.getAllBloodGroup()).called(1);
        verifyNoMoreInteractions(mockBloodRepository);
      },
    );

    test("Should return failure when repository call fails", () async {
      // Arrange
      const failure = ApiFailure(message: "Failed to fetch Blood Groups");
      when(
        () => mockBloodRepository.getAllBloodGroup(),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Left(failure));

      // Verify
      verify(() => mockBloodRepository.getAllBloodGroup()).called(1);
      verifyNoMoreInteractions(mockBloodRepository);
    });

    test("Should return empty list when no Blood Groups exists", () async {
      // Arrange
      when(
        () => mockBloodRepository.getAllBloodGroup(),
      ).thenAnswer((_) async => const Right([]));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(<BloodEntity>[]));

      // Verify
      verify(() => mockBloodRepository.getAllBloodGroup()).called(1);
    });
  });
}
