import 'package:drift/drift.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/schema.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:uuid/uuid.dart';

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

  Future<User> _insertUserAndReturn({
    String? remoteId,
    int maxRetries = 5,
  }) async {
    localDBLogger.fine("Inserting new user with remoteId: $remoteId");
    for (var i = 0; i < maxRetries; i++) {
      final uuid = Uuid().v4();
      try {
        // Check if uuid conflicts occur
        final uuidConflict = await _getUser(uuid);

        // No conflict, add and exit successfully
        if (uuidConflict == null) {
          localDBLogger.fine("Returning new user with remoteId: $remoteId");
          return (await into(users).insertReturning(
            // Default values are handled in database layer
            UsersCompanion(localId: Value(uuid), remoteId: Value(remoteId)),
          ));
        }
      } catch (e) {
        final s = e.toString();
        if (s.contains('UNIQUE constraint failed') &&
            s.contains('users.local_id')) {
          localDBLogger.shout("Expected warning caught: $e");
          continue; // continue uuid rare error until maxRetries reached
        }
        rethrow;
      }
    }
    // Normally maxRetries wouldn't have the same uuid unless all uuid's exhausted
    // Which is 2^122 possible numbers
    // That means if you get an error here, you definitely did something wrong
    localDBLogger.severe(
      "Could not find an unused UUID after $maxRetries attempts.",
    );
    throw Exception("Failed to insert new user: max UUID retries exceeded.");
  }
}
