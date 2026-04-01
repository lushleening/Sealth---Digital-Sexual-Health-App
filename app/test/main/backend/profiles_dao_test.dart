import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/profiles_repository.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/profiles_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/users_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';

import '../../helper/mock_objects.dart';

void main() {
  late ProviderContainer container;
  late ProfilesDAO pdao;
  late Database db;
  setUp(() async {
    db = Database(NativeDatabase.memory());
    container = ProviderContainer.test(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(() => db.close());

    pdao = ProfilesDAO(container.read(databaseProvider));

    final udao = UsersDAO(container.read(databaseProvider));
    await udao.insertRegisteredUserAndReturn(remoteId);
  });

  test('getProfile returns a user profile from remoteId', () async {
    await pdao.upsertProfile(testAppRegisteredProfile.toCompanion(remoteId));
    final retrieved = await pdao.getProfile(remoteId);
    expect(retrieved?.remoteId, remoteId);
  });

  test('getProfileWithUsername returns a user profile from username', () async {
    await pdao.upsertProfile(testAppRegisteredProfile.toCompanion(remoteId));
    final retrieved = await pdao.getProfileWithUsername(username);
    expect(retrieved?.username, username);
  });

  test('upsertProfile inserts and updates the user profile', () async {
    final retrieveNull = await pdao.getProfile(remoteId);
    expect(retrieveNull, isNull);

    await pdao.upsertProfile(testAppRegisteredProfile.toCompanion(remoteId));
    final retrieved = await pdao.getProfile(remoteId);
    expect(retrieved?.remoteId, remoteId);

    await pdao.upsertProfile(
      testAppRegisteredProfile
          .copyWith(username: newUsername)
          .toCompanion(remoteId),
    );
    final retrievedNew = await pdao.getProfile(remoteId);
    expect(retrievedNew?.username, newUsername);
  });
}


// // Layer between local database and repo
// // Use ProfilesRepoProvider in application instead 
// @DriftAccessor(tables: [Profiles])
// class ProfilesDAO extends DatabaseAccessor<Database> with _$ProfilesDAOMixin {
//   ProfilesDAO(super.attachedDatabase);

//   Future<Profile?> getProfile(String remoteId) async {
//     localDBLogger.fine("Getting profile for remoteId: $remoteId");
//     return (await (select(
//       profiles,
//     )..where((p) => p.remoteId.equals(remoteId))).getSingleOrNull());
//   }

//   Future<Profile?> getProfileWithUsername(String username) async {
//     localDBLogger.fine("Getting profile for username: $username");
//     return (await (select(
//       profiles,
//     )..where((p) => p.username.equals(username))).getSingleOrNull());
//   }

//   Future<void> upsertProfile(ProfilesCompanion companion) async {
//     localDBLogger.fine("Upserting profile for companion: $companion");
//     await into(profiles).insertOnConflictUpdate(companion);
//   }
// }
