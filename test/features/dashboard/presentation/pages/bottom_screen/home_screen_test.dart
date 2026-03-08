import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen/home_screen.dart';
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:blood_link/features/request/presentation/view_model/request_viewmodel.dart';
import 'package:blood_link/features/user/presentation/state/user_state.dart';
import 'package:blood_link/features/user/presentation/view_model/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeRequestViewmodel extends RequestViewmodel {
  final RequestState initialState;

  FakeRequestViewmodel(this.initialState);

  @override
  RequestState build() => initialState;

  @override
  Future<void> getAllPendingRequests({
    String? search,
    int page = 1,
    int size = 10,
  }) async {}
}

class FakeUserViewmodel extends UserViewmodel {
  @override
  UserState build() => const UserState();

  @override
  Future<void> getCurrentUserProfile() async {}
}

void main() {
  Future<void> pumpHome(
    WidgetTester tester, {
    RequestState requestState = const RequestState(status: RequestStatus.loaded),
  }) async {
    SharedPreferences.setMockInitialValues({
      'user_blood_group_name': 'A+',
      'user_full_name': 'John Doe',
      'user_id': 'u1',
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          requestViewModelProvider.overrideWith(
            () => FakeRequestViewmodel(requestState),
          ),
          userViewmodelProvider.overrideWith(FakeUserViewmodel.new),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('HomeScreen', () {
    testWidgets('should display main quick action labels', (tester) async {
      await pumpHome(tester);

      expect(find.text('Find Donors'), findsOneWidget);
      expect(find.text('Donate Blood'), findsOneWidget);
      expect(find.text('Requests'), findsOneWidget);
    });

    testWidgets('should display status card labels', (tester) async {
      await pumpHome(tester);

      expect(find.text('Blood Group'), findsOneWidget);
      expect(find.text('Donor Status'), findsOneWidget);
      expect(find.text('A+'), findsOneWidget);
    });
  });
}
