import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/profiles_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

part 'app_registered_profile.freezed.dart';
part 'app_registered_profile.g.dart';

// The registered user's profile
@freezed
abstract class AppRegisteredProfile
    with _$AppRegisteredProfile
    implements Syncable {
  const AppRegisteredProfile._();

  // For json_serializable to sync to/from database
  const factory AppRegisteredProfile({
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'avatar_url') required String? avatarUrl,
    @JsonKey(name: 'verified') required bool verified,
  }) = _AppRegisteredProfile;

  factory AppRegisteredProfile.fromJson(Map<String, dynamic> json) =>
      _$AppRegisteredProfileFromJson(json);
}

// Provider watches appUserProvider.remoteId
@Riverpod(keepAlive: true)
class AppRegisteredProfileNotifier extends _$AppRegisteredProfileNotifier {
  @override
  Future<AppRegisteredProfile?> build() async {
    final remoteId = await ref.watch(
      appUserProvider.selectAsync((u) => u.remoteId),
    );
    if (remoteId == null) return null;
    localDBLogger.info('Fetching profile for remote ID: $remoteId');
    final profile = await ref
        .read(profilesRepositoryProvider)
        .getProfile(remoteId);
    if (profile == null) {
      throw StateError("Remote id $remoteId exists yet profile not found");
    }
    return profile;
  }

  Future<void> updateProfile(
    String remoteId,
    AppRegisteredProfile newProfile, {
    bool checkForConflicts = false,
  }) async {
    formLogger.info("Updating profile of '$remoteId' to $newProfile");
    final success = await ref
        .read(profilesRepositoryProvider)
        .upsertProfileAndSync(remoteId, newProfile, checkForConflicts: checkForConflicts);

    if (!success) {
      formLogger.info(
        "[FAILED] Updating profile of '$remoteId' to $newProfile",
      );
      showSnackbarMessage("Username is taken. Please choose another one.");
    } else {
      await reload();
    }
  }

  Future<void> reload() async {
    authLogger.info("Reloading profile...");
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
