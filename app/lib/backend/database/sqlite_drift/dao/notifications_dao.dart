import 'package:drift/drift.dart';
import 'package:sddp_dsh/backend/constants/storage.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/schema.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

part 'notifications_dao.g.dart';

@DriftAccessor(tables: [Notifications])
class NotificationsDAO extends DatabaseAccessor<Database>
    with _$NotificationsDAOMixin {
  NotificationsDAO(super.attachedDatabase);

  Future<Notification?> getNotification(String uuid) {
    localDBLogger.info("Getting notification with uuid: $uuid");
    return ((select(
      notifications,
    )..where((s) => s.uuid.equals(uuid))).getSingleOrNull());
  }

  Future<List<Notification>> getNotifications(String localId) {
    localDBLogger.info("Getting notifications for local id: $localId");
    return ((select(
      notifications,
    )..where((s) => s.localId.equals(localId))).get());
  }

  Stream<List<Notification>> watchNotifications(String localId) {
    localDBLogger.info("Watching notifications for local id: $localId");
    return (select(notifications)
          ..where((t) => t.localId.equalsNullable(localId))
          ..orderBy([(t) => OrderingTerm.desc(t.scheduledAt)]))
        .watch();
  }

  Future<void> upsertNotification(NotificationsCompanion companion) async {
    localDBLogger.info("Upserting notifications: $companion");
    await into(
      notifications,
    ).insert(companion, mode: InsertMode.insertOrReplace);
  }

  Future<void> batchUpsertNotifications(List<NotificationsCompanion> companion) async {
    localDBLogger.info("Upserting batch notifications...");
    await batch(
      (batch) => batch.insertAllOnConflictUpdate(notifications, companion),
    );
  }

  Future<void> removeNotification(String uuid) async {
    localDBLogger.info("Removing notification: $uuid");
    await (delete(notifications)..where((n) => n.uuid.equals(uuid))).go();
  }

  Future<int> cleanupOldNotifications() {
    return (delete(notifications)..where(
          (t) => t.scheduledAt.isSmallerThanValue(
            DateTime.now().subtract(cleanupNotificationThreshold),
          ),
        ))
        .go();
  }
}
