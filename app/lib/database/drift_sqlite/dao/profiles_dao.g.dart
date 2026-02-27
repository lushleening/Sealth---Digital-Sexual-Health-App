// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profiles_dao.dart';

// ignore_for_file: type=lint
mixin _$ProfilesDAOMixin on DatabaseAccessor<Database> {
  $UsersTable get users => attachedDatabase.users;
  $ProfilesTable get profiles => attachedDatabase.profiles;
  ProfilesDAOManager get managers => ProfilesDAOManager(this);
}

class ProfilesDAOManager {
  final _$ProfilesDAOMixin _db;
  ProfilesDAOManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db.attachedDatabase, _db.profiles);
}
