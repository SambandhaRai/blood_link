import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/features/auth/domain/entities/auth_entity.dart';
import 'package:blood_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:blood_link/features/auth/domain/usecases/register_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late IAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockAuthRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      AuthEntity(
        fullName: "fallback fullName",
        phoneNumber: "fallback phoneNumber",
        dob: "fallback dob",
        gender: "fallback gender",
        bloodId: "fallback bloodId",
        healthCondition: "fallback healthCondition",
        email: "fallback email",
      ),
    );
  });

  const tFullName = 'Test User';
  const tPhoneNumber = '1234567890';
  const tDob = "2003-03-16";
  const tGender = "Male";
  const tHealthCondition = "None";
  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tConfirmPassword = 'password123';
  const tBloodId = '1';

  group("Register Usecase", () {
    test("Should return true when registration is successful", () async {
      // Arrange
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => Right(true));

      // Act
      final result = await usecase(
        RegisterUsecaseParams(
          fullName: tFullName,
          phoneNumber: tPhoneNumber,
          dob: tDob,
          gender: tGender,
          bloodId: tBloodId,
          healthCondition: tHealthCondition,
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      // Assert
      expect(result, Right(true));

      // Verify
      verify(() => mockAuthRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('Should pass AuthEntity with correct values to repository', () async {
      // Arrange
      AuthEntity? capturedEntity;
      when(() => mockAuthRepository.register(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(const Right(true));
      });

      // Act
      await usecase(
        const RegisterUsecaseParams(
          fullName: tFullName,
          phoneNumber: tPhoneNumber,
          dob: tDob,
          gender: tGender,
          bloodId: tBloodId,
          healthCondition: tHealthCondition,
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      // Assert
      expect(capturedEntity?.fullName, tFullName);
      expect(capturedEntity?.phoneNumber, tPhoneNumber);
      expect(capturedEntity?.dob, tDob);
      expect(capturedEntity?.gender, tGender);
      expect(capturedEntity?.healthCondition, tHealthCondition);
      expect(capturedEntity?.email, tEmail);
      expect(capturedEntity?.password, tPassword);
      expect(capturedEntity?.confirmPassword, tConfirmPassword);
    });

    test('Should handle optional parameters correctly', () async {
      // Arrange
      AuthEntity? capturedEntity;
      when(() => mockAuthRepository.register(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(const Right(true));
      });

      // Act
      await usecase(
        const RegisterUsecaseParams(
          fullName: tFullName,
          phoneNumber: tPhoneNumber,
          dob: tDob,
          gender: tGender,
          bloodId: tBloodId,
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      // Assert
      expect(capturedEntity?.healthCondition, isNull);
    });

    test('Should return failure when registration fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Email already exists');
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const RegisterUsecaseParams(
          fullName: tFullName,
          phoneNumber: tPhoneNumber,
          dob: tDob,
          gender: tGender,
          bloodId: tBloodId,
          healthCondition: tHealthCondition,
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockAuthRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });

  group('Register Usecase Params', () {
    test('Should have correct props with all values', () {
      // Arrange
      const params = RegisterUsecaseParams(
        fullName: tFullName,
        phoneNumber: tPhoneNumber,
        dob: tDob,
        gender: tGender,
        bloodId: tBloodId,
        healthCondition: tHealthCondition,
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
      );

      // Assert
      expect(params.props, [
        tFullName,
        tPhoneNumber,
        tDob,
        tGender,
        tBloodId,
        tHealthCondition,
        tEmail,
        tPassword,
        tConfirmPassword,
      ]);
    });

    test('Should have correct props with optional values as null', () {
      // Arrange
      const params = RegisterUsecaseParams(
        fullName: tFullName,
        phoneNumber: tPhoneNumber,
        dob: tDob,
        gender: tGender,
        bloodId: tBloodId,
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
      );

      // Assert
      expect(params.props, [
        tFullName,
        tPhoneNumber,
        tDob,
        tGender,
        tBloodId,
        null,
        tEmail,
        tPassword,
        tConfirmPassword,
      ]);
    });

    test('two params with same values should be equal', () {
      // Arrange
      const params1 = RegisterUsecaseParams(
        fullName: tFullName,
        phoneNumber: tPhoneNumber,
        dob: tDob,
        gender: tGender,
        bloodId: tBloodId,
        healthCondition: tHealthCondition,
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
      );
      const params2 = RegisterUsecaseParams(
        fullName: tFullName,
        phoneNumber: tPhoneNumber,
        dob: tDob,
        gender: tGender,
        bloodId: tBloodId,
        healthCondition: tHealthCondition,
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
      );

      // Assert
      expect(params1, params2);
    });
  });
}
