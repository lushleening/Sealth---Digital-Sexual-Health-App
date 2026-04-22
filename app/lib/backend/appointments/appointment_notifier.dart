import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

class AppointmentNotifierHelper {
  static Future<void> scheduleReminders({
    required WidgetRef ref,
    required String clinicName,
    required String serviceName,
    required DateTime startTime,
  }) async {
    final appUser = await ref.read(appUserProvider.future);
    final isRegistered = appUser.remoteId != null;
    final notifier = ref.read(appNotificationProvider.notifier);
    final now = DateTime.now().toUtc();
    final startTimeUtc = startTime.toUtc();

    if (!startTimeUtc.isAfter(now)) return;

    final timeUntilAppointment = startTimeUtc.difference(now);
    final hoursUntilAppointment = timeUntilAppointment.inHours;

    Future<void> addNotification(AppNotifications notification) async {
      if (isRegistered) {
        await notifier.insertNotificationToRemote(notification);
      } else {
        await notifier.upsertNotificationToLocal(notification);
      }
    }

    // 1-day reminder: Only schedule if appointment is 24+ hours away
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

    // 1-hour reminder: Only schedule if appointment is 1+ hour away
    if (startTimeUtc.isAfter(now)) {
      final oneHourBefore = startTimeUtc.subtract(const Duration(hours: 1));
      final delayUntilOneHourBefore = oneHourBefore.difference(now);
      
      String title;
      String description;
      Duration finalDelay;
      
      if (delayUntilOneHourBefore.inSeconds > 60) {
        // More than 1 minute away - schedule normally
        title = 'Appointment in 1 Hour';
        description = '$serviceName at $clinicName is in 1 hour.';
        finalDelay = delayUntilOneHourBefore;
      } else if (delayUntilOneHourBefore.inSeconds > 0) {
        // Less than 1 minute away - schedule with small delay
        title = 'Appointment Soon';
        description = '$serviceName at $clinicName is coming up soon.';
        finalDelay = const Duration(seconds: 5);
      } else {
        // Already past the 1-hour mark - show immediately
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

  static Future<void> cancelReminders(WidgetRef ref) async {
    final notifier = ref.read(appNotificationProvider.notifier);
    final notifications = await ref.read(appNotificationProvider.future);

    for (final n in notifications) {
      if (n.notificationType == 'appointment') {
        await notifier.removeNotification(n);
      }
    }
  }
}