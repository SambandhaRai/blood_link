import 'package:blood_link/core/widgets/my_text_form_field.dart';
import 'package:blood_link/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/login_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/logout_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/register_usecase.dart';
import 'package:blood_link/features/auth/presentation/pages/login_page.dart';
import 'package:blood_link/features/auth/presentation/state/auth_state.dart';
import 'package:blood_link/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock NavigatorObserver to track navigation
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class FakeAuthViewmodel extends AuthViewmodel {
  @override
  AuthState build() => const AuthState();

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<bool> loginWithBiometrics() async => false;
}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockLogoutUsecase mockLogoutUsecase;

  setUpAll(() {
    registerFallbackValue(
      const RegisterUsecaseParams(
        fullName: "fallback fullName",
        phoneNumber: "fallback phoneNumber",
        dob: "fallback dob",
        gender: "fallback gender",
        bloodId: "fallback bloodId",
        healthCondition: "fallback healthCondition",
        email: "fallback email",
        password: "fallback password",
        confirmPassword: "fallback confirmPassword",
      ),
    );
    registerFallbackValue(
      const LoginUsecaseParams(
        email: 'fallback@email.com',
        password: 'fallback',
      ),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        getCurrentUserUsecaseProvider.overrideWithValue(
          mockGetCurrentUserUsecase,
        ),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
        authViewmodelProvider.overrideWith(FakeAuthViewmodel.new),
      ],
      child: const MaterialApp(home: LoginPage()),
    );
  }

  group('LoginPage UI Elements', () {
    testWidgets('should display login button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display two input fields', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(MyTextFormField), findsNWidgets(2));
    });

    testWidgets('should display password visibility icon', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('should display forgot password text', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Forgot Password?'), findsOneWidget);
    });
  });

  group('LoginPage Form Validation', () {
    testWidgets('should show error for empty email', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(MyTextFormField).last, 'password123');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('should show error for invalid email', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byType(MyTextFormField).first,
        'invalidemail',
      );
      await tester.enterText(find.byType(MyTextFormField).last, 'password123');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show error for empty password', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byType(MyTextFormField).first,
        'test@example.com',
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a password'), findsOneWidget);
    });

    testWidgets('should show error for short password', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byType(MyTextFormField).first,
        'test@example.com',
      );
      await tester.enterText(find.byType(MyTextFormField).last, '12345');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('should allow text entry in email field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byType(MyTextFormField).first,
        'test@example.com',
      );
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });
  });
}
