import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/users_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

part 'users_repository.g.dart';

// Provider
@Riverpod(keepAlive: true)
UsersRepository usersRepository(Ref ref) {
  return UsersRepository(dao: UsersDAO(ref.read(databaseProvider)));
}

// Stores users in app (metadata)
// Check ProfilesRepository instead for user details like username, avatarUrl, etc.
class UsersRepository {
  final UsersDAO dao;
  UsersRepository({required this.dao});

  Future<AppUser> getOrCreateGuest() {
    // Get or create guest, local-only and one guest per device
    return dao.transaction(() async {
      User? guest = await dao.getGuestUser();
      guest ??= await dao.insertGuestUserAndReturn();
      localDBLogger.info("Inserted guest: $guest");
      return guest.toAppUser();
    });
  }

  Future<AppUser> getOrInsertRegisteredUser(String remoteId) {
    return dao.transaction(() async {
      User? user = await dao.getRegisteredUser(remoteId);
      user ??= await dao.insertRegisteredUserAndReturn(remoteId);
      localDBLogger.info("Inserted user: $user");
      return user.toAppUser();
    });
  }

  Future<void> deleteGuestUser() async {
    localDBLogger.info("Removing guest user...");
    final guest = await dao.getGuestUser();
    if (guest == null) {
      // An error to notify the devs, but no action is required to be taken
      localDBLogger.shout("Tried to remove guest user but it does not exist.");
      return;
    }
    return dao.deleteUserWithLocalId(guest.localId);
  }

  Future<void> deleteRegisteredUserLocalCache(String remoteId) async {
    await dao.deleteUserWithRemoteId(remoteId);
  }

  // Wrappers (prevents accessing the DAOs directly, and leave some space for future extensions)
  Future<AppUser> insertGuestUserAndReturn() async {
    return (await dao.insertGuestUserAndReturn()).toAppUser();
  }

  Future<AppUser?> getRegisteredUser(String remoteId) async {
    return (await dao.getRegisteredUser(remoteId))?.toAppUser();
  }

  Future<AppUser> updateLastLoginAndReturn(String localId) async {
    localDBLogger.info("Last login time of localId '$localId' updated.");
    return (await dao.updateLastLoginAndReturn(localId)).toAppUser();
  }
}

// Use extensions to prevent mistypes on long constructors
// Unnamed extensions can only be used on the same file
// Used to bind Repo with DAO and encourage usage of Repo over DAO on end-users
extension on User {
  AppUser toAppUser() => AppUser(
    localId: localId,
    remoteId: remoteId,
    lastLoggedIn: previousLoggedIn,
  );
}
