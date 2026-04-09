import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/biometric/biometric_confirmation.dart';
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
    @JsonKey(name: "biometric_authentication")
    required bool biometricConfirmation,
    @JsonKey(name: "updated_at") required DateTime updatedAt,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}

// Used for user to change their app settings
@Riverpod(keepAlive: true)
class AppSettingsNotifier extends _$AppSettingsNotifier {
  @override
  Stream<AppSettings> build() async* {
    final repo = ref.read(settingsRepositoryProvider);
    final user = await ref.watch(appUserProvider.future);

    // Inserts the settings if not found
    await repo.getSetting(user.localId);

    // Returns a new stream for live updates
    yield* repo.watchSetting(user.localId);
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

  Future<void> setBiometricConfirmation(bool value) async {
    if (await ref
            .read(biometricConfirmationProvider)
            .tryBiometricConfirmation(bypassSettingCheck: true) !=
        false) {
      settingsLogger.info("Setting biometricAuthentication as value: $value");
      await _updateSettingsAndSync(
        (s) => s.copyWith(biometricConfirmation: value),
      );
    }
  }

  Future<void> _updateSettingsAndSync(
    AppSettings Function(AppSettings current) newState,
  ) async {
    // Records states
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
      await repo.updateSettingAndSync(
        localId: localId,
        remoteId: remoteId,
        newSettings: updated,
      );
    } catch (e, _) {
      settingsLogger.shout("Error updating settings: $e");
    }
  }
}
