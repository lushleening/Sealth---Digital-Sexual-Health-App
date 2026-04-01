import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/users_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';

import '../../helper/mock_objects.dart';

void main() {
  late ProviderContainer container;
  late UsersDAO dao;

  setUp(() {
    final db = Database(NativeDatabase.memory());
    container = ProviderContainer.test(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    dao = UsersDAO(container.read(databaseProvider));
    addTearDown(() => db.close());
  });

  test('insertGuestUserAndReturn creates a user with null remoteId', () async {
    final user = await dao.insertGuestUserAndReturn();
    expect(user.remoteId, isNull);
    final retrieved = await dao.getGuestUser();
    expect(retrieved?.localId, user.localId);
  });

  test('insertRegisteredUserAndReturn creates a user with remoteId', () async {
    final user = await dao.insertRegisteredUserAndReturn(remoteId);
    expect(user.remoteId, remoteId);
    final guest = await dao.getGuestUser();
    expect(guest, isNull);
    final reg = await dao.getRegisteredUser(remoteId);
    expect(reg, isNotNull);
  });

  test('updateLastLoginAndReturn throws StateError if user missing', () async {
    expect(
      () => dao.updateLastLoginAndReturn('does-not-exist'),
      throwsStateError,
    );
  });

  test('deleteUserWithRemoteId removes the correct user', () async {
    await dao.insertRegisteredUserAndReturn('to-delete');
    expect(await dao.getRegisteredUser('to-delete'), isNotNull);
    await dao.deleteUserWithRemoteId('to-delete');
    expect(await dao.getRegisteredUser('to-delete'), isNull);
  });
}
