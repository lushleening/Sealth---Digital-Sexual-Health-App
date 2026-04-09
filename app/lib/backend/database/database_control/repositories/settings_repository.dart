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

  Stream<AppSettings> watchSetting(String localId) {
    return dao.watchSettings(localId).map((s) => s.toAppSettings()).distinct();
  }

  Future<AppSettings> getSetting(String localId) async {
    return (await dao.getSettings(localId)).toAppSettings();
  }

  Future<bool> upsertSetting(String localId, AppSettings newSettings) async {
    settingsLogger.info("Upserting new settings for $localId: $newSettings");
    await dao.upsertSettings(newSettings.toCompanion(localId));
    return true;
  }

  Future<void> updateSettingAndSync({
    required String localId,
    required String? remoteId,
    required AppSettings newSettings,
  }) async {
    if (await upsertSetting(localId, newSettings)) {
      await ref.read(syncServiceProvider).addJob(remoteId, SyncTable.settings);
    }
  }
}

// Use extensions to prevent mistypes on long constructors
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
