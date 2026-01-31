import 'package:blood_link/core/widgets/my_text_form_field.dart';
import 'package:blood_link/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/login_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/logout_usecase.dart';
import 'package:blood_link/features/auth/domain/usecases/register_usecase.dart';
import 'package:blood_link/features/auth/presentation/pages/signup_page.dart';
import 'package:blood_link/features/auth/presentation/state/auth_state.dart';
import 'package:blood_link/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:blood_link/features/bloodGroup/presentation/state/blood_group_state.dart';
import 'package:blood_link/features/bloodGroup/presentation/view_model/blood_group_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class FakeBloodGroupViewmodel extends BloodGroupViewmodel {
  @override
  BloodGroupState build() => const BloodGroupState();

  @override
  Future<void> getAllBloodGroups() async {
    state = state.copyWith(
      status: BloodGroupStatus.loaded,
      bloodGroups: const [],
    );
  }

  @override
  Future<void> getBloodGroupById(String bloodId) async {}

  @override
  Future<void> createBloodGroup(String bloodGroup) async {}
}

class FakeAuthViewmodel extends AuthViewmodel {
  @override
  AuthState build() => const AuthState();

  @override
  Future<void> register({
    required String fullName,
    required String phoneNumber,
    required String dob,
    required String gender,
    String? bloodId,
    String? healthCondition,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {}
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

  Finder dropdownFinder() =>
      find.byWidgetPredicate((w) => w is DropdownButtonFormField);

  Future<void> pumpSignUp(WidgetTester tester) async {
    final view = tester.view;
    view.physicalSize = const Size(1200, 2400);
    view.devicePixelRatio = 1.0;

    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });

    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final msg = details.exceptionAsString();
      if (msg.contains('A RenderFlex overflowed by') ||
          msg.contains('RenderFlex') && msg.contains('OVERFLOWING')) {
        return;
      }
      oldOnError!(details);
    };

    addTearDown(() {
      FlutterError.onError = oldOnError;
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
          loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
          getCurrentUserUsecaseProvider.overrideWithValue(
            mockGetCurrentUserUsecase,
          ),
          logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),

          bloodGroupViewModelProvider.overrideWith(FakeBloodGroupViewmodel.new),
          authViewmodelProvider.overrideWith(FakeAuthViewmodel.new),
        ],
        child: const MaterialApp(home: Scaffold(body: SignUpPage())),
      ),
    );

    await tester.pumpAndSettle();
  }

  group('SignUpPage UI Elements', () {
    testWidgets('should display sign up button', (tester) async {
      await pumpSignUp(tester);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display multiple input fields', (tester) async {
      await pumpSignUp(tester);
      expect(find.byType(MyTextFormField), findsWidgets);
    });

    testWidgets('should display password visibility icons', (tester) async {
      await pumpSignUp(tester);
      expect(find.byIcon(Icons.visibility_off), findsWidgets);
    });

    testWidgets('should display gender dropdown', (tester) async {
      await pumpSignUp(tester);
      expect(dropdownFinder(), findsWidgets);
    });

    testWidgets('should display back button', (tester) async {
      await pumpSignUp(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });

  group('SignUpPage Form Validation', () {
    testWidgets('should show error for empty full name', (tester) async {
      await pumpSignUp(tester);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Full name is required'), findsOneWidget);
    });

    testWidgets('should show error for empty phone number', (tester) async {
      await pumpSignUp(tester);

      await tester.enterText(find.byType(MyTextFormField).at(0), 'John Doe');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Phone number is required'), findsOneWidget);
    });

    testWidgets('should allow text entry in full name field', (tester) async {
      await pumpSignUp(tester);

      await tester.enterText(find.byType(MyTextFormField).at(0), 'John Doe');
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
    });
  });
}
