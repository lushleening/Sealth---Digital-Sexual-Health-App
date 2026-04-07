import 'package:drift/drift.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/schema.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

part 'notifications_dao.g.dart';

@DriftAccessor(tables: [Notifications])
class NotificationsDAO extends DatabaseAccessor<Database>
    with _$NotificationsDAOMixin {
  NotificationsDAO(super.attachedDatabase);

  Future<List<Notification>> getNotifications(String localId) {
    localDBLogger.info("Getting notifications for local id: $localId");
    return ((select(
      notifications,
    )..where((s) => s.localId.equals(localId) | s.localId.isNull())).get());
  }

  Stream<List<Notification>> watchNotifications(String? localId) {
    localDBLogger.info("Watching notifications for local id: $localId");
    return (select(notifications)
          ..where((t) => t.localId.equalsNullable(localId) | t.localId.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.scheduledAt)]))
        .watch();
  }

  Future<void> upsertNotifications(NotificationsCompanion companion) async {
    localDBLogger.info("Upserting notifications: $companion");
    await into(
      notifications,
    ).insert(companion, mode: InsertMode.insertOrReplace);
  }

  Future<void> removeNotification(int id) async {
    localDBLogger.info("Removing notification: $id");
    await (delete(notifications)..where((n) => n.id.equals(id))).go();
  }
}
