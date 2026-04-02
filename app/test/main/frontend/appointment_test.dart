import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

void main() {
  late MockAppointmentSyncService mockSyncService;

  setUp(() {
    mockSyncService = MockAppointmentSyncService();
    when(
      () => mockSyncService.getCachedAppointments(any()),
    ).thenAnswer((_) async => []); // empty so "no appointments" state shows
    when(() => mockSyncService.syncAppointments()).thenAnswer((_) async {});
    when(() => mockSyncService.getCachedClinics()).thenAnswer((_) async => []);
    when(() => mockSyncService.syncClinics()).thenAnswer((_) async {});
    when(
      () => mockSyncService.getCachedServices(any()),
    ).thenAnswer((_) async => []);
    when(() => mockSyncService.syncServices()).thenAnswer((_) async {});
  });

  testWidgets('AppointmentsPage renders correctly', (
    WidgetTester tester,
  ) async {
    await initWidget(
      tester: tester,
      path: AppRoute.appointments,
      mockAppointmentSyncService: mockSyncService,
    );

    expectObj(KBtn.reminderBanner);
    expectObj(KBtn.filterDropdown);
    expectObj(KBtn.addEvent);
    expectObj(KBtn.nearbyServices);
  });

  testWidgets('Tapping Add Event button navigates to AddEventPage', (
    WidgetTester tester,
  ) async {
    await initWidget(
      tester: tester,
      path: AppRoute.appointments,
      mockAppointmentSyncService: mockSyncService,
    );

    await tap(tester, find.byKey(KBtn.addEvent.key));
    expect(find.text('Add New Appointment'), findsOneWidget);
  });

  testWidgets('Filter dropdown changes appointment list', (
    WidgetTester tester,
  ) async {
    await initWidget(
      tester: tester,
      path: AppRoute.appointments,
      mockAppointmentSyncService: mockSyncService,
    );

    await tap(tester, find.byType(DropdownButton<String>));
    await tap(tester, find.text('Today').first);

    expect(find.text('No appointments scheduled for today.'), findsOneWidget);
  });

  testWidgets('Nearby Services button is tappable', (
    WidgetTester tester,
  ) async {
    await initWidget(
      tester: tester,
      path: AppRoute.appointments,
      mockAppointmentSyncService: mockSyncService,
    );

    await tap(tester, find.byKey(KBtn.nearbyServices.key));
    expect(find.text('Nearby Services'), findsOneWidget);
  });
}
