import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/sync_queue_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';

import '../../helper/mock_objects.dart';

void main() {
  late ProviderContainer container;
  late SyncQueueDAO sqdao;
  late Database db;
  setUp(() async {
    db = Database(NativeDatabase.memory());
    container = ProviderContainer.test(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(() => db.close());
    sqdao = SyncQueueDAO(container.read(databaseProvider));
  });

  test(
    'addJob adds a job to the syncQueue table and getAllJobs returns all pending sync jobs',
    () async {
      final job = SyncJob(remoteId: remoteId, targetTable: SyncTable.settings);
      await sqdao.addJob(job);
      final retrieved = await sqdao.getAllJobs();
      expect(retrieved[0].remoteId, remoteId);
    },
  );

  test('removeJob removes a sync job', () async {
    final job = SyncJob(remoteId: remoteId, targetTable: SyncTable.settings);
    await sqdao.addJob(job);

    final retrieved = await sqdao.getAllJobs();
    expect(retrieved[0].remoteId, remoteId);

    await sqdao.removeJob(job);
    final retrievedNew = await sqdao.getAllJobs();
    expect(retrievedNew.length, 0);
  });
}
