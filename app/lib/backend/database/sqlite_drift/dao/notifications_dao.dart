import 'package:drift/drift.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/schema.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

part 'notifications_dao.g.dart';

@DriftAccessor(tables: [Notifications])
class NotificationsDAO extends DatabaseAccessor<Database>
    with _$NotificationsDAOMixin {
  NotificationsDAO(super.attachedDatabase);

  Future<List<Notification>> getNotifications(String localId) async {
    localDBLogger.info("Getting notifications for local id: $localId");
    return (await (select(
      notifications,
    )..where((s) => s.localId.equals(localId))).get());
  }

  Future<void> upsertNotifications(
    NotificationsCompanion companion,
  ) async {
    localDBLogger.info("Upserting notifications: $companion");
    await into(
      notifications,
    ).insert(companion, mode: InsertMode.insertOrReplace);
  }
}
