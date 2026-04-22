import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/appointments/appointment_sync.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/navigation/nav_router.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

void main() {
  late MockAppointmentSyncService mockSyncService;

  final startTime = DateTime(2026, 11, 9, 10, 0);
  final endTime = DateTime(2026, 11, 9, 10, 30);

  setUp(() {
    mockSyncService = MockAppointmentSyncService();

    // ── Default stubs required by createAppointment ──────────────────────
    // checkForConflict must be stubbed — it runs BEFORE insertGuestAppointment
    when(
      () => mockSyncService.checkForConflict(
        clinicId: any(named: 'clinicId'),
        startTime: any(named: 'startTime'),
        endTime: any(named: 'endTime'),
        excludeAppointmentId: any(named: 'excludeAppointmentId'),
      ),
    ).thenAnswer((_) async => false); // no conflict by default

    when(
      () => mockSyncService.insertGuestAppointment(
        clinicId: any(named: 'clinicId'),
        serviceId: any(named: 'serviceId'),
        startTime: any(named: 'startTime'),
        endTime: any(named: 'endTime'),
        notes: any(named: 'notes'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => mockSyncService.getCachedAppointments(any()),
    ).thenAnswer((_) async => [testAppointment]);

    when(() => mockSyncService.syncAppointments()).thenAnswer((_) async {});

    when(() => mockSyncService.getCachedClinics()).thenAnswer((_) async => []);
    when(() => mockSyncService.syncClinics()).thenAnswer((_) async {});
    when(
      () => mockSyncService.getCachedServices(any()),
    ).thenAnswer((_) async => []);
    when(() => mockSyncService.syncServices()).thenAnswer((_) async {});
  });

  // ─── CreateAppointment — guest user ──────────────────────────────────────

  group('CreateAppointment — guest user', () {
    test('inserts into local Drift when user is not logged in', () async {
      final container = getContainer(
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
        asRegisteredUser: false,
      );

      final creator = container.read(createAppointmentProvider);
      final result = await creator.createAppointment(
        userId: '',
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: startTime,
        endTime: endTime,
        notes: 'Test notes',
      );

      result.when(
        success: (_) => expect(true, true),
        failure: (e) => fail('Expected success but got: $e'),
      );

      verify(
        () => mockSyncService.insertGuestAppointment(
          clinicId: testClinicId,
          serviceId: testServiceId,
          startTime: startTime,
          endTime: endTime,
          notes: 'Test notes',
        ),
      ).called(1);
    });

    test('returns failure when insertGuestAppointment throws', () async {
      when(
        () => mockSyncService.insertGuestAppointment(
          clinicId: any(named: 'clinicId'),
          serviceId: any(named: 'serviceId'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
          notes: any(named: 'notes'),
        ),
      ).thenThrow(Exception('DB error'));

      final container = getContainer(
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
        asRegisteredUser: false,
      );

      final creator = container.read(createAppointmentProvider);
      final result = await creator.createAppointment(
        userId: '',
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: startTime,
        endTime: endTime,
      );

      result.when(
        success: (_) => fail('Expected failure'),
        failure: (e) => expect(e, contains('DB error')),
      );
    });

    test('returns failure when a time conflict exists', () async {
      // Override: conflict detected
      when(
        () => mockSyncService.checkForConflict(
          clinicId: any(named: 'clinicId'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
          excludeAppointmentId: any(named: 'excludeAppointmentId'),
        ),
      ).thenAnswer((_) async => true);

      final container = getContainer(
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
        asRegisteredUser: false,
      );

      final creator = container.read(createAppointmentProvider);
      final result = await creator.createAppointment(
        userId: '',
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: startTime,
        endTime: endTime,
      );

      result.when(
        success: (_) => fail('Expected failure due to conflict'),
        failure: (e) => expect(e, contains('already booked')),
      );

      // insertGuestAppointment must NOT be called when there is a conflict
      verifyNever(
        () => mockSyncService.insertGuestAppointment(
          clinicId: any(named: 'clinicId'),
          serviceId: any(named: 'serviceId'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
          notes: any(named: 'notes'),
        ),
      );
    });

    test('passes notes as null when notes string is empty', () async {
      final container = getContainer(
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
        asRegisteredUser: false,
      );

      final creator = container.read(createAppointmentProvider);
      await creator.createAppointment(
        userId: '',
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: startTime,
        endTime: endTime,
        notes: null,
      );

      verify(
        () => mockSyncService.insertGuestAppointment(
          clinicId: testClinicId,
          serviceId: testServiceId,
          startTime: startTime,
          endTime: endTime,
          notes: null,
        ),
      ).called(1);
    });
  });

  // ─── userAppointmentsProvider ─────────────────────────────────────────────

  group('userAppointmentsProvider — guest user', () {
    test('returns cached appointments for guest', () async {
      final container = getContainer(
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
        asRegisteredUser: false,
      );

      await container.pump();

      final appointments = await container.read(
        userAppointmentsProvider.future,
      );

      expect(appointments.length, 1);
      expect(appointments.first.id, testAppointmentId);
      verify(() => mockSyncService.getCachedAppointments(any())).called(1);
    });

    test('returns empty list when no cached appointments', () async {
      when(
        () => mockSyncService.getCachedAppointments(any()),
      ).thenAnswer((_) async => []);

      final container = getContainer(
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
        asRegisteredUser: false,
      );

      final appointments = await container.read(
        userAppointmentsProvider.future,
      );
      expect(appointments.isEmpty, true);
    });

    test('does not call syncAppointments for guest', () async {
      final container = getContainer(
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
        asRegisteredUser: false,
      );

      await container.pump();
      await container.read(userAppointmentsProvider.future);

      verifyNever(() => mockSyncService.syncAppointments());
    });
  });

  group('userAppointmentsProvider — registered user', () {
    test('returns appointments from sync service for registered user',
        () async {
      final container = getContainer(
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
        asRegisteredUser: true,
      );

      await container.pump();

      final appointments = await container.read(
        userAppointmentsProvider.future,
      );

      expect(appointments.length, 1);
      expect(appointments.first.id, testAppointmentId);
    });


    test('falls back to cached data when sync throws', () async {
      when(
        () => mockSyncService.syncAppointments(),
      ).thenThrow(Exception('Network error'));

      final container = getContainer(
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
        asRegisteredUser: true,
      );

      await container.pump();

      // Should not throw — returns cached fallback
      final appointments = await container.read(
        userAppointmentsProvider.future,
      );

      expect(appointments.length, 1);
      expect(appointments.first.id, testAppointmentId);
    });
  });

  // ─── AddEventPage — widget tests ─────────────────────────────────────────

  group('AddEventPage — renders correctly', () {
    testWidgets('shows Add New Appointment in the AppBar', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );

      expect(find.text('Add New Appointment'), findsOneWidget);
    });

    testWidgets('shows Add Appointment and Cancel buttons', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );

      expect(find.byKey(KBtn.eventaddbutton.key), findsOneWidget);
      expect(find.byKey(KBtn.cancelbutton.key), findsOneWidget);
    });

    testWidgets('shows clinic dropdown', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );

      expect(find.byKey(KBtn.clinicDropdown.key), findsOneWidget);
    });

    testWidgets('date and time pickers are present', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );

      expect(find.byKey(KBtn.datePicker.key), findsOneWidget);
      expect(find.byKey(KBtn.timePicker.key), findsOneWidget);
    });
  });

  group('AddEventPage — Add button validation', () {
    testWidgets(
        'tapping Add with no fields filled shows "Please fill in all required fields"',
        (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );

      await tap(tester, find.byKey(KBtn.eventaddbutton.key));

      expect(
        find.textContaining('Please fill in all required fields'),
        findsOneWidget,
      );
    });

    testWidgets('stays on Add page after failed validation', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );

      await tap(tester, find.byKey(KBtn.eventaddbutton.key));

      expect(find.text('Add New Appointment'), findsOneWidget);
    });
  });

  group('AddEventPage — Notes field', () {
    testWidgets('can type into notes field', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );

      await tester.scrollUntilVisible(
        find.byKey(KBtn.notesField.key),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.byKey(KBtn.notesField.key), 'My notes');
      await tester.pump();

      expect(find.text('My notes'), findsOneWidget);
    });
  });

  group('AddEventPage — Date and Time pickers', () {
    testWidgets('tapping date picker opens DatePickerDialog', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );

      await tap(tester, find.byKey(KBtn.datePicker.key));

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('tapping time picker opens TimePickerDialog', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );

      await tap(tester, find.byKey(KBtn.timePicker.key));

      expect(find.byType(TimePickerDialog), findsOneWidget);
    });

    testWidgets('dismissing date picker leaves date field empty',
        (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );

      await tap(tester, find.byKey(KBtn.datePicker.key));
      // Dismiss without selecting
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Hint text should still be showing (field is empty)
      expect(find.text('dd/mm/yyyy'), findsOneWidget);
    });
  });

  group('AddEventPage — Cancel button', () {
    testWidgets('tapping Cancel navigates back', (tester) async {
      final container = await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );

      await tap(tester, find.byKey(KBtn.cancelbutton.key));

      // Should have popped back (no longer on addEvent)
      expect(
        container
            .read(navRouter)
            .routeInformationProvider
            .value
            .uri
            .toString(),
        isNot(AppRoute.addEvent),
      );
    });

    testWidgets('system back also navigates away from Add page', (tester) async {
      final container = await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );

      await systemBack(tester);

      expect(
        container
            .read(navRouter)
            .routeInformationProvider
            .value
            .uri
            .toString(),
        isNot(AppRoute.addEvent),
      );
    });
  });

  group('AddEventPage — clinics loading state', () {

    testWidgets('shows clinic dropdown items when clinics load', (tester) async {
      when(
        () => mockSyncService.getCachedClinics(),
      ).thenAnswer(
        (_) async => [
          {'id': 'c1', 'name': 'Test Clinic Alpha'},
        ],
      );

      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );

      // Open the clinic dropdown
      await tester.tap(
        find.byKey(KBtn.clinicDropdown.key),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Clinic Alpha'), findsOneWidget);
    });
  });
}