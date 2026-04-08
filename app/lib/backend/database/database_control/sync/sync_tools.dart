import 'package:sddp_dsh/backend/constants/supabase.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Used to fetch data from remote db to local db
enum FetchTools<T extends Syncable> {
  profiles(table: SyncTable.profiles, fromJson: AppRegisteredProfile.fromJson),
  settings(table: SyncTable.settings, fromJson: AppSettings.fromJson),
  notifications(table: SyncTable.notifications, fromJson: AppNotifications.fromJson);

  final SyncTable table;
  final T Function(Map<String, dynamic>) fromJson;
  const FetchTools({required this.table, required this.fromJson});
}

// Add your table names here to use syncing with remote db
// Use the params if needed
enum SyncTable {
  settings,
  profiles,
  notifications;

  // In case the table names for databases are different
  // ignore: unused_element_parameter
  const SyncTable({this.localTableName, this.remoteTableName});

  final String? localTableName;
  final String? remoteTableName;

  String get effectiveLocalTableName => localTableName ?? name;
  String get effectiveRemoteTableName => remoteTableName ?? name;

  static SyncTable? fromLocalName(String name) {
    return SyncTable.values.cast<SyncTable?>().firstWhere(
      (e) => e?.effectiveLocalTableName == name,
      orElse: () => null,
    );
  }
}

// All data that can be uploaded to remote db must do "implements Syncable"
abstract class Syncable {
  Map<String, dynamic> toJson();
}

// Used to sync data from local -> remote db
class SyncableEntity<T extends Syncable> {
  final T data;
  final SyncJob job;
  SyncableEntity({required this.data, required this.job});

  // Appends remote id for remote database sync
  Map<String, dynamic> toSyncJson() => {
    ...data.toJson(),
    remoteIdColName: job.remoteId,
  };

  Future<void> upsert(SupabaseClient client, {String onConflict = remoteIdColName}) async {
    syncLogger.info("Upserting data to remote database");
    await client
        .from(job.targetTable.effectiveRemoteTableName)
        .upsert(toSyncJson(), onConflict: onConflict);
  }
}

// Generates a job to sync from local -> remote db
class SyncJob {
  final String remoteId;
  final SyncTable targetTable;

  SyncJob({required this.remoteId, required this.targetTable});

  factory SyncJob.fromSQLite(SyncQueueData data) {
    final tableEnum = SyncTable.fromLocalName(data.targetTableName);
    if (tableEnum == null) {
      localDBLogger.shout(
        "Table ${data.targetTableName} is not a valid SyncTable",
      );
      throw Exception("Could not sync data");
    }
    return SyncJob(remoteId: data.remoteId, targetTable: tableEnum);
  }
}
