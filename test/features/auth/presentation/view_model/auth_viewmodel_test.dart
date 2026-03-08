import 'dart:io';

import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/services/sensors/biometric/biometric_service.dart';
import 'package:blood_link/core/services/storage/biometric_shared_prefs.dart';
import 'package:blood_link/core/services/storage/token_service.dart';
import 'package:blood_link/features/auth/domain/entities/auth_entity.dart';
import 'package:blood_link/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/login_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/logout_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/register_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/upload_profile_picture_usecase.dart';
import 'package:blood_link/features/auth/presentation/state/auth_state.dart';
import 'package:blood_link/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockUploadProfilePictureUsecase extends Mock
    implements UploadProfilePictureUsecase {}

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockBiometricService extends Mock implements BiometricService {}

class MockBiometricPrefService extends Mock implements BiometricPrefService {}

class MockTokenService extends Mock implements TokenService {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockUploadProfilePictureUsecase mockUploadProfilePictureUsecase;
  late MockUpdateProfileUsecase mockUpdateProfileUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockBiometricService mockBiometricService;
  late MockBiometricPrefService mockBiometricPrefService;
  late MockTokenService mockTokenService;
  late ProviderContainer container;

  const tUser = AuthEntity(
    fullName: "Test User",
    phoneNumber: "1234567890",
    dob: "2003-03-16",
    gender: "Male",
    bloodId: "1",
    email: "test@email.com",
  );

  setUpAll(() {
    registerFallbackValue(
      const RegisterUsecaseParams(
        fullName: "fallback fullName",
        phoneNumber: "fallback phone",
        dob: "fallback dob",
        gender: "fallback gender",
        bloodId: "1",
        healthCondition: "fallback health",
        email: "fallback@email.com",
        password: "fallback",
        confirmPassword: "fallback",
      ),
    );
    registerFallbackValue(
      const LoginUsecaseParams(email: "fallback@email.com", password: "fallback"),
    );
    registerFallbackValue(const UpdateProfileParams(entity: tUser));
    registerFallbackValue(
      UploadProfilePictureParams(image: File('fallback_profile.jpg')),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockUploadProfilePictureUsecase = MockUploadProfilePictureUsecase();
    mockUpdateProfileUsecase = MockUpdateProfileUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockBiometricService = MockBiometricService();
    mockBiometricPrefService = MockBiometricPrefService();
    mockTokenService = MockTokenService();

    when(() => mockBiometricService.canCheck()).thenAnswer((_) async => false);
    when(() => mockBiometricPrefService.isEnabled()).thenReturn(false);
    when(
      () => mockBiometricPrefService.setEnabled(any()),
    ).thenAnswer((_) async {});
    when(() => mockBiometricService.authenticate()).thenAnswer((_) async => false);
    when(() => mockTokenService.getToken()).thenReturn(null);

    container = ProviderContainer(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
        uploadProfilePictureUsecaseProvider.overrideWithValue(
          mockUploadProfilePictureUsecase,
        ),
        updateProfileUsecaseProvider.overrideWithValue(mockUpdateProfileUsecase),
        getCurrentUserUsecaseProvider.overrideWithValue(
          mockGetCurrentUserUsecase,
        ),
        biometricServiceProvider.overrideWithValue(mockBiometricService),
        biometricPrefServiceProvider.overrideWithValue(mockBiometricPrefService),
        tokenServiceProvider.overrideWithValue(mockTokenService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthViewmodel', () {
    test('should initialize biometric state from services', () async {
      // Arrange
      when(() => mockBiometricService.canCheck()).thenAnswer((_) async => true);
      when(() => mockBiometricPrefService.isEnabled()).thenReturn(true);

      // Act
      container.read(authViewmodelProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      // Assert
      final state = container.read(authViewmodelProvider);
      expect(state.biometricAvailable, true);
      expect(state.biometricEnabled, true);
    });

    test('register should set state to registered when successful', () async {
      // Arrange
      when(() => mockRegisterUsecase(any())).thenAnswer((_) async => const Right(true));
      final notifier = container.read(authViewmodelProvider.notifier);

      // Act
      await notifier.register(
        fullName: 'Test User',
        phoneNumber: '1234567890',
        dob: '2003-03-16',
        gender: 'Male',
        bloodId: '1',
        healthCondition: 'None',
        email: 'test@email.com',
        password: 'password123',
        confirmPassword: 'password123',
      );

      // Assert
      final state = container.read(authViewmodelProvider);
      expect(state.status, AuthStatus.registered);
      expect(state.errorMessage, isNull);
      verify(() => mockRegisterUsecase(any())).called(1);
    });

    test('login should set state to authenticated when successful', () async {
      // Arrange
      when(() => mockLoginUsecase(any())).thenAnswer((_) async => const Right(tUser));
      final notifier = container.read(authViewmodelProvider.notifier);

      // Act
      await notifier.login(email: 'test@email.com', password: 'password123');

      // Assert
      final state = container.read(authViewmodelProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.authEntity, tUser);
      verify(() => mockLoginUsecase(any())).called(1);
    });

    test('logout should set state to unauthenticated when successful', () async {
      // Arrange
      when(() => mockLogoutUsecase()).thenAnswer((_) async => const Right(true));
      final notifier = container.read(authViewmodelProvider.notifier);

      // Act
      await notifier.logout();

      // Assert
      final state = container.read(authViewmodelProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.authEntity, isNull);
      verify(() => mockLogoutUsecase()).called(1);
    });

    test('uploadProfilePicture should set loaded state with image name', () async {
      // Arrange
      final image = File('test/profile.jpg');
      when(
        () => mockUploadProfilePictureUsecase(any()),
      ).thenAnswer((_) async => const Right('profile.jpg'));
      final notifier = container.read(authViewmodelProvider.notifier);

      // Act
      await notifier.uploadProfilePicture(image);

      // Assert
      final state = container.read(authViewmodelProvider);
      expect(state.status, AuthStatus.loaded);
      expect(state.uploadProfilePictureName, 'profile.jpg');
      verify(() => mockUploadProfilePictureUsecase(any())).called(1);
    });

    test('updateProfile should return true and update state on success', () async {
      // Arrange
      when(
        () => mockUpdateProfileUsecase(any()),
      ).thenAnswer((_) async => const Right(tUser));
      final notifier = container.read(authViewmodelProvider.notifier);

      // Act
      final result = await notifier.updateProfile(tUser);

      // Assert
      final state = container.read(authViewmodelProvider);
      expect(result, true);
      expect(state.status, AuthStatus.loaded);
      expect(state.authEntity, tUser);
      verify(() => mockUpdateProfileUsecase(any())).called(1);
    });

    test('getCurrentUser should set error when usecase fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Unauthorized');
      when(
        () => mockGetCurrentUserUsecase(),
      ).thenAnswer((_) async => const Left(failure));
      final notifier = container.read(authViewmodelProvider.notifier);

      // Act
      await notifier.getCurrentUser();

      // Assert
      final state = container.read(authViewmodelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Unauthorized');
      verify(() => mockGetCurrentUserUsecase()).called(1);
    });

    test('setBiometricEnabled should return error when enabling without support', () async {
      // Arrange
      when(() => mockBiometricService.canCheck()).thenAnswer((_) async => false);
      final notifier = container.read(authViewmodelProvider.notifier);

      // Act
      await notifier.setBiometricEnabled(true);

      // Assert
      final state = container.read(authViewmodelProvider);
      expect(state.biometricAvailable, false);
      expect(state.biometricEnabled, false);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Biometrics not available on this device');
      verify(() => mockBiometricPrefService.setEnabled(false)).called(1);
    });

    test('loginWithBiometrics should authenticate user when all checks pass', () async {
      // Arrange
      when(() => mockBiometricService.canCheck()).thenAnswer((_) async => true);
      when(() => mockBiometricPrefService.isEnabled()).thenReturn(true);
      when(() => mockBiometricService.authenticate()).thenAnswer((_) async => true);
      when(() => mockTokenService.getToken()).thenReturn('valid-token');
      when(
        () => mockGetCurrentUserUsecase(),
      ).thenAnswer((_) async => const Right(tUser));

      final notifier = container.read(authViewmodelProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      // Act
      final result = await notifier.loginWithBiometrics();

      // Assert
      final state = container.read(authViewmodelProvider);
      expect(result, true);
      expect(state.status, AuthStatus.authenticated);
      expect(state.authEntity, tUser);
      expect(state.biometricLoading, false);
      verify(() => mockBiometricService.authenticate()).called(1);
      verify(() => mockGetCurrentUserUsecase()).called(1);
    });
  });
}
