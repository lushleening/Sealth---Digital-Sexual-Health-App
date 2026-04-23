import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

class AppointmentNotifierHelper {
  /// Public entry-point for widgets — resolves dependencies from [ref] then
  /// delegates to the testable core.
  static Future<void> scheduleReminders({
    required WidgetRef ref,
    required String clinicName,
    required String serviceName,
    required DateTime startTime,
  }) async {
    final appUser = await ref.read(appUserProvider.future);
    final notifier = ref.read(appNotificationProvider.notifier);
    await scheduleRemindersCore(
      notifier: notifier,
      isRegistered: appUser.remoteId != null,
      clinicName: clinicName,
      serviceName: serviceName,
      startTime: startTime,
    );
  }

  /// Testable core — no Ref/WidgetRef involved.
  static Future<void> scheduleRemindersCore({
    required AppNotificationNotifier notifier,
    required bool isRegistered,
    required String clinicName,
    required String serviceName,
    required DateTime startTime,
  }) async {
    final now = DateTime.now().toUtc();
    final startTimeUtc = startTime.toUtc();

    if (!startTimeUtc.isAfter(now)) return;

    final hoursUntilAppointment = startTimeUtc.difference(now).inHours;

    Future<void> addNotification(AppNotifications notification) async {
      if (isRegistered) {
        await notifier.insertNotificationToRemote(notification);
      } else {
        await notifier.upsertNotificationToLocal(notification);
      }
    }

    // 1-day reminder: only if 24+ hours away
    if (hoursUntilAppointment >= 24) {
      final oneDayBefore = startTimeUtc.subtract(const Duration(days: 1));
      final delayUntilOneDayBefore = oneDayBefore.difference(now);

      if (delayUntilOneDayBefore.inSeconds > 60) {
        await addNotification(
          AppNotifications.timed(
            title: 'Upcoming Appointment Tomorrow',
            description: 'You have $serviceName at $clinicName tomorrow.',
            notificationType: 'appointment',
            isAlertMessage: true,
            hasRead: false,
            linkToPage: '/appointments',
            delayDuration: delayUntilOneDayBefore,
          ),
        );
      }
    }

    // 1-hour reminder
    if (startTimeUtc.isAfter(now)) {
      final oneHourBefore = startTimeUtc.subtract(const Duration(hours: 1));
      final delayUntilOneHourBefore = oneHourBefore.difference(now);

      String title;
      String description;
      Duration finalDelay;

      if (delayUntilOneHourBefore.inSeconds > 60) {
        title = 'Appointment in 1 Hour';
        description = '$serviceName at $clinicName is in 1 hour.';
        finalDelay = delayUntilOneHourBefore;
      } else if (delayUntilOneHourBefore.inSeconds > 0) {
        title = 'Appointment Soon';
        description = '$serviceName at $clinicName is coming up soon.';
        finalDelay = const Duration(seconds: 5);
      } else {
        title = 'Appointment Soon';
        description = '$serviceName at $clinicName is happening soon.';
        finalDelay = Duration.zero;
      }

      await addNotification(
        AppNotifications.timed(
          title: title,
          description: description,
          notificationType: 'appointment',
          isAlertMessage: true,
          hasRead: false,
          linkToPage: '/appointments',
          delayDuration: finalDelay,
        ),
      );
    }
  }

  /// Public entry-point for widgets.
  static Future<void> cancelReminders(WidgetRef ref) async {
    final notifier = ref.read(appNotificationProvider.notifier);
    final notifications = await ref.read(appNotificationProvider.future);
    await cancelRemindersCore(notifier: notifier, notifications: notifications);
  }

  /// Testable core — no Ref/WidgetRef involved.
  static Future<void> cancelRemindersCore({
    required AppNotificationNotifier notifier,
    required List<AppNotifications> notifications,
  }) async {
    for (final n in notifications) {
      if (n.notificationType == 'appointment') {
        await notifier.removeNotification(n);
      }
    }
  }
}