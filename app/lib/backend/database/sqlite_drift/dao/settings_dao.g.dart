// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_dao.dart';

// ignore_for_file: type=lint
mixin _$SettingsDAOMixin on DatabaseAccessor<Database> {
  $UsersTable get users => attachedDatabase.users;
  $SettingsTable get settings => attachedDatabase.settings;
  SettingsDAOManager get managers => SettingsDAOManager(this);
}

class SettingsDAOManager {
  final _$SettingsDAOMixin _db;
  SettingsDAOManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db.attachedDatabase, _db.settings);
}
