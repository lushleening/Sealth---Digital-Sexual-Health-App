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

  Stream<Setting> watchSettings(String localId) {
    return (select(
      settings,
    )..where((t) => t.localId.equals(localId))).watchSingle();
  }

  Future<Setting> getSettings(String localId) async {
    return transaction(() async {
      localDBLogger.info(
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
    localDBLogger.info(
      "Insert returning default settings from database for localId: $localId",
    );
    return (await into(
      settings,
    ).insertReturning(SettingsCompanion(localId: Value(localId))));
  }

  Future<void> upsertSettings(SettingsCompanion companion) async {
    localDBLogger.info("Upserting settings: $companion");
    await into(settings).insert(companion, mode: InsertMode.insertOrReplace);
  }
}
