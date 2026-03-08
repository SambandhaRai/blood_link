import 'package:blood_link/core/services/location/location_service.dart';
import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:blood_link/features/geo_point/domain/entities/geo_point_entity.dart';
import 'package:blood_link/features/hospital/domain/entities/hospital_entity.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/presentation/pages/ongoing_donation_page.dart';
import 'package:blood_link/features/user/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const tRequest = RequestEntity(
    requestId: 'req-1',
    recipientBloodId: '1',
    recipientBlood: BloodEntity(bloodId: '1', bloodGroup: 'A+'),
    hospitalId: 'h1',
    hospital: HospitalEntity(
      id: 'h1',
      name: 'City Hospital',
      location: GeoPoint(latitude: 27.7172, longitude: 85.3240),
      isActive: true,
    ),
    receiver: UserEntity(
      fullName: 'John Receiver',
      phoneNumber: '9811111111',
      email: 'john@example.com',
    ),
    recipientDetails: 'Need urgent blood',
    recipientCondition: ConditionType.critical,
    requestFor: RequestForType.self,
  );

  Future<void> pumpPage(
    WidgetTester tester, {
    required Future<void> Function(String id) onFinish,
  }) async {
    SharedPreferences.setMockInitialValues({
      'user_latitude': 27.7172,
      'user_longitude': 85.3240,
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          locationServiceProvider.overrideWithValue(LocationService(prefs: prefs)),
        ],
        child: MaterialApp(
          home: OngoingDonationPage(
            request: tRequest,
            personName: 'John Receiver',
            onFinishRequest: onFinish,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('OngoingDonationPage', () {
    testWidgets('should render donation details and finish button', (
      tester,
    ) async {
      await pumpPage(tester, onFinish: (_) async {});

      expect(find.text('Current Donation'), findsOneWidget);
      expect(find.textContaining('John Receiver [A+]'), findsOneWidget);
      expect(find.text("Recipient's Detail:"), findsOneWidget);
      expect(find.text('Need urgent blood'), findsOneWidget);
      expect(find.text('Finish'), findsOneWidget);
    });

    testWidgets('should invoke finish callback when confirmed', (tester) async {
      String? finishedId;
      await pumpPage(tester, onFinish: (id) async => finishedId = id);

      await tester.scrollUntilVisible(
        find.text('Finish'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm Finish'), findsOneWidget);

      await tester.tap(find.text('Yes, Finish'));
      await tester.pumpAndSettle();

      expect(finishedId, 'req-1');
    });
  });
}
