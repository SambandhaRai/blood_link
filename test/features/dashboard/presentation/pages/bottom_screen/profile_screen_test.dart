import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:blood_link/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAuthViewmodel extends AuthViewmodel {
  bool logoutCalled = false;

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }

  @override
  build() => super.build();
}

void main() {
  late FakeAuthViewmodel fakeAuthVm;

  Future<void> pumpProfile(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_full_name', 'John Doe');
    await prefs.setString('user_email', 'john@email.com');
    await prefs.setString('user_profile_picture', '');

    fakeAuthVm = FakeAuthViewmodel();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authViewmodelProvider.overrideWith(() => fakeAuthVm),
        ],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );

    await tester.pumpAndSettle();
  }

  Future<void> scrollToLogoutButton(WidgetTester tester) async {
    final logoutButton = find.byType(ElevatedButton);

    await tester.scrollUntilVisible(
      logoutButton,
      300, // scroll delta
      scrollable: find.byType(Scrollable),
    );

    await tester.pumpAndSettle();
  }

  group('ProfileScreen UI', () {
    testWidgets('should show title, user name, email and logout button', (
      tester,
    ) async {
      await pumpProfile(tester);

      expect(find.text('My Profile'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@email.com'), findsOneWidget);

      expect(find.text('Logout'), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });
  });

  group('ProfileScreen Logout dialog', () {
    testWidgets('should open logout confirmation dialog', (tester) async {
      await pumpProfile(tester);

      await scrollToLogoutButton(tester);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Are you sure you want to logout?'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Logout'), findsOneWidget);
    });

    testWidgets('should call logout when pressing Logout in dialog', (
      tester,
    ) async {
      await pumpProfile(tester);

      await scrollToLogoutButton(tester);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'Logout'));
      await tester.pumpAndSettle();

      expect(fakeAuthVm.logoutCalled, isTrue);
    });

    testWidgets('should close dialog when pressing Cancel', (tester) async {
      await pumpProfile(tester);

      await scrollToLogoutButton(tester);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Are you sure you want to logout?'), findsNothing);
    });
  });
}
