import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/notifications_repository.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

class AppointmentNotifierHelper {
  static Future<void> scheduleReminders({
    required WidgetRef ref,
    required String clinicName,
    required String serviceName,
    required DateTime startTime,
  }) async {
    final notificationsRepo = ref.read(notificationsRepositoryProvider);
    final appUser = await ref.read(appUserProvider.future);
    final now = DateTime.now();
    
    if (!startTime.isAfter(now)) return;

    // 1 day before reminder
    final oneDayBefore = startTime.subtract(const Duration(days: 1));
    if (oneDayBefore.isAfter(now)) {
      await notificationsRepo.upsertNotificationToLocal(
        appUser.localId,
        AppNotifications.timed(
          title: 'Upcoming Appointment Tomorrow',
          description: 'You have $serviceName at $clinicName tomorrow.',
          notificationType: 'appointment_reminder',
          isAlertMessage: true,
          hasRead: false,
          linkToPage: '/appointments',
          delayDuration: oneDayBefore.difference(now),
        ),
      );
    }

    // 1 hour before reminder
    final oneHourBefore = startTime.subtract(const Duration(hours: 1));
    if (oneHourBefore.isAfter(now)) {
      await notificationsRepo.upsertNotificationToLocal(
        appUser.localId,
        AppNotifications.timed(
          title: 'Appointment in 1 Hour',
          description: '$serviceName at $clinicName is in 1 hour.',
          notificationType: 'appointment_reminder',
          isAlertMessage: true,
          hasRead: false,
          linkToPage: '/appointments',
          delayDuration: oneHourBefore.difference(now),
        ),
      );
    }
  }

  static Future<void> cancelReminders(WidgetRef ref) async {
    final notificationsRepo = ref.read(notificationsRepositoryProvider);
    final appUser = await ref.read(appUserProvider.future);
    final notifications = await notificationsRepo.getNotifications(appUser.localId);
    
    for (final n in notifications) {
      if (n.notificationType == 'appointment_reminder') {
        if (appUser.remoteId == null) {
          await notificationsRepo.removeNotificationForLocal(n);
        } else {
          await notificationsRepo.removeNotificationForRemote(appUser.localId, n);
        }

      }
    }
  }
}