import 'package:drift/drift.dart';
import 'package:sddp_dsh/database/drift_sqlite/database.dart';
import 'package:sddp_dsh/database/drift_sqlite/schema.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/user/app_user.dart';
import 'package:uuid/uuid.dart';

part 'users_dao.g.dart';

// DAO are short for database accessor objects
@DriftAccessor(tables: [Users])
class UsersDAO extends DatabaseAccessor<Database> with _$UsersDAOMixin {
  UsersDAO(super.attachedDatabase);

  // If guest exists, use that guest, else create a new guest for use
  Future<AppUser> getOrCreateNewGuest() async => transaction(() async {
    // Transaction allows atomic operations and prevents race condition
    // use that when a function consists of multiple queries (insert + select in this case)
    return _getOrInsertUser(isGuest: true);
  });

  // Similar to function above but for registered users
  Future<AppUser> getOrCreateRegisteredUser(String supabaseId) async {
    return transaction(() async {
      return _getOrInsertUser(supabaseId: supabaseId, isGuest: false);
    });
  }

  // Ensures the user exists, inserts into db if missing, and returns the user
  Future<AppUser> _getOrInsertUser({
    String? supabaseId,
    required bool isGuest,
    int maxRetries = 5,
  }) async {
    // Use existing user if exists
    final user = isGuest
        ? await (select(
            users,
          )..where((u) => u.isGuest.equals(true))).getSingleOrNull()
        : await (select(
            users,
          )..where((u) => u.supabaseId.equals(supabaseId!))).getSingleOrNull();
    if (user != null) return _updateUserLoginTimeAndReturn(user);

    // Else, create and insert new user to local
    for (var i = 0; i < maxRetries; i++) {
      final uuid = Uuid().v4();
      final uuidConflict = await (select(
        users,
      )..where((u) => u.localId.equals(uuid))).getSingleOrNull();

      // No conflict, add and exit successfully
      if (uuidConflict == null) {
        final now = DateTime.now();
        await into(users).insert(
          UsersCompanion(
            localId: Value(uuid),
            supabaseId: Value(supabaseId),
            isGuest: Value(isGuest),
            lastLoggedIn: Value(now),
          ),
        );
        return _mapDBToAppUser(
          await (select(
            users,
          )..where((u) => u.localId.equals(uuid))).getSingle(),
        );
      }
    }
    dbLogger.severe(
      "Could not find an unused UUID after $maxRetries attempts.",
    );
    throw Exception("Failed to insert new user: max UUID retries exceeded.");
  }

  // Helper methods
  Future<AppUser> _updateUserLoginTimeAndReturn(User user) async {
    final now = DateTime.now();
    await (update(users)..where((u) => u.localId.equals(user.localId))).write(
      UsersCompanion(lastLoggedIn: Value(now)),
    );
    return _mapDBToAppUser(user.copyWith(lastLoggedIn: now));
  }

  AppUser _mapDBToAppUser(User u) {
    return AppUser(
      localId: u.localId,
      supabaseId: u.supabaseId,
      isGuest: u.isGuest,
      lastLoggedIn: u.lastLoggedIn,
    );
  }
}
