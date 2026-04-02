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
    when(() => mockSyncService.getCachedAppointments(any()))
        .thenAnswer((_) async => [testAppointment]);
    when(() => mockSyncService.syncAppointments())
        .thenAnswer((_) async {});
    when(() => mockSyncService.getCachedClinics())
        .thenAnswer((_) async => []);
    when(() => mockSyncService.syncClinics())
        .thenAnswer((_) async {});
    when(() => mockSyncService.getCachedServices(any()))
        .thenAnswer((_) async => []);
    when(() => mockSyncService.syncServices())
        .thenAnswer((_) async {});
  });

  // EditEvents requires an Appointment object passed via navigation state,
  // so we navigate to appointments first, then tap edit on the appointment card
  testWidgets('EditEvents page renders correctly', (WidgetTester tester) async {
    // Provide an appointment in cache so the card shows up
    when(() => mockSyncService.getCachedAppointments(any()))
        .thenAnswer((_) async => [testAppointment]);

    await initWidget(
      tester: tester,
      path: AppRoute.appointments,
      mockAppointmentSyncService: mockSyncService,
    );

    // Tap edit icon on the appointment card to navigate to EditEvents
    await tap(tester, find.byIcon(Icons.edit_outlined));

    expect(find.text('Edit Appointment'), findsOneWidget);
    expectObj(KBtn.savebutton);
    expectObj(KBtn.deletebutton);
    expectObj(KBtn.cancelbutton);
  });

 testWidgets('Save button is tappable', (WidgetTester tester) async {
  when(() => mockSyncService.getCachedAppointments(any()))
      .thenAnswer((_) async => [testAppointment]);

  await initWidget(
    tester: tester,
    path: AppRoute.appointments,
    mockAppointmentSyncService: mockSyncService,
  );

  await tap(tester, find.byIcon(Icons.edit_outlined));

  // Stays on edit page after tapping save (no crash)
  expectObj(KBtn.savebutton);
  await tap(tester, find.byKey(KBtn.savebutton.key));
  expectObj(KBtn.savebutton); // still on page
});

testWidgets('Delete button shows confirmation dialog', (WidgetTester tester) async {
  when(() => mockSyncService.getCachedAppointments(any()))
      .thenAnswer((_) async => [testAppointment]);

  await initWidget(
    tester: tester,
    path: AppRoute.appointments,
    mockAppointmentSyncService: mockSyncService,
  );

  await tap(tester, find.byIcon(Icons.edit_outlined));
  
  // Scroll delete button into view first
  await tester.ensureVisible(find.byKey(KBtn.deletebutton.key));
  await tester.pumpAndSettle();
  await tap(tester, find.byKey(KBtn.deletebutton.key));

  expect(find.byType(AlertDialog), findsOneWidget);
  expect(find.text('Delete Appointment'), findsWidgets);
  expect(find.text('Cancel'), findsWidgets);
  expect(find.text('Delete'), findsWidgets);
});

testWidgets('Cancel button on delete dialog dismisses it', (WidgetTester tester) async {
  when(() => mockSyncService.getCachedAppointments(any()))
      .thenAnswer((_) async => [testAppointment]);

  await initWidget(
    tester: tester,
    path: AppRoute.appointments,
    mockAppointmentSyncService: mockSyncService,
  );

  await tap(tester, find.byIcon(Icons.edit_outlined));

  await tester.ensureVisible(find.byKey(KBtn.deletebutton.key));
  await tester.pumpAndSettle();
  await tap(tester, find.byKey(KBtn.deletebutton.key));

  // Tap Cancel in the dialog
  await tap(tester, find.text('Cancel').last); // .last to avoid matching AppBar back
  expect(find.text('Edit Appointment'), findsOneWidget);
});

testWidgets('Cancel button navigates back', (WidgetTester tester) async {
  when(() => mockSyncService.getCachedAppointments(any()))
      .thenAnswer((_) async => [testAppointment]);

  final container = await initWidget(
    tester: tester,
    path: AppRoute.appointments,
    mockAppointmentSyncService: mockSyncService,
  );

  await tap(tester, find.byIcon(Icons.edit_outlined));

  await tester.ensureVisible(find.byKey(KBtn.cancelbutton.key));
  await tester.pumpAndSettle();
  await tap(tester, find.byKey(KBtn.cancelbutton.key));

  expectPath(container, AppRoute.appointments);
});
}