import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_service.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/settings_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/settings/app_settings/app_settings.dart';

part 'settings_repository.g.dart';

// Provider
@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository(
    ref: ref,
    dao: SettingsDAO(ref.read(databaseProvider)),
  );
}

class SettingsRepository {
  final Ref ref;
  final SettingsDAO dao;
  SettingsRepository({required this.ref, required this.dao});

  Future<AppSettings?> getSettings(String localId) async {
    settingsLogger.info("Getting settings from local db for localId: $localId");
    return (await dao.getSettings(localId))?.toAppSettings();
  }

  Future<AppSettings> getOrInsertDefaultSettings(String localId) async {
    settingsLogger.info(
      "Get / Insert default settings from local db for localId: $localId",
    );
    return dao.transaction(() async {
      Setting? settings = await dao.getSettings(localId);
      settings ??= await dao.insertReturningDefaultSettings(localId);
      return settings.toAppSettings();
    });
  }

  Future<void> updateSettings(String localId, AppSettings newSettings) async {
    settingsLogger.info("Updating new settings for $localId: $newSettings");
    dao.updateSettings(localId, newSettings.toCompanion());
  }

  Future<void> updateSettingsAndSync({
    required String localId,
    required String? remoteId,
    required AppSettings newSettings,
  }) async {
    await updateSettings(localId, newSettings);
    await ref.read(syncServiceProvider).addJob(remoteId, SyncTable.settings);
  }
}

// Use extensions to prevent mistypes on long constructors
// Unnamed extensions can only be used on the same file
// Used to bind Repo with DAO and encourage usage of Repo over DAO on end-users
extension on Setting {
  AppSettings toAppSettings() => AppSettings(
    darkMode: darkMode,
    receiveNotifications: receiveNotifications,
    autoUpdate: autoUpdate,
  );
}

extension on AppSettings {
  SettingsCompanion toCompanion() => SettingsCompanion(
    darkMode: Value(darkMode),
    receiveNotifications: Value(receiveNotifications),
    autoUpdate: Value(autoUpdate),
  );
}

// TODO consider 2 devices write at same time to db (one valid session only?)
