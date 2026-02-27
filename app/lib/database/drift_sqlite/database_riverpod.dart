// CODEGEN RELATED: "dart run build_runner watch"
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/database/drift_sqlite/dao/profiles_dao.dart';
import 'package:sddp_dsh/database/drift_sqlite/dao/settings_dao.dart';
import 'package:sddp_dsh/database/drift_sqlite/dao/users_dao.dart';
import 'package:sddp_dsh/database/drift_sqlite/database.dart';

part 'database_riverpod.g.dart';

// Just a database provider for accessing DAOs
// To use DAOs, do "final dao = ref.read(_DAOProvider)"
@Riverpod(keepAlive: true)
Database database(Ref ref) {
  final db = Database();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
ProfilesDAO profilesDAO(Ref ref) {
  final db = ref.read(databaseProvider);
  return ProfilesDAO(db);
}

@Riverpod(keepAlive: true)
SettingsDAO settingsDAO(Ref ref) {
  final db = ref.read(databaseProvider);
  return SettingsDAO(db);
}

@Riverpod(keepAlive: true)
UsersDAO usersDAO(Ref ref) {
  final db = ref.read(databaseProvider);
  return UsersDAO(db);
}
