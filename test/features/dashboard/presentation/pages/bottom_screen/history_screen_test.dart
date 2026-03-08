import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen/history_screen.dart';
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:blood_link/features/request/presentation/view_model/request_viewmodel.dart';
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
  Future<void> getMyHistory() async {}

  @override
  Future<void> finishRequest(String requestId) async {}
}

void main() {
  Future<void> pumpHistory(
    WidgetTester tester, {
    RequestState requestState = const RequestState(status: RequestStatus.loaded),
  }) async {
    SharedPreferences.setMockInitialValues({'user_id': 'u1'});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          requestViewModelProvider.overrideWith(
            () => FakeRequestViewmodel(requestState),
          ),
        ],
        child: const MaterialApp(home: HistoryScreen()),
      ),
    );

    await tester.pumpAndSettle();
  }

  group('HistoryScreen', () {
    testWidgets('should display title and tabs', (tester) async {
      await pumpHistory(tester);

      expect(find.text('History'), findsOneWidget);
      expect(find.text('Ongoing'), findsOneWidget);
      expect(find.text('Received'), findsOneWidget);
      expect(find.text('Donated'), findsOneWidget);
    });

    testWidgets('should show empty state title for ongoing tab', (tester) async {
      await pumpHistory(tester);

      expect(find.text('No ongoing requests.'), findsOneWidget);
    });
  });
}
