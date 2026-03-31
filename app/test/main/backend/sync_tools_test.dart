import 'package:sddp_dsh/backend/constants/supabase.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:test/test.dart';

import '../../helper/mock_objects.dart';

const k = 'key';
const v = 'val';

class MockSyncable implements Syncable {
  @override
  Map<String, dynamic> toJson() => {k: v};
}

void main() {
  group('SyncTable Tests', () {
    test('effectiveRemoteTableName names mapping are correct', () {
      expect(SyncTable.profiles.effectiveRemoteTableName, 'profiles');
    });

    test('fromLocalName names mapping are correct', () {
      final result = SyncTable.fromLocalName('settings');
      expect(result, SyncTable.settings);
    });

    test('fromLocalName returns null for invalid name', () {
      final result = SyncTable.fromLocalName('not_exists');
      expect(result, isNull);
    });
  });

  group('FetchTools Tests', () {
    test('profiles maps to the correct SyncTable', () {
      expect(FetchTools.profiles.table, SyncTable.profiles);
    });
  });

  group('SyncJob Tests', () {
    test('SyncJob.fromSQLite creates valid job from valid data', () {
      final mockData = SyncQueueData(
        remoteId: remoteId,
        targetTableName: 'profiles',
      );
      final job = SyncJob.fromSQLite(mockData);
      expect(job.remoteId, remoteId);
      expect(job.targetTable, SyncTable.profiles);
    });

    test('SyncJob.fromSQLite throws Exception on invalid table name', () {
      final mockData = SyncQueueData(
        remoteId: remoteId,
        targetTableName: 'invalid_table',
      );
      expect(() => SyncJob.fromSQLite(mockData), throwsException);
    });
  });

  group('SyncableEntity Tests', () {
    test('toSyncJson appends remoteId to the original data', () {
      final data = MockSyncable();
      final job = SyncJob(remoteId: remoteId, targetTable: SyncTable.settings);
      final entity = SyncableEntity(data: data, job: job);
      final json = entity.toSyncJson();
      expect(json[k], v);
      expect(json[remoteIdColName], remoteId);
      expect(json.length, 2);
    });
  });
}
