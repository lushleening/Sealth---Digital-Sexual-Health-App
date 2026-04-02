import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/settings_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/settings_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/users_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';

import '../../helper/mock_objects.dart';

void main() {
  late ProviderContainer container;
  late SettingsDAO sdao;
  late String localId;

  setUp(() async {
    final db = Database(NativeDatabase.memory());
    container = ProviderContainer.test(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(() => db.close());

    sdao = SettingsDAO(container.read(databaseProvider));

    final udao = UsersDAO(container.read(databaseProvider));
    localId = (await udao.insertGuestUserAndReturn()).toAppUser().localId;
  });

  test('getSettings returns a user settings from local id', () async {
    await sdao.upsertSettings(testAppSettings.toCompanion(localId));
    final retrieved = (await sdao.getSettings(localId)).toAppSettings();
    expect(retrieved, testAppSettings);
  });

  test('upsertSettings inserts and updates the user profile', () async {
    await sdao.upsertSettings(testAppSettings.toCompanion(localId));
    final retrieved = (await sdao.getSettings(localId)).toAppSettings();
    expect(retrieved, testAppSettings);
    await sdao.upsertSettings(
      testAppSettings
          .copyWith(darkMode: !retrieved.darkMode)
          .toCompanion(localId),
    );
    final retrievedNew = (await sdao.getSettings(localId)).toAppSettings();
    expect(retrievedNew, isNot(retrieved));
  });
}
