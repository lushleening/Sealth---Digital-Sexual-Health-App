import 'package:drift/drift.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/schema.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

part 'settings_dao.g.dart';

// Layer between local database and repo
// Use settingsRepoProvider in application instead
@DriftAccessor(tables: [Settings])
class SettingsDAO extends DatabaseAccessor<Database> with _$SettingsDAOMixin {
  SettingsDAO(super.attachedDatabase);

  Future<Setting> getSettings(String localId) async {
    return transaction(() async {
      localDBLogger.fine(
        "Getting settings from database for localId: $localId",
      );
      final setting = (await (select(
        settings,
      )..where((s) => s.localId.equals(localId))).getSingleOrNull());

      // Just insert default settings whenever settings for user is not found
      return setting ?? await _insertReturningDefaultSettings(localId);
    });
  }

  Future<Setting> _insertReturningDefaultSettings(String localId) async {
    localDBLogger.fine(
      "Insert returning default settings from database for localId: $localId",
    );
    return (await into(
      settings,
    ).insertReturning(SettingsCompanion(localId: Value(localId))));
  }

  // As always created on local end, no need insert from external, just update
  Future<void> updateSettings(
    String localId,
    SettingsCompanion companion,
  ) async {
    localDBLogger.fine("Updating settings to database: $companion");
    await (update(
      settings,
    )..where((t) => t.localId.equals(localId))).write(companion);
  }
}
