import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/settings_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_service.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/settings_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/users_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';

import '../../helper/mock_objects.dart';

void main() {
  late ProviderContainer container;
  late SettingsDAO sdao;
  late MockSyncService syncService;
  late String localId;

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

    sdao = SettingsDAO(container.read(databaseProvider));

    final udao = UsersDAO(container.read(databaseProvider));
    localId = (await udao.insertRegisteredUserAndReturn(
      remoteId,
    )).toAppUser().localId;
  });

  test('getSettings returns a user settings from local id', () async {
    await sdao.upsertSettings(testAppSettings.toCompanion(localId));
    final retrievedFromDao = (await sdao.getSettings(localId)).toAppSettings();
    final retrievedFromRepo = await container
        .read(settingsRepositoryProvider)
        .getSetting(localId);
    expect(retrievedFromDao, retrievedFromRepo);
  });

  test('upsertSettings inserts and updates the user profile', () async {
    await sdao.upsertSettings(testAppSettings.toCompanion(localId));
    final retrieved = (await sdao.getSettings(localId)).toAppSettings();
    expect(retrieved, testAppSettings);

    await container
        .read(settingsRepositoryProvider)
        .upsertSetting(
          localId,
          testAppSettings.copyWith(darkMode: !retrieved.darkMode),
        );
    final retrievedNew = (await sdao.getSettings(localId)).toAppSettings();
    expect(retrievedNew, isNot(retrieved));
  });

  test('updateSettingsAndSync inserts and updates the user profile', () async {
    when(
      () => syncService.addJob(remoteId, SyncTable.settings),
    ).thenAnswer((_) async {});

    await sdao.upsertSettings(testAppSettings.toCompanion(localId));
    final retrieved = (await sdao.getSettings(localId)).toAppSettings();
    expect(retrieved, testAppSettings);

    await container
        .read(settingsRepositoryProvider)
        .updateSettingAndSync(
          localId: localId,
          remoteId: remoteId,
          newSettings: testAppSettings.copyWith(darkMode: !retrieved.darkMode),
        );
    final retrievedNew = (await sdao.getSettings(localId)).toAppSettings();
    expect(retrievedNew, isNot(retrieved));
    verify(() => syncService.addJob(remoteId, SyncTable.settings)).called(1);
  });
}
