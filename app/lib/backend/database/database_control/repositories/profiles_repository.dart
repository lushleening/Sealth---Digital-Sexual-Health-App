import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/supabase.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_service.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_fetcher.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/profiles_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';

part 'profiles_repository.g.dart';

// Provider
@Riverpod(keepAlive: true)
ProfilesRepository profilesRepository(Ref ref) {
  return ProfilesRepository(
    ref: ref,
    dao: ProfilesDAO(ref.read(databaseProvider)),
  );
}

// Only registered users have profiles
class ProfilesRepository {
  final Ref ref;
  final ProfilesDAO dao;
  ProfilesRepository({required this.ref, required this.dao});

  Future<AppRegisteredProfile?> getProfile(String remoteId) async {
    localDBLogger.info(
      "Trying to fetch profile data of $remoteId from local db...",
    );
    final profile = await dao.getProfile(remoteId);
    return profile?.toProfile();
  }

  // Update profile without sync, used for remote db cacher ONLY
  // Use upsertProfileAndSync instead to update profile
  Future<void> upsertProfile(String remoteId, AppRegisteredProfile newProfile) {
    localDBLogger.info("Upserting profile data of $remoteId ($newProfile) to local db...");
    return dao.upsertProfile(newProfile.toCompanion(remoteId));
  }

  // Update profile and add new sync job to push to remote
  Future<bool> upsertProfileAndSync(
    String remoteId,
    AppRegisteredProfile newProfile, {
    bool checkForConflicts = false,
  }) async {
    if (checkForConflicts && (await _hasConflictRow(newProfile))) return false;
    await upsertProfile(remoteId, newProfile);
    localDBLogger.info("Adding sync job of profile for $remoteId...");
    await ref.read(syncServiceProvider).addJob(remoteId, SyncTable.profiles);
    return true;
    
  }

  // Check for row conflicts in both local and remote databases
  Future<bool> _hasConflictRow(AppRegisteredProfile newProfile) async {
    final foundLocal =
        (await dao.getProfileWithUsername(newProfile.username)) != null;
    if (foundLocal) return true;

    return (await ref
            .read(supabaseDBFetcherProvider)
            .fetchAllWithColumn(
              profileUsernameColName,
              newProfile.username,
              FetchTools.profiles,
            ))
        .isNotEmpty;
  }
}

// Use extensions to prevent mistypes on long constructors
// Unnamed extensions can only be used on the same file
// Used to bind Repo with DAO and encourage usage of Repo over DAO on end-users
extension on AppRegisteredProfile {
  ProfilesCompanion toCompanion(String remoteId) => ProfilesCompanion(
    remoteId: Value(remoteId),
    username: Value(username),
    avatarUrl: Value(avatarUrl),
    verified: Value(verified),
  );
}

extension on Profile {
  AppRegisteredProfile toProfile() => AppRegisteredProfile(
    username: username,
    avatarUrl: avatarUrl,
    verified: verified,
  );
}
