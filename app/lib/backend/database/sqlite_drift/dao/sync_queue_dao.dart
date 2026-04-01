import 'package:drift/drift.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/schema.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

part 'sync_queue_dao.g.dart';

// Layer between local database and repo
// Use syncServiceProvider in application instead
@DriftAccessor(tables: [SyncQueue])
class SyncQueueDAO extends DatabaseAccessor<Database> with _$SyncQueueDAOMixin {
  SyncQueueDAO(super.attachedDatabase);

  // Queue (user, tableName) to label sync
  Future<void> addJob(SyncJob j) async {
    localDBLogger.fine("Adding sync job: $j");
    await into(syncQueue).insert(
      SyncQueueCompanion(
        remoteId: Value(j.remoteId),
        targetTableName: Value(j.targetTable.effectiveLocalTableName),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  // await to prevent race conditions
  Future<List<SyncJob>> getAllJobs() async {
    localDBLogger.fine("Getting all sync jobs...");
    return (await select(
      syncQueue,
    ).get()).map((t) => SyncJob.fromSQLite(t)).toList();
  }

  // No await as its a background process
  Future<void> removeJob(SyncJob j) {
    localDBLogger.finer("Removing sync job: $j");
    return (delete(syncQueue)..where(
          (t) =>
              t.remoteId.equals(j.remoteId) &
              t.targetTableName.equals(j.targetTable.effectiveLocalTableName),
        ))
        .go();
  }
}

// ------------- Sync DAO Function Usage Example -------------
// Future<void> updateX(X newX) async {
//   final user = (await ref.read(appUserProvider.future));
//   await dao.insertX(user.localId, newX);
//   await SyncQueueDAO(
//     ref.read(databaseProvider),
//   ).addJob(user.remoteId, SyncTables.X);
// }
// -----------------------------------------------------------
