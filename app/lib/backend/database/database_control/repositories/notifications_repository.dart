import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_service.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/notifications_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
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

  Future<List<AppNotifications>> getNotifications(String localId) async {
    notificationsLogger.info(
      "Getting notifications from local db for localId: $localId",
    );
    final notifications = (await dao.getNotifications(localId));
    return notifications.map((n) => n.toAppNotifications()).toList();
  }

  // For local-only notifications use this
  Future<void> upsertNotification(
    String localId,
    AppNotifications newNotifications,
  ) async {
    notificationsLogger.info(
      "Updating new notifications for $localId: $newNotifications to local db",
    );
    await dao.upsertNotifications(newNotifications.toCompanion(localId)); // TODO check dt for list????????
  }

  Future<void> upsertNotificationAndSync({
    required String localId,
    required String? remoteId,
    required AppNotifications newNotifications,
  }) async {
    await upsertNotification(localId, newNotifications);
    await ref
        .read(syncServiceProvider)
        .addJob(remoteId, SyncTable.notifications);
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
    pushDateTime: pushDateTime,
    updatedAt: updatedAt,
  );
}

extension on AppNotifications {
  NotificationsCompanion toCompanion(String localId) => NotificationsCompanion(
    localId: Value(localId),
    uuid: Value(uuid),
    title: Value(title),
    description: Value(description),
    notificationType: Value(notificationType),
    isAlertMessage: Value(isAlertMessage),
    hasRead: Value(hasRead),
    linkToPage: Value(linkToPage),
    pushDateTime: Value(pushDateTime),
    updatedAt: Value(updatedAt.toUtc())
  );
}
