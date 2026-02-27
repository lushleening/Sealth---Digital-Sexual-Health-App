import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/user/app_user.dart';
import 'package:sddp_dsh/database/drift_sqlite/dao/settings_dao.dart';
import 'package:sddp_dsh/database/drift_sqlite/database_riverpod.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

// TODO Requires DTO
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    required String localId,
    required bool darkMode,
    required bool receiveNotifications,
    required bool autoSync,
    required bool autoUpdate,
  }) = _AppSettings;
}

// Used for user to change their app settings
@Riverpod(keepAlive: true)
class AppSettingsNotifier extends _$AppSettingsNotifier {
  late final SettingsDAO _dao = SettingsDAO(ref.read(databaseProvider));

  @override
  Future<AppSettings> build() async {
    final localId = (await ref.watch(appUserProvider.future)).localId;
    return _dao.getSettings(localId);
  }

  Future<void> setDarkmode(bool value) async {
    return _update(
      (s) => s.darkMode == value ? s : s.copyWith(darkMode: value),
      (s) => _dao.setDarkMode(s.localId, value),
    );
  }

  Future<void> setReceiveNotifications(bool value) async {
    return _update(
      (s) => s.receiveNotifications == value
          ? s
          : s.copyWith(receiveNotifications: value),
      (s) => _dao.setReceiveNotifications(s.localId, value),
    );
  }

  Future<void> setAutoSync(bool value) async {
    return _update(
      (s) => s.autoSync == value ? s : s.copyWith(autoSync: value),
      (s) => _dao.setAutoSync(s.localId, value),
    );
  }

  Future<void> setAutoUpdate(bool value) async {
    return _update(
      (s) => s.autoUpdate == value ? s : s.copyWith(autoUpdate: value),
      (s) => _dao.setAutoUpdate(s.localId, value),
    );
  }

  Future<void> _update(
    AppSettings Function(AppSettings current) updateState,
    Future<void> Function(AppSettings current) saveToDB,
  ) async {
    final previous = state;
    final current = state.value;
    if (current == null) return;
    state = state.whenData(updateState);
    settingsLogger.info("Updating new settings to database...");
    try {
      await saveToDB(current);
    } catch (e, _) {
      state = previous;
      settingsLogger.shout(
        "An error occured when updating to the settings table: $e",
      );
    }
  }
}

// TODO error handling with AsyncError
//   _dao.setDarkMode(current.localId, value);
// } catch (e, st) {
//   state = AsyncError(e, st);
//   state = AsyncData(current);
// }
