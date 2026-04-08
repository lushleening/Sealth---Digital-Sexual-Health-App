import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/storage.dart';
import 'package:sddp_dsh/backend/constants/supabase.dart';
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

  // For sync
  Future<void> batchUpsertFromRemote(
    String localId,
    List<AppNotifications> notifications,
  ) async {
    // Filter out old data
    await dao.batchUpsertNotifications(
      notifications
          .where((n) => !_exceedsMaxHistory(n))
          .map((n) => n.toCompanion(localId))
          .toList(),
    );

    // Let other threads try scheduling the system notifications
    final tasks = notifications.map((n) => _rescheduleNotification(n));
    if (tasks.isNotEmpty) {
      Future.wait(tasks).catchError((e) {
        localDBLogger.severe("Failed to reschedule batch: $e");
        return [];
      });
    }
  }

  // FOR INTERNAL ONLY DO NOT USE, use appNotificationsProvider instead
  // upsertNotificationToLocal and insertNotificationToRemote should not be used together
  Future<bool> upsertNotificationToLocal(
    String? localId,
    AppNotifications n, {
    bool scheduleNotification = true,
    bool bypassStaleCheck = false,
  }) async {
    if (_exceedsMaxHistory(n)) return false;

    try {
      // No need to update if notification stale
      final noti = await dao.getNotification(n.uuid);
      final isStale = noti != null && (!n.updatedAt.isAfter(noti.updatedAt));
      if (!bypassStaleCheck && isStale) return false;

      // Upsert into database
      await dao.upsertNotification(n.toCompanion(localId));
      if (scheduleNotification) await _rescheduleNotification(n);
      return true;
    } catch (e) {
      localDBLogger.shout("$unexpectedErr: $e");
      return false;
    }
  }

  // FOR INTERNAL ONLY DO NOT USE, use appNotificationsProvider instead
  // The return value shows if the inserting of notifications to remote db succeeded
  // Real-time will automatically insert the notification into local db
  // upsertNotificationToLocal and insertNotificationToRemote should not be used together
  Future<bool> insertNotificationToRemote(
    String remoteId,
    AppNotifications n,
  ) async {
    try {
      // UUID determines unique notification
      await SyncableEntity(
        data: n,
        job: SyncJob(remoteId: remoteId, targetTable: SyncTable.notifications),
      ).upsert(ref.read(supabaseServiceProvider), onConflict: uuidColName);
      return true;
    } catch (e) {
      syncLogger.shout("$unexpectedErr: $e");
      return false;
    }
  }

  Future<void> removeNotificationForLocal(AppNotifications n) async {
    await dao.removeNotificationForLocal(n.uuid);
    await ref.read(notificationServiceProvider).cancelNotification(n.id);
  }

  // Requires setting a special flag to prevent future syncs
  Future<void> removeNotificationForRemote(
    String localId,
    AppNotifications n,
  ) async {
    await dao.upsertNotification(
      n.toCompanion(localId).copyWith(hasRemoved: Value(true)),
    );
    await ref.read(notificationServiceProvider).cancelNotification(n.id);
  }

  // Cleanup notifications
  Future<int> cleanupOldNotifications() => dao.cleanupOldNotifications();

  // To check if n needs to be inserted to local db
  bool _exceedsMaxHistory(AppNotifications n) => n.scheduledAt.isBefore(
    DateTime.now().subtract(cleanupNotificationThreshold),
  );

  Future<void> _rescheduleNotification(AppNotifications n) async {
    // Remove previous artifacts if already scheduled and reschedule them
    await ref.read(notificationServiceProvider).cancelNotification(n.id);
    await ref.read(notificationServiceProvider).filterAndShowNotification(n);
  }
}

extension on Notification {
  AppNotifications toAppNotifications() => AppNotifications(
    uuid: uuid,
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
    uuid: Value(uuid), // Insert to db to generate a uuid before using
    localId: Value(localId),
    title: Value(title),
    description: Value(description),
    notificationType: Value(notificationType),
    isAlertMessage: Value(isAlertMessage),
    hasRead: Value(hasRead),
    linkToPage: Value(linkToPage),
    scheduledAt: Value(scheduledAt),
    updatedAt: Value(updatedAt),
  );
}
