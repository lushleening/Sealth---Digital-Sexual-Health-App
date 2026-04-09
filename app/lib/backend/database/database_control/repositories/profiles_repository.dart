import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/text_hints.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/profiles_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/snackbar/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Stream<AppRegisteredProfile?> watchProfile(String remoteId) {
    return dao.watchProfile(remoteId).map((s) => s?.toProfile()).distinct();
  }

  Future<AppRegisteredProfile?> getProfile(String remoteId) async {
    final profile = await dao.getProfile(remoteId);
    return profile?.toProfile();
  }

  // Update profile without sync, used for remote db cacher ONLY
  // Use upsertProfileAndSync instead to update profile
  Future<void> upsertProfile(
    String remoteId,
    AppRegisteredProfile newProfile,
  ) async {
    if ((await getProfile(remoteId)) == newProfile) return;
    try {
      localDBLogger.info(
        "Upserting profile data of $remoteId ($newProfile) to local db...",
      );
      await dao.upsertProfile(newProfile.toCompanion(remoteId));
    } catch (e) {
      localDBLogger.shout("Failed to upsert profile: $e");
    }
  }

  // Update profile remotely and let scbscription channel update it
  Future<void> upsertProfileRemote(
    String remoteId,
    AppRegisteredProfile newProfile,
  ) async {
    localDBLogger.info("Updating $remoteId's profile for remote database");

    // Treat as online only function and directly try sync
    const table = SyncTable.profiles;
    try {
      await SyncableEntity(
        data: newProfile,
        job: SyncJob(remoteId: remoteId, targetTable: table),
      ).upsert(ref.read(supabaseServiceProvider));

    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        // Username conflicts
        syncLogger.shout("Unique constraint failed on remote: ${e.message}");
        showSnackbarMessage("Username is taken. Please choose another one.");
      } else {
        syncLogger.shout("$unexpectedErr: ${e.message}");
      }
    }
  }
}

// Use extensions to prevent mistypes on long constructors
// Used to bind Repo with DAO and encourage usage of Repo over DAO on end-users
extension ProfileX on Profile {
  AppRegisteredProfile toProfile() => AppRegisteredProfile(
    username: username,
    avatarUrl: avatarUrl,
    verified: verified,
    updatedAt: updatedAt,
  );
}

extension AppRegisteredProfileX on AppRegisteredProfile {
  ProfilesCompanion toCompanion(String remoteId) => ProfilesCompanion(
    remoteId: Value(remoteId),
    username: Value(username),
    avatarUrl: Value(avatarUrl),
    verified: Value(verified),
    updatedAt: Value(updatedAt),
  );
}
