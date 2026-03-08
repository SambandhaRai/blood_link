import 'package:blood_link/features/bloodGroup/domain/entities/blood_entity.dart';
import 'package:blood_link/features/bloodGroup/presentation/state/blood_group_state.dart';
import 'package:blood_link/features/bloodGroup/presentation/view_model/blood_group_viewmodel.dart';
import 'package:blood_link/features/geo_point/domain/entities/geo_point_entity.dart';
import 'package:blood_link/features/hospital/domain/entities/hospital_entity.dart';
import 'package:blood_link/features/hospital/presentation/state/hospital_state.dart';
import 'package:blood_link/features/hospital/presentation/view_model/hospital_viewmodel.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/presentation/pages/edit_request_page.dart';
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:blood_link/features/request/presentation/view_model/request_viewmodel.dart';
import 'package:blood_link/features/request/domain/entities/create_request_entity.dart'
    as cre;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRequestViewmodel extends RequestViewmodel {
  @override
  RequestState build() => const RequestState(status: RequestStatus.loaded);

  @override
  Future<void> updateRequest({
    required String requestId,
    required String recipientBloodId,
    required String recipientDetails,
    required cre.ConditionType recipientCondition,
    required String hospitalId,
    cre.RequestForType requestFor = cre.RequestForType.self,
    String? relationToPatient,
    String? patientName,
    String? patientPhone,
  }) async {}
}

class FakeHospitalViewmodel extends HospitalViewmodel {
  @override
  HospitalState build() => const HospitalState(
    status: HospitalStatus.loaded,
    hospitals: [
      HospitalEntity(
        id: 'h1',
        name: 'City Hospital',
        location: GeoPoint(latitude: 27.7172, longitude: 85.3240),
        isActive: true,
      ),
    ],
  );

  @override
  Future<void> getAllHospitals() async {}
}

class FakeBloodGroupViewmodel extends BloodGroupViewmodel {
  @override
  BloodGroupState build() => const BloodGroupState(
    status: BloodGroupStatus.loaded,
    bloodGroups: [BloodEntity(bloodId: '1', bloodGroup: 'A+')],
  );

  @override
  Future<void> getAllBloodGroups() async {}
}

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
    recipientDetails: 'Need urgent blood',
    recipientCondition: ConditionType.critical,
    requestFor: RequestForType.self,
  );

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          requestViewModelProvider.overrideWith(FakeRequestViewmodel.new),
          hospitalViewModelProvider.overrideWith(FakeHospitalViewmodel.new),
          bloodGroupViewModelProvider.overrideWith(FakeBloodGroupViewmodel.new),
        ],
        child: const MaterialApp(home: EditRequestPage(request: tRequest)),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('EditRequestPage', () {
    testWidgets('should render title and update action', (tester) async {
      await pumpPage(tester);

      expect(find.text('Edit Request'), findsOneWidget);
      expect(find.text('For Myself'), findsOneWidget);
      expect(find.text('For Others'), findsOneWidget);
      expect(find.text('Update Request'), findsOneWidget);
    });

    testWidgets('should prefill recipient details from request', (tester) async {
      await pumpPage(tester);

      expect(find.text('Need urgent blood'), findsOneWidget);
    });
  });
}
