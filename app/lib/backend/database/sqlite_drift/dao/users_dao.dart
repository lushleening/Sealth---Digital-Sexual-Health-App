import 'package:drift/drift.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/schema.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

part 'users_dao.g.dart';

// Layer between local database and repo
// Use usersRepoProvider in application instead
// DAO are short for database accessor objects
@DriftAccessor(tables: [Users])
class UsersDAO extends DatabaseAccessor<Database> with _$UsersDAOMixin {
  UsersDAO(super.attachedDatabase);

  Future<User?> getGuestUser() async {
    // Guest user has no remote id
    localDBLogger.info("Getting guest user");
    return (await (select(
      users,
    )..where((u) => u.remoteId.isNull())).getSingleOrNull());
  }

  Future<User?> getRegisteredUser(String remoteId) async {
    // Registered user has remote id
    localDBLogger.fine("Getting registered user with remoteId: $remoteId");
    return (await (select(
      users,
    )..where((u) => u.remoteId.equals(remoteId))).getSingleOrNull());
  }

  Future<User> insertGuestUserAndReturn() async {
    localDBLogger.fine("Inserting and returning new guest user");
    return _insertUserAndReturn();
  }

  Future<User> insertRegisteredUserAndReturn(String remoteId) async {
    localDBLogger.fine("Inserting registered user with remoteId: $remoteId");
    return _insertUserAndReturn(remoteId: remoteId);
  }

  Future<void> deleteUserWithLocalId(String localId) async {
    localDBLogger.fine("Deleting user with localId: $localId");
    await (delete(users)..where((t) => t.localId.equals(localId))).go();
  }

  Future<void> deleteUserWithRemoteId(String remoteId) async {
    localDBLogger.fine("Deleting user with remoteId: $remoteId");
    await (delete(users)..where((t) => t.remoteId.equals(remoteId))).go();
  }

  Future<User> updateLastLoginAndReturn(String localId) async {
    localDBLogger.fine("Updating last login for user: $localId");
    return transaction(() async {
      // User should not be null
      final row = await _getUser(localId);
      if (row == null) {
        throw StateError(
          "User $localId is not found, unable to update last login time",
        );
      }

      // Update login time
      final now = DateTime.now();
      final user =
          await (update(
            users,
          )..where((u) => u.localId.equals(localId))).writeReturning(
            UsersCompanion(
              previousLoggedIn: Value(row.currentLoggedIn),
              currentLoggedIn: Value(now),
            ),
          );
      localDBLogger.fine("User $user login time updated");
      return user.single;
    });
  }

  Future<User?> _getUser(String localId) async {
    // All users have local id
    localDBLogger.info("Getting user with localId: $localId");
    return (await (select(
      users,
    )..where((u) => u.localId.equals(localId))).getSingleOrNull());
  }

  // Previous uuid retry logic increases complexity and database operations
  // Wasting energy and introducing bugs, thus removing it
  Future<User> _insertUserAndReturn({String? remoteId}) async {
    localDBLogger.fine("Insert returning new user with remoteId: $remoteId");
    return (await into(users).insertReturning(
      UsersCompanion(remoteId: Value(remoteId)),
    ));
  }
}
