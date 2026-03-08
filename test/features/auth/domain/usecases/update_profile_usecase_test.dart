import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/auth/domain/entities/auth_entity.dart';
import 'package:blood_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:blood_link/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late UpdateProfileUsecase usecase;
  late IAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = UpdateProfileUsecase(authRepository: mockAuthRepository);
  });

  const tUser = AuthEntity(
    fullName: "Test User",
    phoneNumber: "1234567890",
    dob: "2003-03-16",
    gender: "Male",
    bloodId: "1",
    healthCondition: "None",
    email: "test@email.com",
  );

  group('Update Profile Usecase', () {
    test('Should return updated AuthEntity when update is successful', () async {
      // Arrange
      when(
        () => mockAuthRepository.updateUserProfile(tUser),
      ).thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await usecase(const UpdateProfileParams(entity: tUser));

      // Assert
      expect(result, const Right(tUser));
      verify(() => mockAuthRepository.updateUserProfile(tUser)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('Should return failure when update fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Unable to update profile');
      when(
        () => mockAuthRepository.updateUserProfile(tUser),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(const UpdateProfileParams(entity: tUser));

      // Assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.updateUserProfile(tUser)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });

  group('Update Profile Params', () {
    test('Should have correct props', () {
      // Arrange
      const params = UpdateProfileParams(entity: tUser);

      // Assert
      expect(params.props, [tUser]);
    });

    test('Two params with same values should be equal', () {
      // Arrange
      const params1 = UpdateProfileParams(entity: tUser);
      const params2 = UpdateProfileParams(entity: tUser);

      // Assert
      expect(params1, params2);
    });
  });
}
