import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

// Notifications of the app, brings users to the desired page
@freezed
abstract class AppNotifications with _$AppNotifications implements Syncable {
  const factory AppNotifications({
    @JsonKey(name: "uuid") required String? uuid, // Null for guests
    @JsonKey(name: "title") required String title,
    @JsonKey(name: "description") required String description,

    // Use NotificationType.*.name instead of normal Strings for accurate results
    @JsonKey(name: "notification_type") required String notificationType,

    @JsonKey(name: "is_alert_message") required bool isAlertMessage,
    @JsonKey(name: "has_read") required bool hasRead,
    @JsonKey(name: "link_to_page") required String linkToPage,
    @JsonKey(name: "push_datetime") required DateTime pushDateTime,

    @JsonKey(name: "updated_at") required DateTime updatedAt,
  }) = _AppNotifications;

  factory AppNotifications.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationsFromJson(json);
}

// Used to add notifications for the user
@Riverpod(keepAlive: true)
class AppNotificationNotifier extends _$AppNotificationNotifier {
  @override
  List<AppNotifications> build() => List.unmodifiable([]);

  void remove(AppNotifications notification) {
    state = List.unmodifiable(state.where((n) => n != notification).toList());
  }

  void addNew(AppNotifications notification) {
    state = List.unmodifiable([notification, ...state]);
  }

  void markAsRead(AppNotifications notification) {
    state = List.unmodifiable([
      for (final n in state) n == notification ? n.copyWith(hasRead: true) : n,
    ]);
  }
}


// TODO Wait... There are 2 (3) types of notifications???? (Online to all, Online to user only, Offline)
