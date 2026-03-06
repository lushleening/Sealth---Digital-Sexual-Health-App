import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/navigation/main_page_route/main_page_route.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

// Notifications of the app, brings users to the main page, then subpage also (if exists)
// The warning variable describes the urgency of message, will change UI based on it
// The read variable checks if the user has read the notification and will change UI based on it

// TODO Wait... There are 2 (3) types of notifications???? (Online to all, Online to user only, Offline)
@freezed
abstract class AppNotifications with _$AppNotifications {
  const factory AppNotifications({
    required IconData icon, // JSON converter or sth
    required String title,
    required String description,
    @Default(false) bool alert,
    @Default(false) bool read,
    required MainPageRoute linkToPageMainIndex,
    Widget? linkToPageSub, // TODO give me a way to display your pages

    DateTime? pushDateTime, // TODO
    @Default("todo_replace-this") String pushTarget, // TODO
  }) = _AppNotifications;

  // factory AppNotifications.fromJson(Map<String, dynamic> json) =>
  //     _$AppNotificationsFromJson(json);
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
      for (final n in state) n == notification ? n.copyWith(read: true) : n,
    ]);
  }

  // TODO: Define behavior or remove it
  void markAllAsRead() {
    state = List.unmodifiable([
      for (final n in state) n.read ? n : n.copyWith(read: true),
    ]);
  }
}
