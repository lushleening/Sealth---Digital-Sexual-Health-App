import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/pages/home/subpages/notifications/providers/notification.dart';

// Used to add notifications for the user
class AppNotificationNotifier extends Notifier<List<NotificationObj>> {
  @override
  List<NotificationObj> build() => List.unmodifiable([]);

  void remove(NotificationObj notification) {
    state = List.unmodifiable(state.where((n) => n != notification).toList());
  }

  void addNew(NotificationObj notification) {
    state = List.unmodifiable([notification, ...state]);
  }

  void markAsRead(NotificationObj notification) {
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

final appNotificationProvider =
    NotifierProvider<AppNotificationNotifier, List<NotificationObj>>(
      AppNotificationNotifier.new,
    );
