// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointments_dao.dart';

// ignore_for_file: type=lint
mixin _$AppointmentsDAOMixin on DatabaseAccessor<Database> {
  $UsersTable get users => attachedDatabase.users;
  $CachedAppointmentsTable get cachedAppointments =>
      attachedDatabase.cachedAppointments;
  AppointmentsDAOManager get managers => AppointmentsDAOManager(this);
}

class AppointmentsDAOManager {
  final _$AppointmentsDAOMixin _db;
  AppointmentsDAOManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$CachedAppointmentsTableTableManager get cachedAppointments =>
      $$CachedAppointmentsTableTableManager(
        _db.attachedDatabase,
        _db.cachedAppointments,
      );
}
