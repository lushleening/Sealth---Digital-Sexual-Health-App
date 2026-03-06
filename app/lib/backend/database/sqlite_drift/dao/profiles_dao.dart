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

  Future<Profile?> getProfile(String remoteId) async {
    localDBLogger.fine("Getting profile for remoteId: $remoteId");
    return (await (select(
      profiles,
    )..where((p) => p.remoteId.equals(remoteId))).getSingleOrNull());
  }

  Future<void> upsertProfile(ProfilesCompanion companion) async {
    localDBLogger.fine("Upserting profile for companion: $companion");
    await into(profiles).insertOnConflictUpdate(companion);
  }
}
