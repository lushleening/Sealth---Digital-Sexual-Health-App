import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/supabase.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/notifications_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/notifications/notification_service.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:uuid/uuid.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

// Notifications of the app, brings users to the desired page
@freezed
abstract class AppNotifications with _$AppNotifications implements Syncable {
  const factory AppNotifications({
    @JsonKey(name: uuidColName) required String uuid,

    @JsonKey(name: "title") required String title,
    @JsonKey(name: "description") required String description,

    // Use NotificationType.*.name instead of normal Strings for accurate results
    @JsonKey(name: "notification_type") required String notificationType,

    @JsonKey(name: "is_alert_message") required bool isAlertMessage,
    @JsonKey(name: "has_read") required bool hasRead,
    @JsonKey(name: "link_to_page") required String linkToPage,
    @JsonKey(name: "scheduled_at") required DateTime scheduledAt,

    @JsonKey(name: "created_at") required DateTime createdAt,
  }) = _AppNotifications;

  // Helper that inserts uuid for you
  factory AppNotifications.create({
    required String title,
    required String description,
    required String notificationType,
    required bool isAlertMessage,
    required bool hasRead,
    required String linkToPage,
    required DateTime scheduledAt,
  }) => AppNotifications(
    uuid: const Uuid().v4(),
    title: title,
    description: description,
    notificationType: notificationType,
    isAlertMessage: isAlertMessage,
    hasRead: hasRead,
    linkToPage: linkToPage,
    scheduledAt: scheduledAt,
    createdAt: DateTime.now(), // For DB cleanup
  );

  // Helper that inserts uuid and time delay (respective to now) for you
  factory AppNotifications.timed({
    required String title,
    required String description,
    required String notificationType,
    required bool isAlertMessage,
    required bool hasRead,
    required String linkToPage,
    Duration delayDuration = Duration.zero,
  }) => AppNotifications.create(
    title: title,
    description: description,
    notificationType: notificationType,
    isAlertMessage: isAlertMessage,
    hasRead: hasRead,
    linkToPage: linkToPage,
    scheduledAt: DateTime.now().add(delayDuration),
  );

  // For sync only, DO NOT USE
  factory AppNotifications.dummy({required String uuid}) => AppNotifications(
    uuid: uuid,
    title: '',
    description: '',
    notificationType: '',
    isAlertMessage: false,
    hasRead: true,
    linkToPage: '',
    scheduledAt: DateTime.now(),
    createdAt: DateTime.now(),
  );

  factory AppNotifications.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationsFromJson(json);

  const AppNotifications._();

  // Cap at 32-bit int
  int get id => uuid.hashCode & 0x7FFFFFFF;
}

// Used to add notifications for the user
@Riverpod(keepAlive: true)
class AppNotificationNotifier extends _$AppNotificationNotifier {
  @override
  Stream<List<AppNotifications>> build() {
    ref.listen(appUserProvider, (previous, next) {
      if (next.hasValue && previous?.value?.localId != next.value?.localId) {
        _handleSessionChange(next.value!.localId);
      }
    });

    final user = ref.watch(appUserProvider);
    return user.when(
      data: (u) => ref
          .read(notificationsRepositoryProvider)
          .watchNotifications(u.localId),
      loading: () => Stream.value([]),
      error: (e, s) => Stream.error(e, s),
    );
  }

  // Inserts scheduled notification for current user
  // upsertNotificationToLocal and insertNotificationToRemote should not be used together
  Future<bool> upsertNotificationToLocal(AppNotifications n) async {
    final user = await ref.read(appUserProvider.future);
    final repo = ref.read(notificationsRepositoryProvider);
    return await repo.upsertNotificationToLocal(user.localId, n);
  }

  // Inserts scheduled notification for current registered user
  // upsertNotificationToLocal and insertNotificationToRemote should not be used together
  Future<bool> insertNotificationToRemote(AppNotifications n) async {
    final user = await ref.read(appUserProvider.future);
    final repo = ref.read(notificationsRepositoryProvider);
    final r = user.remoteId;
    if (r == null) return false;
    return await repo.insertNotificationToRemote(r, n);
  }

  Future<void> removeNotification(AppNotifications n) =>
      ref.read(notificationsRepositoryProvider).removeNotification(n);

  Future<void> markAsRead(AppNotifications n) async {
    if (n.hasRead) return;
    final user = await ref.read(appUserProvider.future);
    await ref
        .read(notificationsRepositoryProvider)
        .upsertNotificationToLocal(
          user.localId,
          n.copyWith(hasRead: true, createdAt: DateTime.now()),
          scheduleNotification: false,
        );
  }

  Future<void> _handleSessionChange(String localId) async {
    final service = ref.read(notificationServiceProvider);

    // Clear old session's notifications
    await service.cancelAll();

    // Then fetch new user's notifications
    final notifications = await ref
        .read(notificationsRepositoryProvider)
        .getNotifications(localId);

    for (final n in notifications) {
      if (n.scheduledAt.isAfter(
        DateTime.now().subtract(const Duration(minutes: 2)),
      )) {
        await service.showNotification(n);
      }
    }
  }
}
