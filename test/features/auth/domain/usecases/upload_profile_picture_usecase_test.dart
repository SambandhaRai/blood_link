import 'dart:io';

import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:blood_link/features/auth/domain/usecases/upload_profile_picture_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late UploadProfilePictureUsecase usecase;
  late IAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = UploadProfilePictureUsecase(authRepository: mockAuthRepository);
  });

  final tImage = File('test/features/auth/domain/usecases/fake_profile_image.jpg');
  const tImageUrl = 'https://example.com/profile.jpg';

  group('Upload Profile Picture Usecase', () {
    test('Should return image url when upload is successful', () async {
      // Arrange
      when(
        () => mockAuthRepository.uploadProfilePicture(tImage),
      ).thenAnswer((_) async => const Right(tImageUrl));

      // Act
      final result = await usecase(
        UploadProfilePictureParams(image: tImage),
      );

      // Assert
      expect(result, const Right(tImageUrl));
      verify(() => mockAuthRepository.uploadProfilePicture(tImage)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('Should return null url when upload succeeds with null response', () async {
      // Arrange
      when(
        () => mockAuthRepository.uploadProfilePicture(tImage),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase(
        UploadProfilePictureParams(image: tImage),
      );

      // Assert
      expect(result, const Right<String?, String?>(null));
      verify(() => mockAuthRepository.uploadProfilePicture(tImage)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('Should return failure when upload fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Upload failed');
      when(
        () => mockAuthRepository.uploadProfilePicture(tImage),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        UploadProfilePictureParams(image: tImage),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.uploadProfilePicture(tImage)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });

  group('Upload Profile Picture Params', () {
    test('Should have correct props', () {
      // Arrange
      final params = UploadProfilePictureParams(image: tImage);

      // Assert
      expect(params.props, [tImage]);
    });

    test('Two params with same values should be equal', () {
      // Arrange
      final params1 = UploadProfilePictureParams(image: tImage);
      final params2 = UploadProfilePictureParams(image: tImage);

      // Assert
      expect(params1, params2);
    });
  });
}
