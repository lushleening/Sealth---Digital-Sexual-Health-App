import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/appointments/appointment_notifier.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';

import '../../helper/mock_objects.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class FakeAppNotifications extends Fake implements AppNotifications {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

DateTime futureUtc(Duration offset) => DateTime.now().toUtc().add(offset);

/// Stubs the mock and returns it ready for use.
MockAppNotificationsNotifier buildMock() {
  final mock = MockAppNotificationsNotifier();
  when(() => mock.upsertNotificationToLocal(any()))
      .thenAnswer((_) async => true);
  when(() => mock.insertNotificationToRemote(any()))
      .thenAnswer((_) async => true);
  when(() => mock.removeNotification(any())).thenAnswer((_) async {});
  return mock;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAppNotifications());
  });

  // ─── scheduleRemindersCore ────────────────────────────────────────────────

  group('AppointmentNotifierHelper.scheduleRemindersCore', () {
    group('past / immediate appointments', () {
      test('does nothing when startTime is in the past', () async {
        final mock = buildMock();

        await AppointmentNotifierHelper.scheduleRemindersCore(
          notifier: mock,
          isRegistered: false,
          clinicName: 'Test Clinic',
          serviceName: 'STI Screening',
          startTime: DateTime.now().subtract(const Duration(hours: 1)),
        );

        verifyNever(() => mock.upsertNotificationToLocal(any()));
        verifyNever(() => mock.insertNotificationToRemote(any()));
      });

      test('does nothing when startTime equals now', () async {
        final mock = buildMock();

        await AppointmentNotifierHelper.scheduleRemindersCore(
          notifier: mock,
          isRegistered: false,
          clinicName: 'Test Clinic',
          serviceName: 'STI Screening',
          startTime: DateTime.now(),
        );

        verifyNever(() => mock.upsertNotificationToLocal(any()));
        verifyNever(() => mock.insertNotificationToRemote(any()));
      });
    });

    group('appointment 30 hours away', () {
      late DateTime startTime;
      setUp(() => startTime = futureUtc(const Duration(hours: 30)));

      test('schedules exactly 2 notifications for a guest user', () async {
        final mock = buildMock();

        await AppointmentNotifierHelper.scheduleRemindersCore(
          notifier: mock,
          isRegistered: false,
          clinicName: 'Health Hub',
          serviceName: 'HIV Test',
          startTime: startTime,
        );

        verify(() => mock.upsertNotificationToLocal(any())).called(2);
        verifyNever(() => mock.insertNotificationToRemote(any()));
      });

      test('schedules exactly 2 notifications for a registered user', () async {
        final mock = buildMock();

        await AppointmentNotifierHelper.scheduleRemindersCore(
          notifier: mock,
          isRegistered: true,
          clinicName: 'Health Hub',
          serviceName: 'HIV Test',
          startTime: startTime,
        );

        verify(() => mock.insertNotificationToRemote(any())).called(2);
        verifyNever(() => mock.upsertNotificationToLocal(any()));
      });

      test('1-day reminder has correct content', () async {
        final mock = buildMock();
        final captured = <AppNotifications>[];

        when(() => mock.upsertNotificationToLocal(any())).thenAnswer((inv) async {
          captured.add(inv.positionalArguments.first as AppNotifications);
          return true;
        });

        await AppointmentNotifierHelper.scheduleRemindersCore(
          notifier: mock,
          isRegistered: false,
          clinicName: 'Health Hub',
          serviceName: 'HIV Test',
          startTime: startTime,
        );

        final dayReminder = captured.firstWhere(
          (n) => n.title == 'Upcoming Appointment Tomorrow',
        );
        expect(dayReminder.description, contains('HIV Test'));
        expect(dayReminder.description, contains('Health Hub'));
        expect(dayReminder.isAlertMessage, isTrue);
        expect(dayReminder.hasRead, isFalse);
        expect(dayReminder.linkToPage, '/appointments');
        expect(dayReminder.notificationType, 'appointment');
      });

      test('1-hour reminder has correct content', () async {
        final mock = buildMock();
        final captured = <AppNotifications>[];

        when(() => mock.upsertNotificationToLocal(any())).thenAnswer((inv) async {
          captured.add(inv.positionalArguments.first as AppNotifications);
          return true;
        });

        await AppointmentNotifierHelper.scheduleRemindersCore(
          notifier: mock,
          isRegistered: false,
          clinicName: 'Health Hub',
          serviceName: 'HIV Test',
          startTime: startTime,
        );

        final hourReminder = captured.firstWhere(
          (n) => n.title == 'Appointment in 1 Hour',
        );
        expect(hourReminder.description, contains('HIV Test'));
        expect(hourReminder.description, contains('Health Hub'));
        expect(hourReminder.isAlertMessage, isTrue);
        expect(hourReminder.hasRead, isFalse);
        expect(hourReminder.notificationType, 'appointment');
      });
    });

    group('appointment between 1 and 24 hours away', () {
      test('skips 1-day reminder, schedules only 1-hour reminder', () async {
        final mock = buildMock();

        await AppointmentNotifierHelper.scheduleRemindersCore(
          notifier: mock,
          isRegistered: false,
          clinicName: 'Clinic A',
          serviceName: 'Checkup',
          startTime: futureUtc(const Duration(hours: 12)),
        );

        verify(() => mock.upsertNotificationToLocal(any())).called(1);
      });

      test('1-hour reminder title is "Appointment in 1 Hour"', () async {
        final mock = buildMock();
        AppNotifications? captured;

        when(() => mock.upsertNotificationToLocal(any())).thenAnswer((inv) async {
          captured = inv.positionalArguments.first as AppNotifications;
          return true;
        });

        await AppointmentNotifierHelper.scheduleRemindersCore(
          notifier: mock,
          isRegistered: false,
          clinicName: 'Clinic A',
          serviceName: 'Checkup',
          startTime: futureUtc(const Duration(hours: 12)),
        );

        expect(captured?.title, 'Appointment in 1 Hour');
      });
    });

    group('appointment within 1 hour (but still in the future)', () {
      test('schedules one "Appointment Soon" notification (30 min away)', () async {
        final mock = buildMock();
        AppNotifications? captured;

        when(() => mock.upsertNotificationToLocal(any())).thenAnswer((inv) async {
          captured = inv.positionalArguments.first as AppNotifications;
          return true;
        });

        await AppointmentNotifierHelper.scheduleRemindersCore(
          notifier: mock,
          isRegistered: false,
          clinicName: 'Clinic B',
          serviceName: 'STI Test',
          startTime: futureUtc(const Duration(minutes: 30)),
        );

        verify(() => mock.upsertNotificationToLocal(any())).called(1);
        expect(captured?.title, 'Appointment Soon');
      });

      test('uses "Appointment Soon" when 1-hour-before mark is within 60 seconds',
          () async {
        // 61 min away → 1-hour-before point is ~1 min away → small-delay branch
        final mock = buildMock();
        AppNotifications? captured;

        when(() => mock.upsertNotificationToLocal(any())).thenAnswer((inv) async {
          captured = inv.positionalArguments.first as AppNotifications;
          return true;
        });

        await AppointmentNotifierHelper.scheduleRemindersCore(
          notifier: mock,
          isRegistered: false,
          clinicName: 'Clinic B',
          serviceName: 'STI Test',
          startTime: futureUtc(const Duration(minutes: 61)),
        );

        expect(captured?.title, 'Appointment Soon');
      });
    });

    test('every scheduled notification has notificationType "appointment"', () async {
      final mock = buildMock();
      final captured = <AppNotifications>[];

      when(() => mock.upsertNotificationToLocal(any())).thenAnswer((inv) async {
        captured.add(inv.positionalArguments.first as AppNotifications);
        return true;
      });

      await AppointmentNotifierHelper.scheduleRemindersCore(
        notifier: mock,
        isRegistered: false,
        clinicName: 'Clinic',
        serviceName: 'Service',
        startTime: futureUtc(const Duration(hours: 30)),
      );

      expect(captured, isNotEmpty);
      expect(captured.every((n) => n.notificationType == 'appointment'), isTrue);
    });
  });

  // ─── cancelRemindersCore ──────────────────────────────────────────────────

  group('AppointmentNotifierHelper.cancelRemindersCore', () {
    test('removes an appointment notification', () async {
      final mock = buildMock();
      final appointmentNotif = testAppNotificationsOneHasNotRead.copyWith(
        notificationType: 'appointment',
      );

      await AppointmentNotifierHelper.cancelRemindersCore(
        notifier: mock,
        notifications: [appointmentNotif],
      );

      verify(() => mock.removeNotification(any())).called(1);
    });

    test('does not remove non-appointment notifications', () async {
      final mock = buildMock();

      await AppointmentNotifierHelper.cancelRemindersCore(
        notifier: mock,
        notifications: [testAppNotificationsOneHasNotRead], // type = discussion
      );

      verifyNever(() => mock.removeNotification(any()));
    });

    test('does nothing when notifications list is empty', () async {
      final mock = buildMock();

      await AppointmentNotifierHelper.cancelRemindersCore(
        notifier: mock,
        notifications: [],
      );

      verifyNever(() => mock.removeNotification(any()));
    });

    test('removes only appointment notifications from a mixed list', () async {
      final mock = buildMock();

      final appt1 = testAppNotificationsOneHasNotRead.copyWith(
        uuid: 'appt-1',
        notificationType: 'appointment',
      );
      final appt2 = testAppNotificationsOneHasRead.copyWith(
        uuid: 'appt-2',
        notificationType: 'appointment',
      );
      final discussion = testAppNotificationsOneHasNotRead.copyWith(
        uuid: 'disc-1',
      ); // type stays 'discussion'

      await AppointmentNotifierHelper.cancelRemindersCore(
        notifier: mock,
        notifications: [appt1, discussion, appt2],
      );

      verify(() => mock.removeNotification(any())).called(2);
    });
  });
}