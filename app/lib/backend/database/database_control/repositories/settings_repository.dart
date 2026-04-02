import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_service.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/settings_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';

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

  Future<AppSettings> getSettings(String localId) async {
    settingsLogger.info("Getting settings from local db for localId: $localId");
    final settings = (await dao.getSettings(localId)).toAppSettings();
    return settings;
  }

  Future<void> upsertSettings(String localId, AppSettings newSettings) async {
    settingsLogger.info(
      "Updating new settings for $localId: $newSettings to local db",
    );
    await dao.upsertSettings(newSettings.toCompanion(localId));
  }

  Future<void> updateSettingsAndSync({
    required String localId,
    required String? remoteId,
    required AppSettings newSettings,
  }) async {
    await upsertSettings(localId, newSettings);
    await ref.read(syncServiceProvider).addJob(remoteId, SyncTable.settings);
  }
}

// Use extensions to prevent mistypes on long constructors
// Unnamed extensions can only be used on the same file
// Used to bind Repo with DAO and encourage usage of Repo over DAO on end-users
extension SettingX on Setting {
  AppSettings toAppSettings() => AppSettings(
    darkMode: darkMode,
    receiveNotifications: receiveNotifications,
    biometricConfirmation: biometricConfirmation,
  );
}

extension AppSettingsX on AppSettings {
  SettingsCompanion toCompanion(String localId) => SettingsCompanion(
    localId: Value(localId),
    darkMode: Value(darkMode),
    receiveNotifications: Value(receiveNotifications),
    biometricConfirmation: Value(biometricConfirmation),
  );
}
