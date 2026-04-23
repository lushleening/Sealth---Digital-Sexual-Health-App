import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/appointment_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/settings_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/sync_queue_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

part 'sync_service.g.dart';

// Syncs local -> remote db
@Riverpod(keepAlive: true)
class SyncService extends _$SyncService {
  late final SyncQueueDAO _dao;
  bool _isRunning = false;

  @override
  SyncService build() {
    _dao = SyncQueueDAO(ref.read(databaseProvider));
    return this;
  }

  Future<void> addJob(String? remoteId, SyncTable targetTableName) async {
    if (remoteId == null) return; // No sync if not registered
    syncLogger.info("Adding new sync job for $remoteId");
    _dao.addJob(SyncJob(remoteId: remoteId, targetTable: targetTableName));
    unawaited(processQueue()); // Optimistically syncs to supabase
  }

  // Processes all of the the Syncjobs
  Future<void> processQueue() async {
    syncLogger.fine("Processing all sync jobs");
    if (_isRunning) return;
    _isRunning = true;

    try {
      final jobs = await _dao.getAllJobs();
      try {
        for (final job in jobs) {
          await _syncJob(job);
          await _dao.removeJob(job);
        }
      } catch (_) {
        // Leave it back in queue for retry
      }
    } catch (e) {
      localDBLogger.shout("An error occured during sync: $e");
    } finally {
      _isRunning = false;
    }
  }

Future<void> _syncJob(SyncJob job) async {
  final user = (await ref
      .read(usersRepositoryProvider)
      .getRegisteredUser(job.remoteId));
  if (user == null) return;

  switch (job.targetTable) {
    case SyncTable.settings:
      final data = await ref
          .read(settingsRepositoryProvider)
          .getSetting(user.localId);
      await SyncableEntity(data: data, job: job)
          .upsert(ref.read(supabaseServiceProvider));
          break;

    case SyncTable.appointments:  // Add this case
      final appointments = await ref
          .read(appointmentRepositoryProvider)
          .getPendingAppointments(user.localId, job.remoteId);
      
      for (final appointment in appointments) {
        syncLogger.info("Syncing appointment ${appointment.id}");
        await SyncableEntity(data: appointment, job: job)
            .upsert(ref.read(supabaseServiceProvider));
        await ref.read(appointmentRepositoryProvider).markAsSynced(appointment.id);
      }
      break;

    default:
      throw StateError(
        "Sync function for table ${job.targetTable.effectiveRemoteTableName} currently not implemented.",
      );
  }
}
}