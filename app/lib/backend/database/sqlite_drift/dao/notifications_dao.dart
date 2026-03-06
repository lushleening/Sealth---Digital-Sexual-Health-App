import 'package:drift/drift.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/schema.dart';

part 'notifications_dao.g.dart';

// THIS PART IS NOT USABLE YET
// TODO
@DriftAccessor(tables: [Notifications])
class NotificationsDAO extends DatabaseAccessor<Database>
    with _$NotificationsDAOMixin {
  NotificationsDAO(super.attachedDatabase);

  Future<List<Notification?>> getNotifications(String localId) async {
    return (await (select(
      notifications,
    )..where((s) => s.localId.equals(localId))).get());
  }

  // UserContext is passed in application layer only, DO NOT place it here
  // Just give the DAOs what they need only
  Future<void> addNotifications(
    String localId,
    NotificationsCompanion newNotifications,
  ) async {
    await into(notifications).insert(newNotifications);
  }
}
