import 'package:drift/drift.dart';
import 'package:sddp_dsh/database/drift_sqlite/database.dart';
import 'package:sddp_dsh/database/drift_sqlite/schema.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/settings/providers/app_settings.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [Settings])
class SettingsDAO extends DatabaseAccessor<Database> with _$SettingsDAOMixin {
  SettingsDAO(super.attachedDatabase);

  Future<AppSettings> getSettings(String localId) async {
    final row = await (select(settings)..limit(1)).getSingleOrNull();
    if (row == null) {
      final id = await into(
        settings,
      ).insert(SettingsCompanion(localId: Value(localId)));
      final newRow = await (select(
        settings,
      )..where((t) => t.id.equals(id))).getSingle();
      return AppSettings(
        localId: localId,
        darkMode: newRow.darkMode,
        receiveNotifications: newRow.receiveNotifications,
        autoSync: newRow.autoSync,
        autoUpdate: newRow.autoUpdate,
      );
    }
    return AppSettings(
      localId: localId,
      darkMode: row.darkMode,
      receiveNotifications: row.receiveNotifications,
      autoSync: row.autoSync,
      autoUpdate: row.autoUpdate,
    );
  }

  Future<void> updateSettings(String localId, AppSettings newSettings) async {
    await (update(settings)..where((t) => t.localId.equals(localId))).write(
      SettingsCompanion(
        darkMode: Value(newSettings.darkMode),
        receiveNotifications: Value(newSettings.receiveNotifications),
        autoUpdate: Value(newSettings.autoUpdate),
      ),
    );
  }

  Future<void> setDarkMode(String localId, bool value) async =>
      await (update(settings)..where((t) => t.localId.equals(localId))).write(
        SettingsCompanion(darkMode: Value(value)),
      );
  Future<void> setReceiveNotifications(String localId, bool value) async =>
      await (update(settings)..where((t) => t.localId.equals(localId))).write(
        SettingsCompanion(receiveNotifications: Value(value)),
      );
  Future<void> setAutoSync(String localId, bool value) async =>
      await (update(settings)..where((t) => t.localId.equals(localId))).write(
        SettingsCompanion(autoUpdate: Value(value)),
      );
  Future<void> setAutoUpdate(String localId, bool value) async =>
      await (update(settings)..where((t) => t.localId.equals(localId))).write(
        SettingsCompanion(autoUpdate: Value(value)),
      );
}
