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

  Future<void> upsertSettings(
    String localId,
    SettingsCompanion companion,
  ) async {
    localDBLogger.info("Upserting settings: $companion");
    await into(settings).insert(
      companion.copyWith(localId: Value(localId)),
      mode: InsertMode.insertOrReplace,
    );
  }
}


// I/flutter (19180): Local DB: INFO: Updating settings to database: SettingsCompanion(localId: Value(6a8e4aa5-7d39-4ba7-954e-33989596f344), darkMode: Value(true), receiveNotifications: Value(true), biometricConfirmation: Value(false), rowid: Value.absent())
// I/flutter (19180): Settings: INFO: Getting settings from local db for localId: 6a8e4aa5-7d39-4ba7-954e-33989596f344
// I/flutter (19180): Local DB: INFO: Getting settings from database for localId: 6a8e4aa5-7d39-4ba7-954e-33989596f344 
// I/flutter (19180): Local DB: INFO: Insert returning default settings from database for localId: 6a8e4aa5-7d39-4ba7-954e-33989596f344
// I/flutter (19180): Riverpod: INFO: Updated appSettingsProvider from AsyncLoading<AppSettings>(value: AppSettings(darkMode: false, receiveNotifications: true, biometricConfirmation: false)) => AsyncData<AppSettings>(value: AppSettings(darkMode: false, receiveNotifications: true, biometricConfirmation: false))