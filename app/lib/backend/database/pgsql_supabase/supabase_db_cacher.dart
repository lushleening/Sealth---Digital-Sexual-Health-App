import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/supabase.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/notifications_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/profiles_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/settings_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_fetcher.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

part 'supabase_db_cacher.g.dart';

// Provider
@Riverpod(keepAlive: true)
SupabaseDBCacher supabaseDBCacher(Ref ref) {
  return SupabaseDBCacher(
    ref: ref,
    fetcher: ref.read(supabaseDBFetcherProvider),
  );
}

// Syncs Remote -> Local DB
// Only runs on login by design
class SupabaseDBCacher {
  final Ref ref;
  final SupabaseDBFetcher fetcher;
  SupabaseDBCacher({required this.ref, required this.fetcher});

  Future<void> cacheRemoteToLocal(String remoteId) async {
    // Future.wait can be used as the cacheFunctions are independent from each other
    // (no foreign key linking to each other)
    syncLogger.info("Caching all data of $remoteId from remote -> local db");
    final localId =
        (await ref.read(usersRepositoryProvider).getRegisteredUser(remoteId))
            ?.localId;
    if (localId == null) {
      throw Exception("LocalId for remoteId '$remoteId' does not exist");
    }
    await Future.wait([
      _cacheProfiles(localId, remoteId),
      _cacheSettings(localId, remoteId),
    ]);

    // As notifications can have too many rows, cache it in the background
    _cacheNotifications(localId, remoteId).catchError((e) {
        syncLogger.severe("Background notification caching failed: $e");
      });
    syncLogger.info("Primary caching completed. Notifications syncing in background.");
  }

  // Default value starts from remote
  Future<void> _cacheProfiles(String localId, String remoteId) async {
    syncLogger.info("Caching profile for $remoteId from remote -> local db");
    final data = await fetcher.fetchSingle(remoteId, FetchTools.profiles);
    await ref.read(profilesRepositoryProvider).upsertProfile(remoteId, data);
  }

  // Default value starts from local
  Future<void> _cacheSettings(String localId, String remoteId) async {
    syncLogger.info("Caching settings for $remoteId from remote -> local db");
    final data = await fetcher.fetchMaybeSingle(remoteId, FetchTools.settings);
    if (data != null) {
      await ref.read(settingsRepositoryProvider).upsertSetting(localId, data);
    }
  }

  Future<void> _cacheNotifications(String localId, String remoteId) async {
    syncLogger.info("Caching settings for $remoteId from remote -> local db");

    // User as receipient
    final dataToUser = await fetcher.fetchAllWithRemoteId(
      remoteId,
      FetchTools.notifications,
    );

    // All users as receipient
    final dataToAll = await fetcher.fetchAllWithColumnValue(
      remoteIdColName,
      null,
      FetchTools.notifications,
    );

    // Upsert all retrieved data
    await ref.read(notificationsRepositoryProvider).batchUpsertFromRemote(localId, [
      ...dataToUser,
      ...dataToAll,
    ]);
  }
}
