import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/profiles_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_service.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/profiles_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/users_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';

import '../../helper/mock_objects.dart';

class MockSyncService extends Mock implements SyncService {}

void main() {
  late ProviderContainer container;
  late ProfilesDAO pdao;
  late MockSyncService syncService;
  late String rid;

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

    pdao = ProfilesDAO(container.read(databaseProvider));

    final udao = UsersDAO(container.read(databaseProvider));
    rid = (await udao.insertRegisteredUserAndReturn(
      remoteId,
    )).toAppUser().remoteId!;
  });

  test('getProfile returns a user settings from remote id', () async {
    await pdao.upsertProfile(testAppRegisteredProfile.toCompanion(rid));
    final retrievedFromDao = (await pdao.getProfile(rid))?.toProfile();
    final retrievedFromRepo = await container
        .read(profilesRepositoryProvider)
        .getProfile(rid);
    expect(retrievedFromDao, retrievedFromRepo);
  });

  test('upsertProfile inserts and updates the user profile', () async {
    await pdao.upsertProfile(testAppRegisteredProfile.toCompanion(rid));
    final retrieved = (await pdao.getProfile(rid))?.toProfile();
    expect(retrieved, testAppRegisteredProfile);

    await container
        .read(profilesRepositoryProvider)
        .upsertProfile(
          rid,
          testAppRegisteredProfile.copyWith(username: "$username%1"),
        );
    final retrievedNew = (await pdao.getProfile(rid))?.toProfile();
    expect(retrievedNew, isNotNull);
    expect(retrievedNew, isNot(retrieved));
  });

  test('upsertProfileAndSync inserts and updates the user profile', () async {
    when(
      () => syncService.addJob(rid, SyncTable.profiles),
    ).thenAnswer((_) async {});

    await pdao.upsertProfile(testAppRegisteredProfile.toCompanion(rid));
    final retrieved = (await pdao.getProfile(rid))?.toProfile();
    expect(retrieved, testAppRegisteredProfile);

    await container
        .read(profilesRepositoryProvider)
        .upsertProfileAndSync(
          rid,
          testAppRegisteredProfile.copyWith(username: "$username%1"),
        );
    final retrievedNew = (await pdao.getProfile(rid))?.toProfile();
    expect(retrievedNew, isNotNull);
    expect(retrievedNew, isNot(retrieved));
    verify(() => syncService.addJob(rid, SyncTable.profiles)).called(1);
  });
}
