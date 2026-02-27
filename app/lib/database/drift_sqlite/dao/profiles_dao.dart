import 'package:drift/drift.dart';
import 'package:sddp_dsh/database/drift_sqlite/database.dart';
import 'package:sddp_dsh/database/drift_sqlite/schema.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/user/registered_profile.dart';

part 'profiles_dao.g.dart';

// TODO: Access and sync to supabase
@DriftAccessor(tables: [Users, Profiles])
class ProfilesDAO extends DatabaseAccessor<Database> with _$ProfilesDAOMixin {
  ProfilesDAO(super.attachedDatabase);

  Future<RegisteredProfile?> getProfile(String supabaseId) async {
    try {
      final row = await (select(users).join([
        leftOuterJoin(
          profiles,
          profiles.supabaseId.equalsExp(users.supabaseId),
        ),
      ])..where(users.supabaseId.equals(supabaseId))).getSingle();

      final profilePart = row.readTable(profiles);

      return RegisteredProfile(
        supabaseId: supabaseId,
        username: profilePart.username,
        email: profilePart.email,
        avatarUrl: profilePart.avatarUrl,
        verified: profilePart.verified,
      );
    } catch (e) {
      dbLogger.severe("ProfilesDAO: Unable to fetch data :: $e");
      return null;
    }
  }

  Future<void> insertOrUpdate(RegisteredProfile profile) async {
    try {
      await into(profiles).insertOnConflictUpdate(profile.toCompanion());
    } catch (e) {
      dbLogger.severe("ProfilesDAO: Unable to insert data :: $e");
    }
  }
}

extension on RegisteredProfile {
  ProfilesCompanion toCompanion() {
    return ProfilesCompanion(
      supabaseId: Value(supabaseId),
      username: Value(username),
      email: Value(email),
      avatarUrl: Value(avatarUrl),
      verified: Value(verified),
    );
  }
}

// TODO requires supabase integration
// I have user and profile
// User is used to differenciate between
// All users (guest or registered) have a row in user table
// Only registered users have a Profile
