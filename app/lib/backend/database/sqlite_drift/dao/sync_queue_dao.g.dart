// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_queue_dao.dart';

// ignore_for_file: type=lint
mixin _$SyncQueueDAOMixin on DatabaseAccessor<Database> {
  $UsersTable get users => attachedDatabase.users;
  $SyncQueueTable get syncQueue => attachedDatabase.syncQueue;
  SyncQueueDAOManager get managers => SyncQueueDAOManager(this);
}

class SyncQueueDAOManager {
  final _$SyncQueueDAOMixin _db;
  SyncQueueDAOManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db.attachedDatabase, _db.syncQueue);
}
