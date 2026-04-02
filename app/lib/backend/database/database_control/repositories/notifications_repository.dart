import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/notifications_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';

part 'notifications_repository.g.dart';

// Provider
@Riverpod(keepAlive: true)
NotificationsRepository notificationsRepository(Ref ref) {
  return NotificationsRepository(
    dao: NotificationsDAO(ref.read(databaseProvider)),
  );
}

// TODO UNFINISHED DO NOT USE
class NotificationsRepository {
  final NotificationsDAO dao;
  NotificationsRepository({required this.dao});

  // TODO a bit strange, need to plan ahead, move to D7 first
}

// import 'package:drift/drift.dart';
// import 'package:flutter/material.dart' hide Notification;
// import 'package:sddp_dsh/nav/main_page_route.dart';
// import 'package:sddp_dsh/pages/home/subpages/notifications/providers/app_notification.dart';

// extension on Notification {
//   AppNotifications toAppNotifications() => AppNotifications(
//     icon: Icons.notification_add, // TODO
//     title: 'title',
//     description: 'description',
//     linkToPageMainIndex: MainPageRoute.discussion, // TODO
//     linkToPageSub: Scaffold(), // TODO
//     alert: true, // TOFO
//     read: false,
//     pushDateTime: DateTime.now(),
//     pushTarget: 'pushTarget',
//   );
// }

// extension on AppNotifications {
//   NotificationsCompanion toCompanion(String localId) => NotificationsCompanion(
//     localId: Value(localId),
//     icon: Value(title),
//     title: Value(title),
//     description: Value(title),
//     linkToPageMain: Value(title),
//     linkToPageSub: Value(title),
//     alert: Value(alert),
//     read: Value(read),
//     pushDateTime: Value(pushDateTime ?? DateTime.now()),
//     pushTarget: Value(pushTarget),
//   );
// }
