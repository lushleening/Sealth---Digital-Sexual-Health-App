import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/appointments/appointment_sync.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

// ─── Stub data ────────────────────────────────────────────────────────────────

const _clinicId = 'clinic-1';
const _serviceId = 'service-1';

final _stubClinics = [
  {'id': _clinicId, 'name': 'Test Clinic'},
];

final _stubServices = [
  {'id': _serviceId, 'name': 'STI Screening', 'duration_minutes': 30},
];

final _stubServiceById = {
  'id': _serviceId,
  'name': 'STI Screening',
  'duration_minutes': 30,
};

// ─── Stub CreateAppointment ───────────────────────────────────────────────────

class _StubCreateAppointment extends CreateAppointment {
  final Result<void> result;

  _StubCreateAppointment(this.result, Ref ref) : super(ref);

  @override
  Future<Result<void>> createAppointment({
    required String userId,
    required String clinicId,
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
  }) async =>
      result;
}

class _SlowCreateAppointment extends CreateAppointment {
  final Completer<Result<void>> completer;

  _SlowCreateAppointment(this.completer, Ref ref) : super(ref);

  @override
  Future<Result<void>> createAppointment({
    required String userId,
    required String clinicId,
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
  }) =>
      completer.future;
}

// ─── Override helpers ─────────────────────────────────────────────────────────

List<Override> _overrides(
  MockAppointmentSyncService syncService, {
  Result<void>? createResult,
  Map<String, dynamic>? serviceById,
  Completer<Result<void>>? slowCreate,
}) {
  return [
    appointmentSyncServiceProvider.overrideWithValue(syncService),
    clinicsProvider.overrideWith((_) async => _stubClinics),
    servicesProvider(_clinicId).overrideWith((_) async => _stubServices),
    if (serviceById != null)
      serviceByIdProvider(_serviceId).overrideWith((_) async => serviceById),
    if (createResult != null)
      createAppointmentProvider.overrideWith(
        (ref) => _StubCreateAppointment(createResult, ref),
      ),
    if (slowCreate != null)
      createAppointmentProvider.overrideWith(
        (ref) => _SlowCreateAppointment(slowCreate, ref),
      ),
  ];
}

// ─── Form fill helper ─────────────────────────────────────────────────────────

Future<void> _fillForm(WidgetTester tester) async {
  // Clinic dropdown
  final clinicDropdown = find.byKey(KBtn.clinicDropdown.key);
  await tester.ensureVisible(clinicDropdown);
  await tester.tap(clinicDropdown);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Test Clinic').last);
  await tester.pumpAndSettle();

  // Service dropdown
  final serviceDropdown = find.byKey(KBtn.serviceDropdown.key);
  await tester.ensureVisible(serviceDropdown);
  await tester.tap(serviceDropdown);
  await tester.pumpAndSettle();
  await tester.tap(find.text('STI Screening').last);
  await tester.pumpAndSettle();

  // Date field
  final dateField = find.byKey(KBtn.datePicker.key);
  await tester.ensureVisible(dateField);
  await tester.tap(dateField);
  await tester.pumpAndSettle();
  final okButton = find.text('OK').last;
  await tester.tap(okButton);
  await tester.pumpAndSettle();

  // Time field
  final timeField = find.byKey(KBtn.timePicker.key);
  await tester.ensureVisible(timeField);
  await tester.tap(timeField);
  await tester.pumpAndSettle();
  final timeOkButton = find.text('OK').last;
  await tester.tap(timeOkButton);
  await tester.pumpAndSettle();
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late MockAppointmentSyncService mockSyncService;

  setUp(() {
    mockSyncService = MockAppointmentSyncService();
    when(() => mockSyncService.getCachedClinics())
        .thenAnswer((_) async => _stubClinics);
    when(() => mockSyncService.syncClinics()).thenAnswer((_) async {});
    when(() => mockSyncService.getCachedServices(any()))
        .thenAnswer((_) async => _stubServices);
    when(() => mockSyncService.syncServices()).thenAnswer((_) async {});
    when(() => mockSyncService.getCachedAppointments(any()))
        .thenAnswer((_) async => []);
    when(() => mockSyncService.syncAppointments()).thenAnswer((_) async {});
    when(
      () => mockSyncService.checkForConflict(
        clinicId: any(named: 'clinicId'),
        startTime: any(named: 'startTime'),
        endTime: any(named: 'endTime'),
      ),
    ).thenAnswer((_) async => false);
  });

  // ── Rendering ───────────────────────────────────────────────────────────────

  group('Rendering', () {
    testWidgets('renders app bar title', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: _overrides(mockSyncService),
      );

      expect(find.text('Add New Appointment'), findsOneWidget);
    });

    testWidgets('renders Add and Cancel buttons', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: _overrides(mockSyncService),
      );

      expectObj(KBtn.eventaddbutton);
      expectObj(KBtn.cancelbutton);
    });

    testWidgets('renders date, time, and notes hint text', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: _overrides(mockSyncService),
      );

      expect(find.text('dd/mm/yyyy'), findsOneWidget);
      expect(find.text('Select time'), findsOneWidget);
      expect(find.text('Add any additional notes...'), findsOneWidget);
    });

    testWidgets('service dropdown is hidden before a clinic is selected',
        (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: _overrides(mockSyncService),
      );

      expect(find.text('Select appointment type'), findsNothing);
    });
  });

  // ── Clinics async states ────────────────────────────────────────────────────

  group('Clinics async states', () {
    testWidgets('shows LinearProgressIndicator while clinics are loading',
        (tester) async {
      final neverComplete = Completer<List<Map<String, dynamic>>>();

      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
          clinicsProvider.overrideWith((_) => neverComplete.future),
        ],
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('renders clinic dropdown hint when clinics load', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: _overrides(mockSyncService),
      );

      expect(find.text('Select location'), findsOneWidget);
    });

    testWidgets('renders clinic name in dropdown', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: _overrides(mockSyncService),
      );

      final clinicDropdown = find.byKey(KBtn.clinicDropdown.key);
      await tester.ensureVisible(clinicDropdown);
      await tester.tap(clinicDropdown);
      await tester.pumpAndSettle();

      expect(find.text('Test Clinic'), findsWidgets);
    });
  });

  // ── Services async states ───────────────────────────────────────────────────

  group('Services async states', () {
    testWidgets('renders service names in dropdown after clinic selected',
        (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: _overrides(mockSyncService),
      );

      final clinicDropdown = find.byKey(KBtn.clinicDropdown.key);
      await tester.ensureVisible(clinicDropdown);
      await tester.tap(clinicDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test Clinic').last);
      await tester.pumpAndSettle();

      final serviceDropdown = find.byKey(KBtn.serviceDropdown.key);
      await tester.ensureVisible(serviceDropdown);
      await tester.tap(serviceDropdown);
      await tester.pumpAndSettle();

      expect(find.text('STI Screening'), findsWidgets);
    });
  });

  // ── Clinic/service selection interaction ────────────────────────────────────

  group('Clinic and service selection', () {
    testWidgets('can select a service after selecting a clinic', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: _overrides(mockSyncService),
      );

      final clinicDropdown = find.byKey(KBtn.clinicDropdown.key);
      await tester.ensureVisible(clinicDropdown);
      await tester.tap(clinicDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test Clinic').last);
      await tester.pumpAndSettle();

      final serviceDropdown = find.byKey(KBtn.serviceDropdown.key);
      await tester.ensureVisible(serviceDropdown);
      await tester.tap(serviceDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('STI Screening').last);
      await tester.pumpAndSettle();

      expect(find.text('Select appointment type'), findsNothing);
    });
  });

  // ── Date picker ─────────────────────────────────────────────────────────────

  group('Date picker', () {
    testWidgets('tapping date field opens DatePickerDialog', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: _overrides(mockSyncService),
      );

      final dateField = find.byKey(KBtn.datePicker.key);
      await tester.ensureVisible(dateField);
      await tester.tap(dateField);
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });
  });

  // ── Time picker ─────────────────────────────────────────────────────────────

  group('Time picker', () {
    testWidgets('tapping time field opens TimePickerDialog', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: _overrides(mockSyncService),
      );

      final timeField = find.byKey(KBtn.timePicker.key);
      await tester.ensureVisible(timeField);
      await tester.tap(timeField);
      await tester.pumpAndSettle();

      expect(find.byType(TimePickerDialog), findsOneWidget);
    });
  });

  // ── Notes field ─────────────────────────────────────────────────────────────

  group('Notes field', () {
    testWidgets('accepts text input', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: _overrides(mockSyncService),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Add any additional notes...'),
        'Allergy to penicillin',
      );
      await tester.pump();

      expect(find.text('Allergy to penicillin'), findsOneWidget);
    });
  });

  // ── Form validation ─────────────────────────────────────────────────────────

  group('Form validation', () {
    testWidgets('submitting empty form shows required-fields snackbar',
        (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: _overrides(mockSyncService),
      );

      await tap(tester, find.byKey(KBtn.eventaddbutton.key));

      expect(find.text('Please fill in all required fields'), findsOneWidget);
    });
  });

  // ── Cancel button ───────────────────────────────────────────────────────────

  group('Cancel button', () {
    testWidgets('navigates back to appointments route', (tester) async {
      final container = await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: _overrides(mockSyncService),
      );

      await tap(tester, find.byKey(KBtn.cancelbutton.key));
      await tester.pumpAndSettle();
      expectPath(container, AppRoute.appointments);
    });

    testWidgets('Cancel button is always tappable', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.addEvent,
        otherOverrides: _overrides(mockSyncService),
      );

      await tap(tester, find.byKey(KBtn.cancelbutton.key));
    });
  });
}