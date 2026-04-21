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
  final notificationsRepo = ref.read(notificationsRepositoryProvider);
  final appUser = await ref.read(appUserProvider.future);
  final now = DateTime.now();

  if (!startTime.isAfter(now)) return;

  final timeUntilAppointment = startTime.difference(now);

  // Only schedule 1-day reminder if appointment is more than 24 hours away
  if (timeUntilAppointment.inHours == 24) {
    final oneDayBefore = startTime.subtract(const Duration(days: 1));
    await notificationsRepo.upsertNotificationToLocal(
      appUser.localId,
      AppNotifications.timed(
        uuid: const Uuid().v4(),
        title: 'Upcoming Appointment Tomorrow',
        description: 'You have $serviceName at $clinicName tomorrow.',
        notificationType: 'appointment',
        isAlertMessage: true,
        hasRead: false,
        linkToPage: '/appointments',
        delayDuration: oneDayBefore.difference(now),
      ),
    );
  }

  // Only schedule 1-hour reminder if appointment is more than 1 hour away
  if (timeUntilAppointment.inMinutes >= 60 ) {
    final oneHourBefore = startTime.subtract(const Duration(hours: 1));
    await notificationsRepo.upsertNotificationToLocal(
      appUser.localId,
      AppNotifications.timed(
        uuid: const Uuid().v4(),
        title: 'Appointment in 1 Hour',
        description: '$serviceName at $clinicName is in 1 hour.',
        notificationType: 'appointment',
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