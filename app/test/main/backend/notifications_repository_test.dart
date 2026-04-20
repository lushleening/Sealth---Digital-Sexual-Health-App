import 'package:drift/native.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/storage.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/notifications_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_service.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/users_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/notifications/notification_service.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';
import 'package:test/test.dart';

import '../../helper/mock_objects.dart';

void main() {
  late ProviderContainer container;
  late MockSyncService syncService;

  setUp(() async {
    registerFallbackValue(AppNotifications.dummy(uuid: 'uuid'));

    final mockService = MockNotificationService();
    when(() => mockService.cancelNotification(any())).thenAnswer((_) async {});
    when(() => mockService.cancelAll()).thenAnswer((_) async {});
    when(
      () => mockService.filterAndShowNotification(any()),
    ).thenAnswer((_) async {});

    final db = Database(NativeDatabase.memory());
    syncService = MockSyncService();
    container = ProviderContainer.test(
      overrides: [
        databaseProvider.overrideWithValue(db),
        syncServiceProvider.overrideWithValue(syncService),
        notificationServiceProvider.overrideWithValue(mockService),
      ],
    );
    addTearDown(() => db.close());

    final udao = UsersDAO(container.read(databaseProvider));
    await udao.insertRegisteredUserAndReturn(remoteId);
  });

  test(
    'watchNotifications emits updated list when notifications change',
    () async {
      final repo = container.read(notificationsRepositoryProvider);
      final stream = repo.watchNotifications(localId);

      final testDate = DateTime(2026, 4, 20, 12, 0, 0, 0);
      final old = testAppNotificationsOneHasNotRead.copyWith(
        scheduledAt: testDate,
        updatedAt: testDate,
      );
      final updated = old.copyWith(
        title: 'Updated',
        updatedAt: testDate.add(const Duration(days: 1)),
      );

      expectLater(
        stream,
        emitsInOrder([
          [old],
          [updated],
        ]),
      );
      await repo.upsertNotificationToLocal(localId, old);
      await repo.upsertNotificationToLocal(localId, updated);
    },
  );

  test('upsertNotificationToLocal schedules a system notification', () async {
    final repo = container.read(notificationsRepositoryProvider);
    final mockNotiService = container.read(notificationServiceProvider);

    await repo.upsertNotificationToLocal(
      localId,
      testAppNotificationsOneHasNotRead,
    );
    verify(
      () => mockNotiService.filterAndShowNotification(
        testAppNotificationsOneHasNotRead,
      ),
    ).called(1);
  });

  test(
    'batchUpsertFromRemote filters out notifications exceeding max history',
    () async {
      final repo = container.read(notificationsRepositoryProvider);

      final old = testAppNotificationsOneHasNotRead.copyWith(
        scheduledAt: DateTime.now()
            .subtract(cleanupNotificationThreshold)
            .subtract(const Duration(days: 1)),
      );
      final updated = old.copyWith(scheduledAt: DateTime.now());

      await repo.batchUpsertFromRemote(localId, [old, updated]);
      final results = await repo.getNotifications(localId);

      // Only the new one is in db
      expect(results.length, 1);
      expect(results.first.uuid, updated.uuid);
    },
  );

  test('upsertNotificationToLocal rejects stale updates', () async {
    final repo = container.read(notificationsRepositoryProvider);

    // Insert original
    final noti = testAppNotificationsOneHasNotRead.copyWith(
      updatedAt: DateTime(2023, 1, 2),
    );
    await repo.upsertNotificationToLocal(localId, noti);

    // Try to insert stale version (older date)
    final stale = testAppNotificationsOneHasNotRead.copyWith(
      updatedAt: DateTime(2023, 1, 1),
    );
    final success = await repo.upsertNotificationToLocal(localId, stale);

    expect(success, isFalse);

    // Database still has the original notification
    final latest = await repo.getNotifications(localId);
    expect(latest.first.updatedAt, noti.updatedAt);
  });
}
