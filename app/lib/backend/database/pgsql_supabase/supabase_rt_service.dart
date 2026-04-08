import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/supabase.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/notifications_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/profiles_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/settings_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_rt_service.g.dart';

// This generates a stream to sync data between databases in real time
@Riverpod(keepAlive: true)
SupabaseRealtimeService supabaseRTService(Ref ref) {
  return SupabaseRealtimeService(ref: ref);
}

class SupabaseRealtimeService {
  final Ref ref;
  final Map<String, RealtimeChannel> _activeChannels = {};
  SupabaseRealtimeService({required this.ref});

  void subscribeToAll({required String localId, required String remoteId}) {
    subscribeToProfile(localId: localId, remoteId: remoteId);
    subscribeToSettings(localId: localId, remoteId: remoteId);
    subscribeToNotifications(localId: localId, remoteId: remoteId);
  }

  void subscribeToProfile({required String localId, required String remoteId}) {
    subscribeToTable<AppRegisteredProfile>(
      f: FetchTools.profiles,
      localId: localId,
      remoteId: remoteId,
      onUpdate: (localId, data) async {
        await ref
            .read(profilesRepositoryProvider)
            .upsertProfile(remoteId, data);
      },
    );
  }

  void subscribeToSettings({
    required String localId,
    required String remoteId,
  }) {
    subscribeToTable<AppSettings>(
      f: FetchTools.settings,
      localId: localId,
      remoteId: remoteId,
      onUpdate: (localId, data) async {
        await ref.read(settingsRepositoryProvider).upsertSetting(localId, data);
      },
    );
  }

  // For all notifications, when remoteId = supabaseId OR supabaseId = null (intended for all users)
  void subscribeToNotifications({
    required String localId,
    required String remoteId,
  }) {
    final f = FetchTools.notifications;
    final tableName = f.table.effectiveRemoteTableName;
    final channelKey = 'user:$remoteId:$tableName';
    _activeChannels[channelKey]?.unsubscribe(); // Cleanup in case exists

    final channel = ref.read(supabaseServiceProvider).channel(channelKey);
    channel.onSystemEvents((status, [error]) {
      remoteDBLogger.info('Channel Status: $status');
      if (error != null) remoteDBLogger.severe('Channel Error: $error');
    });
    final pg = channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: supabasePublicTable,
          table: tableName,
          callback: (payload) async {
            final event = payload.eventType;
            // Sync delete
            if (event == PostgresChangeEvent.delete) {
              final oldUUID = payload.oldRecord[uuidColName] as String;
              syncLogger.info("Deleting data from local db: $oldUUID");
              await ref
                  .read(notificationsRepositoryProvider)
                  .removeNotificationForLocal(AppNotifications.dummy(uuid: oldUUID));           
              return; // Exit early
            }

            try {
              final record = payload.newRecord;
              final rid = record[remoteIdColName] as String?;

              if (rid == null || rid == remoteId) {
                final data = f.fromJson(record);
                syncLogger.info("Syncing data to local db: $data");
                await ref
                    .read(notificationsRepositoryProvider)
                    .upsertNotificationToLocal(localId, data);
                remoteDBLogger.info("Realtime sync complete for $tableName");
              }
            } catch (e) {
              remoteDBLogger.severe("Error syncing notifications: $e");
            }
          },
        )
        .subscribe();
    _activeChannels[channelKey] = pg;
  }

  void subscribeToTable<T extends Syncable>({
    required FetchTools<T> f,
    required String localId,
    required String remoteId,
    required Future<void> Function(String localId, T data) onUpdate,
  }) {
    final tableName = f.table.effectiveRemoteTableName;
    final channelKey = 'user:$remoteId:$tableName';
    _activeChannels[channelKey]?.unsubscribe(); // Cleanup in case exists

    final channel = ref.read(supabaseServiceProvider).channel(channelKey);
    channel.onSystemEvents((status, [error]) {
      remoteDBLogger.info('Channel Status: $status');
      if (error != null) remoteDBLogger.info('Channel Error: $error');
    });

    final pg = channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: supabasePublicTable,
          table: tableName,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: remoteIdColName,
            value: remoteId,
          ),
          callback: (payload) async {
            // Update to the local db
            try {
              final data = f.fromJson(payload.newRecord);
              syncLogger.info("Syncing data to local db: $data");
              await onUpdate(localId, data);
              remoteDBLogger.info("Realtime sync complete for $tableName");
            } catch (e) {
              remoteDBLogger.severe("Error syncing $tableName: $e");
            }
          },
        )
        .subscribe();

    _activeChannels[channelKey] = pg;
  }

  void dispose() {
    for (final channel in _activeChannels.values) {
      channel.unsubscribe();
    }
    _activeChannels.clear();
  }
}
