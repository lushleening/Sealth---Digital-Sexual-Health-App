// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_dao.dart';

// ignore_for_file: type=lint
mixin _$NotificationsDAOMixin on DatabaseAccessor<Database> {
  $UsersTable get users => attachedDatabase.users;
  $NotificationsTable get notifications => attachedDatabase.notifications;
  NotificationsDAOManager get managers => NotificationsDAOManager(this);
}

class NotificationsDAOManager {
  final _$NotificationsDAOMixin _db;
  NotificationsDAOManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$NotificationsTableTableManager get notifications =>
      $$NotificationsTableTableManager(_db.attachedDatabase, _db.notifications);
}
