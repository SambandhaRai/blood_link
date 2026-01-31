import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:blood_link/features/bloodGroup/domain/repositories/blood_repository.dart';
import 'package:blood_link/features/bloodGroup/domain/usecases/create_blood_group_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBloodRepository extends Mock implements IBloodRepository {}

void main() {
  late CreateBloodGroupUsecase usecase;
  late MockBloodRepository mockBloodRepository;

  setUp(() {
    mockBloodRepository = MockBloodRepository();
    usecase = CreateBloodGroupUsecase(bloodRepostory: mockBloodRepository);
  });

  setUpAll(() {
    registerFallbackValue(const BloodEntity(bloodGroup: "fallback"));
  });

  const tBloodGroup = "New Blood Group";

  group("Create Blood Group Usecase", () {
    test(
      "Should return true when Blood Group is created successfully",
      () async {
        // Arrange
        when(
          () => mockBloodRepository.createBloodGroup(any()),
        ).thenAnswer((_) async => Right(true));

        // Act
        final result = await usecase(
          CreateBloodGroupParams(bloodGroup: tBloodGroup),
        );

        // Assert
        expect(result, Right(true));

        // Verify
        verify(() => mockBloodRepository.createBloodGroup(any())).called(1);
        verifyNoMoreInteractions(mockBloodRepository);
      },
    );

    test(
      "Should pass BloodEntity with correct bloodGroup to repository",
      () async {
        BloodEntity? capturedEntity;

        // Arrange
        when(() => mockBloodRepository.createBloodGroup(any())).thenAnswer((
          invocation,
        ) {
          capturedEntity = invocation.positionalArguments[0] as BloodEntity;
          return Future.value(Right(true));
        });

        // Act
        await usecase(CreateBloodGroupParams(bloodGroup: tBloodGroup));

        // Assert
        expect(capturedEntity?.bloodGroup, tBloodGroup);
        expect(capturedEntity?.bloodId, null);
      },
    );

    test("Should return failure when repository call fails", () async {
      // Arrange
      const failure = ApiFailure(message: "Failed to create Blood Group");
      when(
        () => mockBloodRepository.createBloodGroup(any()),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase(
        CreateBloodGroupParams(bloodGroup: tBloodGroup),
      );

      // Assert
      expect(result, Left(failure));

      // Verify
      verify(() => mockBloodRepository.createBloodGroup(any())).called(1);
      verifyNoMoreInteractions(mockBloodRepository);
    });
  });

  group("Create Blood Group Params", () {
    test("Should have correct params", () async {
      // Arrange
      const params = CreateBloodGroupParams(bloodGroup: tBloodGroup);

      // Assert
      expect(params.props, [tBloodGroup]);
    });

    test("Two params with same Blood Group should be equal", () {
      // Arrange
      const params1 = CreateBloodGroupParams(bloodGroup: tBloodGroup);
      const params2 = CreateBloodGroupParams(bloodGroup: tBloodGroup);

      // Assert
      expect(params1, params2);
    });
  });
}
