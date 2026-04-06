import 'package:drift/drift.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/schema.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

part 'profiles_dao.g.dart';

// Layer between local database and repo
// Use ProfilesRepoProvider in application instead
@DriftAccessor(tables: [Profiles])
class ProfilesDAO extends DatabaseAccessor<Database> with _$ProfilesDAOMixin {
  ProfilesDAO(super.attachedDatabase);

  Stream<Profile?> watchProfile(String remoteId) {
    localDBLogger.info("Watching profile for remoteId: $remoteId");
    return (select(
      profiles,
    )..where((t) => t.remoteId.equals(remoteId))).watchSingleOrNull();
  }

  Future<Profile?> getProfile(String remoteId) async {
    localDBLogger.info("Getting profile for remoteId: $remoteId");
    return (await (select(
      profiles,
    )..where((p) => p.remoteId.equals(remoteId))).getSingleOrNull());
  }

  Future<Profile?> getProfileWithUsername(String username) async {
    localDBLogger.info("Getting profile for username: $username");
    return (await (select(
      profiles,
    )..where((p) => p.username.equals(username))).getSingleOrNull());
  }

  Future<void> upsertProfile(ProfilesCompanion companion) async {
    localDBLogger.info("Upserting profile for companion: $companion");
    await into(profiles).insertOnConflictUpdate(companion);
  }
}
