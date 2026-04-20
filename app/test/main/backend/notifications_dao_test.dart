import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/storage.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/notifications_repository.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/notifications_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';

import '../../helper/mock_objects.dart';

void main() {
  late ProviderContainer container;
  late NotificationsDAO ndao;
  const uuid = 'uuid';

  final oldNoti = AppNotifications(
    title: 'Old Content',
    description: '',
    notificationType: '',
    isAlertMessage: false,
    hasRead: false,
    linkToPage: '',
    scheduledAt: DateTime(2023, 1, 1),
    uuid: uuid,
    updatedAt: DateTime.now(),
  ).toCompanion(localId);

  final newNoti = oldNoti.copyWith(title: const Value('Updated Content'));

  setUp(() async {
    final db = Database(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(() => db.close());

    ndao = NotificationsDAO(container.read(databaseProvider));
  });

  group('Basic CRUD Operations', () {
    test('upsertNotification and getNotification', () async {
      await ndao.upsertNotification(
        AppNotifications.dummy(uuid: uuid).toCompanion(localId),
      );
      final retrieved = await ndao.getNotification(uuid);
      expect(retrieved?.uuid, uuid);
    });

    test('removeNotificationForLocal deletes the entry', () async {
      await ndao.upsertNotification(
        AppNotifications.dummy(uuid: uuid).toCompanion(localId),
      );
      await ndao.removeNotificationForLocal(uuid);
      final retrieved = await ndao.getNotification(uuid);
      expect(retrieved, isNull);
    });
  });

  group('Batch Upsert Logic', () {
    test('batchUpsertNotifications respects updatedAt timestamps', () async {
      final updatedNoti = newNoti.copyWith(
        updatedAt: Value(DateTime.now().add(const Duration(days: 50))),
      );
      await ndao.upsertNotification(oldNoti);
      await ndao.batchUpsertNotifications([updatedNoti]);

      final retrieved = await ndao.getNotification(uuid);
      expect(retrieved?.title, updatedNoti.title.value);
      expect(retrieved?.updatedAt.day, updatedNoti.updatedAt.value.day);
    });

    test('batchUpsertNotifications ignores older updates', () async {
      await ndao.upsertNotification(newNoti);
      await ndao.batchUpsertNotifications([
        oldNoti.copyWith(
          updatedAt: Value(DateTime.now().subtract(const Duration(days: 50))),
        ),
      ]);

      final retrieved = await ndao.getNotification(uuid);
      expect(retrieved?.title, newNoti.title.value);
    });
  });

  group('Watching and Filtering', () {
    test(
      'watchNotifications filters out removed items and orders by date',
      () async {
        const veryNewUuid = 'very_new';
        const veryOldUuid = 'very_old';
        const removedUuid = 'removed';
        final now = DateTime.now();

        final expectation = expectLater(
          ndao.watchNotifications(localId),
          emitsInOrder([
            hasLength(1),
            predicate<List<Notification>>(
              // veryNewUuid should be first notification
              (list) => list.length == 2 && list.first.uuid == veryNewUuid,
            ),
          ]),
        );

        await ndao.upsertNotification(
          oldNoti.copyWith(
            uuid: const Value(veryOldUuid),
            scheduledAt: Value(now.subtract(const Duration(minutes: 5))),
            hasRemoved: const Value(false),
          ),
        );

        // B. Insert newer notification (should jump to top of list)
        await ndao.upsertNotification(
          oldNoti.copyWith(
            uuid: const Value(veryNewUuid),
            scheduledAt: Value(now),
            hasRemoved: const Value(false),
          ),
        );

        // C. Insert a removed notification (should not change the stream length/content)
        await ndao.upsertNotification(
          oldNoti.copyWith(
            uuid: const Value(removedUuid),
            hasRemoved: const Value(true),
          ),
        );

        await expectation;
      },
    );
  });

  group('Cleanup', () {
    test('cleanupOldNotifications removes entries past threshold', () async {
      const oldUuid = 'old_uuid';
      const newUuid = 'new_uuid';

      final veryOldDate = DateTime.now()
          .subtract(cleanupNotificationThreshold)
          .subtract(const Duration(days: 1));
      final recentDate = DateTime.now();

      await ndao.upsertNotification(
        oldNoti.copyWith(uuid: Value(oldUuid), scheduledAt: Value(veryOldDate)),
      );
      await ndao.upsertNotification(
        oldNoti.copyWith(uuid: Value(newUuid), scheduledAt: Value(recentDate)),
      );

      final deletedCount = await ndao.cleanupOldNotifications();
      expect(deletedCount, 1);
      expect(await ndao.getNotification(oldUuid), isNull);
      expect(await ndao.getNotification(newUuid), isNotNull);
    });
  });
}
