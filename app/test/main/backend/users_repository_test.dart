import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_service.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/users_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';

import '../../helper/mock_objects.dart';

class MockSyncService extends Mock implements SyncService {}

void main() {
  late ProviderContainer container;
  late UsersDAO udao;
  late MockSyncService syncService;

  setUp(() async {
    final db = Database(NativeDatabase.memory());
    syncService = MockSyncService();

    container = ProviderContainer.test(
      overrides: [
        databaseProvider.overrideWithValue(db),
        syncServiceProvider.overrideWithValue(syncService),
      ],
    );
    addTearDown(() => db.close());

    udao = UsersDAO(container.read(databaseProvider));
  });

  test('getOrCreateGuest returns a guest user and subsequent calls return the same user', () async {
    final notifier = container.read(usersRepositoryProvider);
    final user1 = await notifier.getOrCreateGuest();
    final user2 = await notifier.getOrCreateGuest();
    expect(user1, isNotNull);
    expect(user1.localId, user2.localId);
  });

  test('getOrInsertRegisteredUser returns a registered user and subsequent calls return the same user', () async {
    final notifier = container.read(usersRepositoryProvider);
    final user1 = await notifier.getOrInsertRegisteredUser(remoteId);
    final user2 = await notifier.getOrInsertRegisteredUser(remoteId);
    expect(user1, isNotNull);
    expect(user1.localId, user2.localId);
  });

  test('deleteGuestUser deletes the specified user from the database', () async {
    final notifier = container.read(usersRepositoryProvider);
    await udao.insertGuestUserAndReturn();

    final user = await notifier.getOrCreateGuest();
    expect(user, isNotNull);
    
    await notifier.deleteGuestUser();

    final deletedUser = await udao.getGuestUser();
    expect(deletedUser, isNull);
  });


  test('deleteRegisteredUserLocalCache deletes the specified user from the database', () async {
    final notifier = container.read(usersRepositoryProvider);
    await udao.insertRegisteredUserAndReturn(remoteId);

    final user = await notifier.getRegisteredUser(remoteId);
    expect(user, isNotNull);
    
    await notifier.deleteRegisteredUserLocalCache(remoteId);

    final deletedUser = await notifier.getRegisteredUser(remoteId);
    expect(deletedUser, isNull);
  });

  // Other functions are just wrappers are just for the dao, 
  // check users_dao_test.dart dao for their tests
}