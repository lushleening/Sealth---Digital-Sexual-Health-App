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
          ..where((t) => t.hasRemoved.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.scheduledAt)]))
        .watch();
  }

  Future<void> upsertNotification(NotificationsCompanion companion) async {
    localDBLogger.info("Upserting notification: $companion");
    await into(
      notifications,
    ).insert(companion, mode: InsertMode.insertOrReplace);
  }

  Future<void> batchUpsertNotifications(
    List<NotificationsCompanion> companions,
  ) async {
    localDBLogger.info("Upserting batch notifications...");

    // Filter validCompanions to update by checking existing flags
    final uuids = companions.map((c) => c.uuid.value).toList();
    final existingEntries = await (select(
      notifications,
    )..where((t) => t.uuid.isIn(uuids))).get();

    final existingMap = {for (var e in existingEntries) e.uuid: e};

    final List<NotificationsCompanion> validCompanions = [];
    for (final c in companions) {
      final entry = existingMap[c.uuid.value];

      if (entry == null) {
        validCompanions.add(c);
      } else {
        if (c.updatedAt.value.isAfter(entry.updatedAt)) {
          validCompanions.add(
            c.copyWith(
              hasRead: Value(entry.hasRead),
              hasRemoved: Value(entry.hasRemoved),
            ),
          );
        }
      }
    }
    if (validCompanions.isNotEmpty) {
      await batch((b) {
        b.insertAllOnConflictUpdate(notifications, validCompanions);
      });
    }
  }

  Future<void> removeNotificationForLocal(String uuid) async {
    localDBLogger.info("Removing notification from local db: $uuid");
    await (delete(notifications)..where((n) => n.uuid.equals(uuid))).go();
  }
    // upsertNotification(n.copyWith(hasRemoved: true));

  Future<int> cleanupOldNotifications() {
    return (delete(notifications)..where(
          (t) => t.scheduledAt.isSmallerThanValue(
            DateTime.now().subtract(cleanupNotificationThreshold),
          ),
        ))
        .go();
  }
}
