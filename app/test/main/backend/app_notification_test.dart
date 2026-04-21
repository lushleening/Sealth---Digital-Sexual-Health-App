import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/notifications_repository.dart';
import 'package:sddp_dsh/backend/notifications/notification_service.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:test/test.dart';

import '../../helper/mock_objects.dart';

void main() {
  final notiRepo = MockNotificationsRepository();
  final mockService = MockNotificationService();

  setUp(() {
    registerFallbackValue(AppNotifications.dummy(uuid: 'fallback'));

    when(
      () => notiRepo.getNotifications(any()),
    ).thenAnswer((_) async => testAppNotificationsNone);
    when(() => notiRepo.watchNotifications(any())).thenAnswer((_) async* {
      yield testAppNotificationsNone;
    });
    when(
      () => notiRepo.upsertNotificationToLocal(
        any(),
        any(),
        scheduleNotification: any(named: 'scheduleNotification'),
        bypassStaleCheck: any(named: 'bypassStaleCheck'),
      ),
    ).thenAnswer((_) async => true);
    when(
      () => notiRepo.upsertNotificationToLocal(
        any(),
        any(),
        scheduleNotification: any(named: 'scheduleNotification'),
        bypassStaleCheck: any(named: 'bypassStaleCheck'),
      ),
    ).thenAnswer((_) async => true);
    when(
      () => notiRepo.batchUpsertFromRemote(any(), any()),
    ).thenAnswer((_) async {});
    when(
      () => notiRepo.insertNotificationToRemote(any(), any()),
    ).thenAnswer((_) async => true);
    when(
      () => notiRepo.removeNotificationForLocal(any()),
    ).thenAnswer((_) async => {});
    when(
      () => notiRepo.removeNotificationForRemote(any(), any()),
    ).thenAnswer((_) async => {});

    when(() => mockService.cancelNotification(any())).thenAnswer((_) async {});
    when(() => mockService.cancelAll()).thenAnswer((_) async {});
    when(
      () => mockService.filterAndShowNotification(any()),
    ).thenAnswer((_) async {});
  });

  test(
    'removeNotification calls local repo when remoteId does not exist',
    () async {
      final container = ProviderContainer.test(
        overrides: [
          appUserProvider.overrideWith(TestAppGuestNotifier.new),
          notificationsRepositoryProvider.overrideWithValue(notiRepo),
          notificationServiceProvider.overrideWithValue(mockService),
        ],
      );
      final notification = AppNotifications.dummy(uuid: 'abc');

      await container
          .read(appNotificationProvider.notifier)
          .removeNotification(notification);

      verify(() => notiRepo.removeNotificationForLocal(notification)).called(1);
      verifyNever(() => notiRepo.removeNotificationForRemote(any(), any()));
    },
  );

  test('removeNotification calls remote repo when remoteId exists', () async {
    final container = ProviderContainer.test(
      overrides: [
        appUserProvider.overrideWith(TestAppRegisteredNotifier.new),
        appRegisteredProfileProvider.overrideWith(
          TestAppRegisteredProfileNotifier.new,
        ),

        notificationsRepositoryProvider.overrideWithValue(notiRepo),
        notificationServiceProvider.overrideWithValue(mockService),
      ],
    );
    container.listen(appNotificationProvider, (_, _) {});

    final notification = AppNotifications.dummy(uuid: 'uuid');

    await container
        .read(appNotificationProvider.notifier)
        .removeNotification(notification);

    verify(
      () => notiRepo.removeNotificationForRemote(localId, notification),
    ).called(1);
    verifyNever(() => notiRepo.removeNotificationForLocal(any()));
  });

  test(
    'upsertNotificationToLocal calls local repo when remoteId does not exist',
    () async {
      final container = ProviderContainer.test(
        overrides: [
          appUserProvider.overrideWith(TestAppGuestNotifier.new),
          notificationsRepositoryProvider.overrideWithValue(notiRepo),
          notificationServiceProvider.overrideWithValue(mockService),
        ],
      );
      final notification = AppNotifications.dummy(uuid: 'uuid');

      when(
        () => notiRepo.removeNotificationForLocal(any()),
      ).thenAnswer((_) async => {});

      await container
          .read(appNotificationProvider.notifier)
          .upsertNotificationToLocal(notification);

      verify(
        () => notiRepo.upsertNotificationToLocal(localId, notification),
      ).called(1);
    },
  );

  test(
    'insertNotificationToRemote calls remote repo when remoteId exists',
    () async {
      final container = ProviderContainer.test(
        overrides: [
          appUserProvider.overrideWith(TestAppRegisteredNotifier.new),
          appRegisteredProfileProvider.overrideWith(
            TestAppRegisteredProfileNotifier.new,
          ),
          notificationsRepositoryProvider.overrideWithValue(notiRepo),
          notificationServiceProvider.overrideWithValue(mockService),
        ],
      );
      final notification = AppNotifications.dummy(uuid: 'uuid');

      await container
          .read(appNotificationProvider.notifier)
          .insertNotificationToRemote(notification);

      verify(
        () => notiRepo.insertNotificationToRemote(remoteId, notification),
      ).called(1);
      verifyNever(() => notiRepo.removeNotificationForLocal(any()));
    },
  );

  test('markAsRead updates repo and cancels system notification', () async {
    final container = ProviderContainer(
      overrides: [
        notificationsRepositoryProvider.overrideWithValue(notiRepo),
        notificationServiceProvider.overrideWithValue(mockService),
        appUserProvider.overrideWith(TestAppGuestNotifier.new),
      ],
    );
    final n = AppNotifications.dummy(uuid: 'uuid').copyWith(hasRead: false);

    await container.read(appNotificationProvider.notifier).markAsRead(n);

    verify(
      () => notiRepo.upsertNotificationToLocal(
        localId,
        any(
          that: predicate<AppNotifications>((notif) => notif.hasRead == true),
        ),
        scheduleNotification: false,
        bypassStaleCheck: true,
      ),
    ).called(1);
    verify(() => mockService.cancelNotification(n.id)).called(1);
  });

  test('build watches the correct repository stream based on user', () async {
    final repo = MockNotificationsRepository();
    final streamController = StreamController<List<AppNotifications>>();

    when(
      () => repo.getNotifications(localId),
    ).thenAnswer((_) async => testAppNotificationsNone);

    when(
      () => repo.watchNotifications(localId),
    ).thenAnswer((_) => streamController.stream);

    final container = ProviderContainer(
      overrides: [
        appUserProvider.overrideWith(TestAppGuestNotifier.new),
        notificationsRepositoryProvider.overrideWithValue(repo),
        notificationServiceProvider.overrideWithValue(mockService),
      ],
    );
    container.listen(appNotificationProvider, (_, _) {});

    final notiList = [AppNotifications.dummy(uuid: 'uuid')];
    streamController.add(notiList);
    await Future.delayed(Duration.zero);

    expect((await container.read(appNotificationProvider.future)), notiList);
  });
}
