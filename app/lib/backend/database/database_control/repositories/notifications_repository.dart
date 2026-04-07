import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/text_hints.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/notifications_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/notifications/notification_service.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';

part 'notifications_repository.g.dart';

// Provider
@Riverpod(keepAlive: true)
NotificationsRepository notificationsRepository(Ref ref) {
  return NotificationsRepository(
    ref: ref,
    dao: NotificationsDAO(ref.read(databaseProvider)),
  );
}

class NotificationsRepository {
  final Ref ref;
  final NotificationsDAO dao;
  NotificationsRepository({required this.ref, required this.dao});

  // Newest read
  Future<List<AppNotifications>> getNotifications(String localId) async {
    return (await dao.getNotifications(
      localId,
    )).map((n) => n.toAppNotifications()).toList();
  }

  // Reactive updates
  Stream<List<AppNotifications>> watchNotifications(String localId) async* {
    yield* dao
        .watchNotifications(localId)
        .map((nl) => nl.map((n) => n.toAppNotifications()).toList());
  }

  // For local-only notifications (e.g. Guest Appointments) use this
  // upsertNotificationToLocal and insertNotificationToRemote should not be used together
  Future<bool> upsertNotificationToLocal(
    String? localId,
    AppNotifications n,
  ) async {
    try {
      // Upsert into database
      await dao.upsertNotifications(n.toCompanion(localId));

      // Remove previous artifacts if scheduled
      final service = ref.read(notificationServiceProvider);
      await service.cancelNotification(n.id!);
      
      // Schedule New / Reschedule
      await ref.read(notificationServiceProvider).showNotification(n);
      return true;
    } catch (e) {
      localDBLogger.shout("$unexpectedErr: $e");
      return false;
    }
  }

  // For remote notifications (e.g. Registered Appointments) use this
  // The return value shows if the inserting of notifications to remote db succeeded
  // Real-time will automatically insert the notification into local db
  // Can be used to test if remote db is reachable or not
  // upsertNotificationToLocal and insertNotificationToRemote should not be used together
  Future<bool> insertNotificationToRemote(
    String remoteId,
    AppNotifications n,
  ) async {
    try {
      await SyncableEntity(
        data: n,
        job: SyncJob(remoteId: remoteId, targetTable: SyncTable.notifications),
      ).upsert(ref.read(supabaseServiceProvider));
      return true;
    } catch (e) {
      syncLogger.shout("$unexpectedErr: $e");
      return false;
    }
  }

  Future<void> removeNotification(int id) => dao.removeNotification(id);
}

extension on Notification {
  AppNotifications toAppNotifications() => AppNotifications(
    id: id,
    title: title,
    description: description,
    notificationType: notificationType,
    isAlertMessage: isAlertMessage,
    hasRead: hasRead,
    linkToPage: linkToPage,
    scheduledAt: scheduledAt,
    updatedAt: updatedAt,
  );
}

extension on AppNotifications {
  NotificationsCompanion toCompanion(String? localId) => NotificationsCompanion(
    id: Value(id!),
    localId: Value(localId),
    title: Value(title),
    description: Value(description),
    notificationType: Value(notificationType),
    isAlertMessage: Value(isAlertMessage),
    hasRead: Value(hasRead),
    linkToPage: Value(linkToPage),
    scheduledAt: Value(scheduledAt),
    updatedAt: Value(updatedAt.toUtc()),
  );
}

// TODO deleteOldNotifications
