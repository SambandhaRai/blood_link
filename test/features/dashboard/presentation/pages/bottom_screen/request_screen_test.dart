import 'package:blood_link/core/services/location/location_service.dart';
import 'package:blood_link/core/services/sensors/shake/shake_service.dart';
import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen/request_screen.dart';
import 'package:blood_link/features/hospital/presentation/state/hospital_state.dart';
import 'package:blood_link/features/hospital/presentation/view_model/hospital_viewmodel.dart';
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:blood_link/features/request/presentation/view_model/request_viewmodel.dart';
import 'package:blood_link/features/user/presentation/state/user_state.dart';
import 'package:blood_link/features/user/presentation/view_model/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeShakeService extends ShakeService {
  @override
  void startListening({
    required VoidCallback onShake,
    int minimumShakeCount = 1,
    int shakeSlopTimeMS = 600,
    int shakeCountResetTime = 2500,
    double shakeThresholdGravity = 2.2,
  }) {}

  @override
  void stopListening() {}
}

class FakeLocationService extends LocationService {
  FakeLocationService({required super.prefs});

  @override
  Future<LocationResult> requestAndStoreCurrentLocation() async {
    return const LocationResult(
      state: LocationPermissionState.granted,
      location: SavedLocation(lat: 27.7172, lng: 85.3240),
    );
  }
}

class FakeRequestViewmodel extends RequestViewmodel {
  final RequestState initialState;

  FakeRequestViewmodel(this.initialState);

  @override
  RequestState build() => initialState;

  @override
  Future<void> getMatchedRequests({
    required double lng,
    required double lat,
    double km = 5,
    int page = 1,
    int size = 10,
    String? search,
  }) async {}

  @override
  Future<void> getAllPendingRequests({
    String? search,
    int page = 1,
    int size = 10,
  }) async {}

  @override
  Future<void> acceptRequest(String requestId) async {}
}

class FakeHospitalViewmodel extends HospitalViewmodel {
  @override
  HospitalState build() => const HospitalState();

  @override
  Future<void> getAllHospitals() async {}
}

class FakeUserViewmodel extends UserViewmodel {
  @override
  UserState build() => const UserState();

  @override
  Future<void> getCurrentUserProfile() async {}
}

void main() {
  Future<void> pumpRequestScreen(
    WidgetTester tester, {
    RequestState requestState = const RequestState(
      status: RequestStatus.loaded,
      page: 1,
      totalPages: 1,
    ),
  }) async {
    SharedPreferences.setMockInitialValues({
      'user_id': 'u1',
      'user_blood_group_name': 'A+',
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          locationServiceProvider.overrideWithValue(
            FakeLocationService(prefs: prefs),
          ),
          shakeServiceProvider.overrideWithValue(FakeShakeService()),
          requestViewModelProvider.overrideWith(
            () => FakeRequestViewmodel(requestState),
          ),
          hospitalViewModelProvider.overrideWith(FakeHospitalViewmodel.new),
          userViewmodelProvider.overrideWith(FakeUserViewmodel.new),
        ],
        child: const MaterialApp(home: RequestScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('RequestScreen', () {
    testWidgets('should display app bar title and tabs', (tester) async {
      await pumpRequestScreen(tester);

      expect(find.text('Requests'), findsOneWidget);
      expect(find.text('Matched Requests'), findsOneWidget);
      expect(find.text('All Requests'), findsOneWidget);
    });

    testWidgets('should display pagination controls when multiple pages', (
      tester,
    ) async {
      await pumpRequestScreen(
        tester,
        requestState: const RequestState(
          status: RequestStatus.loaded,
          page: 1,
          totalPages: 3,
        ),
      );

      expect(find.text('Previous'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Page 1 / 3'), findsOneWidget);
    });
  });
}
