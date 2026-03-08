import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/auth/domain/entities/auth_entity.dart';
import 'package:blood_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:blood_link/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late GetCurrentUserUsecase usecase;
  late IAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetCurrentUserUsecase(authRepository: mockAuthRepository);
  });

  const tUser = AuthEntity(
    fullName: "Test User",
    phoneNumber: "1234567890",
    dob: "2003-03-16",
    gender: "Male",
    bloodId: "1",
    email: "test@email.com",
  );

  group('Get Current User Usecase', () {
    test('Should return AuthEntity when current user fetch is successful', () async {
      // Arrange
      when(
        () => mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(tUser));
      verify(() => mockAuthRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('Should return failure when current user fetch fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'User not found');
      when(
        () => mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
