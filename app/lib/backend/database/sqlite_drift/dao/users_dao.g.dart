// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_dao.dart';

// ignore_for_file: type=lint
mixin _$UsersDAOMixin on DatabaseAccessor<Database> {
  $UsersTable get users => attachedDatabase.users;
  UsersDAOManager get managers => UsersDAOManager(this);
}

class UsersDAOManager {
  final _$UsersDAOMixin _db;
  UsersDAOManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}
