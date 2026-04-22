import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/notifications_repository.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:uuid/uuid.dart';

class AppointmentNotifierHelper {
  static Future<void> scheduleReminders({
    required WidgetRef ref,
    required String clinicName,
    required String serviceName,
    required DateTime startTime,
  }) async {
    print('=== SCHEDULE REMINDERS ===');
    print('Received startTime: $startTime');
    print('Received startTime (local): ${startTime.toLocal()}');
    print('Received startTime (UTC): ${startTime.toUtc()}');
    print('Now (UTC): ${DateTime.now().toUtc()}');

    final notificationsRepo = ref.read(notificationsRepositoryProvider);
    final appUser = await ref.read(appUserProvider.future);
    final now = DateTime.now().toUtc();
    final startTimeUtc = startTime.toUtc();

    if (!startTimeUtc.isAfter(now)) return;

    final timeUntilAppointment = startTimeUtc.difference(now);
    final hoursUntilAppointment = timeUntilAppointment.inHours;

    // 1-day reminder: Only schedule if appointment is 24+ hours away
    // It will fire exactly 24 hours before the appointment
    if (hoursUntilAppointment >= 24) {
      final oneDayBefore = startTimeUtc.subtract(const Duration(days: 1));
      final delayUntilOneDayBefore = oneDayBefore.difference(now);
      
      if (delayUntilOneDayBefore.inSeconds > 60) {
        await notificationsRepo.upsertNotificationToLocal(
          appUser.localId,
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
    // It will fire exactly 1 hour before the appointment
    if (hoursUntilAppointment >= 1) {
      final oneHourBefore = startTimeUtc.subtract(const Duration(hours: 1));
      final delayUntilOneHourBefore = oneHourBefore.difference(now);
      
      if (delayUntilOneHourBefore.inSeconds > 60) {
        await notificationsRepo.upsertNotificationToLocal(
          appUser.localId,
          AppNotifications.timed(
            title: 'Appointment in 1 Hour',
            description: '$serviceName at $clinicName is in 1 hour.',
            notificationType: 'appointment',
            isAlertMessage: true,
            hasRead: false,
            linkToPage: '/appointments',
            delayDuration: delayUntilOneHourBefore,
          ),
        );
      }
    }
  }

  static Future<void> cancelReminders(WidgetRef ref) async {
    final notificationsRepo = ref.read(notificationsRepositoryProvider);
    final appUser = await ref.read(appUserProvider.future);
    final notifications = await notificationsRepo.getNotifications(appUser.localId);

    for (final n in notifications) {
      if (n.notificationType == 'appointment') {
        if (appUser.remoteId == null) {
          await notificationsRepo.removeNotificationForLocal(n);
        } else {
          await notificationsRepo.removeNotificationForRemote(appUser.localId, n);
        }
      }
    }
  }
}