import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/profiles_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_service.dart';
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

  // As upsertProfileAndSync heavily relies on realtime service, test behaviors there instead
}

// TODO
// test('Realtime service updates local DB when remote change occurs', () async {
//   // 1. Setup mocks
//   final mockClient = MockSupabaseClient();
//   final mockChannel = MockRealtimeChannel(); // You'll need to mock this
  
//   // 2. Capture the callback
//   Function(PostgresChangePayload)? capturedCallback;

//   when(() => mockClient.channel(any())).thenReturn(mockChannel);
//   when(() => mockChannel.onPostgresChanges(
//     event: any(named: 'event'),
//     schema: any(named: 'schema'),
//     table: any(named: 'table'),
//     filter: any(named: 'filter'),
//     callback: any(named: 'callback'), // Capture this!
//   )).thenAnswer((invocation) {
//     capturedCallback = invocation.namedArguments[#callback];
//     return mockChannel;
//   });
//   when(() => mockChannel.subscribe()).thenReturn(mockChannel);

//   // 3. Initialize the service
//   final rtService = container.read(supabaseRTServiceProvider);
//   rtService.subscribeToProfile(localId: 'L1', remoteId: 'R1');

//   // 4. Manually trigger the "Realtime" event
//   final mockPayload = PostgresChangePayload(
//     schema: 'public',
//     table: 'profiles',
//     commitTimestamp: DateTime.now().toIso8601String(),
//     eventType: PostgresChangeEvent.update,
//     newRecord: {
//       'username': 'new_awesome_username',
//       'remote_id': 'R1',
//     },
//     oldRecord: {},
//   );

//   await capturedCallback!(mockPayload); // This simulates Supabase sending data

//   // 5. Verify local DB was updated
//   final profile = await pdao.getProfile('R1');
//   expect(profile?.username, 'new_awesome_username');
// });