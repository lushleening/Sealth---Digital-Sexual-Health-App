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

  setUp(() async {
    final db = Database(NativeDatabase.memory());
    container = ProviderContainer.test(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(() => db.close());

    pdao = ProfilesDAO(container.read(databaseProvider));

    // As profile relies on user remote id
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

  test('watchProfile emits new data when the database updates', () async {
    const test1 = 'test1';
    const test2 = 'test2';
    expectLater(
      pdao.watchProfile(remoteId),
      emitsInOrder([
        isA<Profile>().having((p) => p.username, 'username', test1),
        isA<Profile>().having((p) => p.username, 'username', test2),
      ]),
    );

    await pdao.upsertProfile(
      ProfilesCompanion.insert(remoteId: remoteId, username: test1),
    );

    await pdao.upsertProfile(
      ProfilesCompanion.insert(remoteId: remoteId, username: test2),
    );
  });
}
