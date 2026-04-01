import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/settings_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_service.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/sync_queue_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';

import '../../helper/mock_objects.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockSyncService extends Mock implements SyncService {}

void main() {
  late ProviderContainer container;
  late SyncQueueDAO sqdao;
  late MockUsersRepository mockUsersRepository;
  late MockSettingsRepository mockSettingsRepository;

  setUp(() {
    final db = Database(NativeDatabase.memory());

    mockUsersRepository = MockUsersRepository();
    mockSettingsRepository = MockSettingsRepository();

    container = ProviderContainer.test(
      overrides: [
        databaseProvider.overrideWithValue(db),
        usersRepositoryProvider.overrideWithValue(mockUsersRepository),
        settingsRepositoryProvider.overrideWithValue(mockSettingsRepository),
      ],
    );
    addTearDown(() => db.close());

    sqdao = SyncQueueDAO(container.read(databaseProvider));
  });

  test("addJob adds a new job to the database", () async {
    final notifier = container.read(syncServiceProvider.notifier);
    notifier.addJob(remoteId, SyncTable.settings);
    expect((await sqdao.getAllJobs()).length, 1);
  });

  test("processQueue does not remove job on fail", () async {
    final notifier = container.read(syncServiceProvider.notifier);
    notifier.addJob(remoteId, SyncTable.settings);
    expect((await sqdao.getAllJobs()).length, 1);

    await notifier.processQueue();
    expect((await sqdao.getAllJobs()).length, 1);
  });

  test(
    "processQueue calls the respective repository based on sync table type",
    () async {
      final notifier = container.read(syncServiceProvider.notifier);

      final mockUser = testRegisteredAppUser;
      when(
        () => mockUsersRepository.getRegisteredUser(mockUser.remoteId!),
      ).thenAnswer((_) async => mockUser);

      when(
        () => mockSettingsRepository.getSettings(mockUser.localId),
      ).thenAnswer((_) async => testAppSettings);

      await sqdao.addJob(
        SyncJob(remoteId: remoteId, targetTable: SyncTable.settings),
      );
      expect((await sqdao.getAllJobs()).length, 1);

      await notifier.processQueue();
      verify(
        () => mockUsersRepository.getRegisteredUser(mockUser.remoteId!),
      ).called(1);
      verify(
        () => mockSettingsRepository.getSettings(mockUser.localId),
      ).called(1);
    },
  );
}
