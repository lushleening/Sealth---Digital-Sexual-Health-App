import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/appointments/appointment_sync.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

Future<void> _tapSave(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.byKey(KBtn.savebutton.key),
    100,
    scrollable: find.byType(Scrollable).first,
  );
  await tap(tester, find.byKey(KBtn.savebutton.key));
}

Future<void> _tapDelete(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(KBtn.deletebutton.key));
  await tester.pumpAndSettle();
  await tap(tester, find.byKey(KBtn.deletebutton.key));
}

// Changes the notes field to a new value (notes is the last TextFormField)
Future<void> _changeNotes(WidgetTester tester, String value) async {
  final notesFinder = find.byWidgetPredicate((w) => w is TextFormField).last;
  await tester.scrollUntilVisible(
    notesFinder,
    100,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.enterText(notesFinder, value);
  await tester.pump();
}

// Helper to tap date picker
Future<void> _tapDatePicker(WidgetTester tester) async {
  final dateField = find.byWidgetPredicate(
    (widget) => widget is GestureDetector && 
        widget.child is AbsorbPointer,
  ).first;
  await tester.ensureVisible(dateField);
  await tester.tap(dateField);
  await tester.pumpAndSettle();
}

// Helper to tap time picker
Future<void> _tapTimePicker(WidgetTester tester) async {
  final timeField = find.byWidgetPredicate(
    (widget) => widget is GestureDetector && 
        widget.child is AbsorbPointer,
  ).last;
  await tester.ensureVisible(timeField);
  await tester.tap(timeField);
  await tester.pumpAndSettle();
}

// ─── Main ─────────────────────────────────────────────────────────────────────

void main() {
  late MockAppointmentSyncService mockSyncService;

  setUp(() {
    mockSyncService = MockAppointmentSyncService();

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

    when(
      () => mockSyncService.checkForConflict(
        clinicId: any(named: 'clinicId'),
        startTime: any(named: 'startTime'),
        endTime: any(named: 'endTime'),
        excludeAppointmentId: any(named: 'excludeAppointmentId'),
      ),
    ).thenAnswer((_) async => false);
  });

  Future<void> navigateToEditPage(WidgetTester tester) async {
    await tap(tester, find.byIcon(Icons.edit_outlined));
  }

  // ─── Rendering ─────────────────────────────────────────────────────────────

  group('EditEvents — renders correctly', () {
    testWidgets('shows Edit Appointment in the AppBar', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);

      expect(find.text('Edit Appointment'), findsOneWidget);
    });

    testWidgets('shows Save, Delete, and Cancel buttons', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);

      expectObj(KBtn.savebutton);
      expectObj(KBtn.deletebutton);
      expectObj(KBtn.cancelbutton);
    });

    testWidgets('pre-fills date field with appointment date', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);

      expect(find.text('09/11/2026'), findsOneWidget);
    });

    testWidgets('pre-fills notes field with appointment notes', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);

      expect(find.text('Some notes'), findsOneWidget);
    });

    testWidgets('shows Location, Date, Time labels', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);

      expect(find.byWidgetPredicate((widget) => 
        widget is RichText && widget.text.toPlainText().contains('Location')
      ), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => 
        widget is RichText && widget.text.toPlainText().contains('Date')
      ), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => 
        widget is RichText && widget.text.toPlainText().contains('Time')
      ), findsOneWidget);
    });

    testWidgets('shows Notes label', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);

      expect(find.byWidgetPredicate((widget) => 
        widget is RichText && widget.text.toPlainText().contains('Notes')
      ), findsOneWidget);
    });
  });

  // ─── Save: no-change guard ────────────────────────────────────────────────

  group('EditEvents — Save: no-change guard', () {
    testWidgets('shows "No changes made" snackbar when nothing changed',
        (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);
      await _tapSave(tester);

      expect(find.textContaining('No changes made'), findsOneWidget);
      expect(find.text('Edit Appointment'), findsOneWidget);
    });

    testWidgets('Save button still visible after no-change tap', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);
      await _tapSave(tester);

      expectObj(KBtn.savebutton);
    });
  });

  // ─── Save: conflict branch ────────────────────────────────────────────────

  group('EditEvents — Save: conflict detected', () {
    setUp(() {
      when(
        () => mockSyncService.checkForConflict(
          clinicId: any(named: 'clinicId'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
          excludeAppointmentId: any(named: 'excludeAppointmentId'),
        ),
      ).thenAnswer((_) async => true);
    });

    testWidgets('shows conflict snackbar and stays on page', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);
      await _changeNotes(tester, 'Trigger save');
      await _tapSave(tester);

      expect(find.textContaining('already booked'), findsOneWidget);
      expect(find.text('Edit Appointment'), findsOneWidget);
    });

    testWidgets('loading spinner disappears and Save button returns',
        (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);
      await _changeNotes(tester, 'Trigger save');
      await _tapSave(tester);

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expectObj(KBtn.savebutton);
    });
  });

  // ─── Delete: dialog flow ──────────────────────────────────────────────────

  group('EditEvents — Delete button', () {
    testWidgets('tapping Delete shows confirmation dialog', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);
      await _tapDelete(tester);

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Delete Appointment'), findsWidgets);
    });

    testWidgets('confirmation dialog shows Cancel and Delete actions',
        (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);
      await _tapDelete(tester);

      expect(find.text('Cancel'), findsWidgets);
      expect(find.text('Delete'), findsWidgets);
    });

    testWidgets('dialog shows "Are you sure" warning text', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);
      await _tapDelete(tester);

      expect(find.textContaining('Are you sure'), findsOneWidget);
    });

    testWidgets('tapping Cancel on dialog dismisses it, stays on edit page',
        (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);
      await _tapDelete(tester);

      await tap(tester, find.text('Cancel').last);

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Edit Appointment'), findsOneWidget);
    });

  });

  // ─── Cancel button ────────────────────────────────────────────────────────

  group('EditEvents — Cancel button', () {
    testWidgets('tapping Cancel navigates back to appointments page',
        (tester) async {
      final container = await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);

      await tester.ensureVisible(find.byKey(KBtn.cancelbutton.key));
      await tester.pumpAndSettle();
      await tap(tester, find.byKey(KBtn.cancelbutton.key));

      expectPath(container, AppRoute.appointments);
    });

    testWidgets('system back button also returns to appointments page',
        (tester) async {
      final container = await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);

      await systemBack(tester);

      expectPath(container, AppRoute.appointments);
    });
  });

  // ─── Date / Time pickers ──────────────────────────────────────────────────

  group('EditEvents — date and time pickers', () {
    testWidgets('tapping date field opens DatePickerDialog', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);

      await _tapDatePicker(tester);

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('tapping time field opens TimePickerDialog', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);

      await _tapTimePicker(tester);

      expect(find.byType(TimePickerDialog), findsOneWidget);
    });
  });

  // ─── Notes field ──────────────────────────────────────────────────────────

  group('EditEvents — notes field', () {
    testWidgets('can update text in notes field', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);

      await _changeNotes(tester, 'Brand new notes');

      expect(find.text('Brand new notes'), findsOneWidget);
    });

    testWidgets('clearing notes field removes previous value', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.appointments,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        ],
      );
      await navigateToEditPage(tester);

      await _changeNotes(tester, '');

      expect(find.text('Some notes'), findsNothing);
    });
  });
}