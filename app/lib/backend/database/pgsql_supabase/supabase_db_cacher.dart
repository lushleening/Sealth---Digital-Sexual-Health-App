import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    syncLogger.fine("Caching all data of $remoteId from remote -> local db");
    final localId =
        (await ref.read(usersRepositoryProvider).getRegisteredUser(remoteId))
            ?.localId;
    if (localId == null) {
      throw Exception("LocalId for remoteId '$remoteId' does not exist");
    }
    await Future.wait([
      _cacheProfiles(localId, remoteId),
      _cacheSettings(localId, remoteId),
      _cacheNotifications(localId, remoteId),
    ]);
  }

  // Default value starts from remote
  Future<void> _cacheProfiles(String localId, String remoteId) async {
    syncLogger.fine("Caching profile for $remoteId from remote -> local db");
    final data = await fetcher.fetchSingle(remoteId, FetchTools.profiles);
    await ref.read(profilesRepositoryProvider).upsertProfile(remoteId, data);
  }

  // Default value starts from local
  Future<void> _cacheSettings(String localId, String remoteId) async {
    syncLogger.fine("Caching settings for $remoteId from remote -> local db");
    final data = await fetcher.fetchMaybeSingle(remoteId, FetchTools.settings);
    if (data != null) {
      await ref.read(settingsRepositoryProvider).upsertSettings(localId, data);
    }
  }

  Future<void> _cacheNotifications(String localId, String remoteId) async {
    // TODO
    //   final data = await fetcher.fetchSingle(
    //     remoteId!,
    //     FetchTools.settings,
    //   );

    //   SettingsDAO(ref.read(databaseProvider)).updateSettings(localId, data);
  }
}
