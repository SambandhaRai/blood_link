import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:blood_link/features/bloodGroup/domain/repositories/blood_repository.dart';
import 'package:blood_link/features/bloodGroup/domain/usecases/get_blood_group_byid_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBloodRepository extends Mock implements IBloodRepository {}

void main() {
  late GetBloodGroupByIdUsecase usecase;
  late IBloodRepository mockBloodRepository;

  setUp(() {
    mockBloodRepository = MockBloodRepository();
    usecase = GetBloodGroupByIdUsecase(bloodRepository: mockBloodRepository);
  });

  setUpAll(() {
    registerFallbackValue(GetBloodGroupByIdParams(bloodId: "fallback"));
  });

  const tBloodId = "1";
  const tBlood = BloodEntity(bloodId: "1", bloodGroup: "A+");

  group("Get Blood By Id", () {
    test("Should return BloodEntity if it is fetch succesfully", () async {
      // Arrange
      when(
        () => mockBloodRepository.getBloodById(tBloodId),
      ).thenAnswer((_) async => Right(tBlood));

      // Act
      final result = await usecase(GetBloodGroupByIdParams(bloodId: tBloodId));

      // Assert
      expect(result, Right(tBlood));

      // Verify
      verify(() => mockBloodRepository.getBloodById(tBloodId)).called(1);
      verifyNoMoreInteractions(mockBloodRepository);
    });

    test("Should return failure when repository call fails", () async {
      // Arrange
      const failure = ApiFailure(message: "Failed to fetch Blood Group");
      when(
        () => mockBloodRepository.getBloodById(tBloodId),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase(GetBloodGroupByIdParams(bloodId: tBloodId));

      // Assert
      expect(result, Left(failure));

      // Verify
      verify(() => mockBloodRepository.getBloodById(tBloodId)).called(1);
      verifyNoMoreInteractions(mockBloodRepository);
    });
  });

  group('Get Blood By Id Params', () {
    test('Should have correct props', () {
      // Arrange
      const params = GetBloodGroupByIdParams(bloodId: tBloodId);

      // Assert
      expect(params.props, [tBloodId]);
    });

    test('Two params with same bloodId should be equal', () {
      // Arrange
      const params1 = GetBloodGroupByIdParams(bloodId: tBloodId);
      const params2 = GetBloodGroupByIdParams(bloodId: tBloodId);

      // Assert
      expect(params1, params2);
    });
  });
}
