import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/settings_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
abstract class AppSettings with _$AppSettings implements Syncable {
  const AppSettings._();
  const factory AppSettings({
    @JsonKey(name: "dark_mode") required bool darkMode,
    @JsonKey(name: "receive_notifications") required bool receiveNotifications,
    @JsonKey(name: "auto_update") required bool autoUpdate,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}

// Used for user to change their app settings
@Riverpod(keepAlive: true)
class AppSettingsNotifier extends _$AppSettingsNotifier {
  @override
  Future<AppSettings> build() async {
    final repo = ref.read(settingsRepositoryProvider);
    final localId = await ref.watch(
      appUserProvider.selectAsync((u) => u.localId),
    );
    return repo.getOrInsertDefaultSettings(localId);
  }

  Future<void> setDarkMode(bool value) async {
    settingsLogger.info("Setting darkMode as value: $value");
    await _updateSettingsAndSync((s) => s.copyWith(darkMode: value));
  }

  Future<void> setReceiveNotifications(bool value) async {
    settingsLogger.info("Setting receiveNotifications as value: $value");
    await _updateSettingsAndSync(
      (s) => s.copyWith(receiveNotifications: value),
    );
  }

  Future<void> setAutoUpdate(bool value) async {
    settingsLogger.info("Setting autoUpdate as value: $value");
    await _updateSettingsAndSync((s) => s.copyWith(autoUpdate: value));
  }

  Future<void> _updateSettingsAndSync(
    AppSettings Function(AppSettings current) newState,
  ) async {
    // Records states
    final previous = state;
    final current = state.value;
    if (current == null) return;

    // Is same as prev state, counts as unchanged
    final updated = newState(current);
    if (updated == current) return;

    final repo = ref.read(settingsRepositoryProvider);
    final (localId, remoteId) = await ref.read(
      appUserProvider.selectAsync((u) => (u.localId, u.remoteId)),
    );
    try {
      await repo.updateSettingsAndSync(
        localId: localId,
        remoteId: remoteId,
        newSettings: updated,
      );
      state = AsyncData(updated);
    } catch (e, _) {
      state = previous;
      settingsLogger.shout("Error updating settings: $e");
    }
  }
}

// TODO error handling with AsyncError
//   _dao.setDarkMode(current.localId, value);
// } catch (e, st) {
//   state = AsyncError(e, st);
//   state = AsyncData(current);
// }
