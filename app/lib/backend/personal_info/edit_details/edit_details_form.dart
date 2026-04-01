import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/biometric/biometric_confirmation.dart';
import 'package:sddp_dsh/backend/constants/input_control.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/file_chooser/pick_image.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/storage/supabase/supabase_storage.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'edit_details_form.freezed.dart';
part 'edit_details_form.g.dart';

// Used to display profile info form UI
@freezed
abstract class EditDetailsFormState with _$EditDetailsFormState {
  const factory EditDetailsFormState({
    @Default(false) bool inputEnabled,
    @Default(false) bool submitting,

    String? usernameError,
  }) = _EditDetailsFormState;

  const EditDetailsFormState._();
  bool get hasErrors => usernameError != null;
  bool get isHighlighted => inputEnabled && !submitting;
}

// Used to validate auth forms
@riverpod
class EditDetailsFormNotifier extends _$EditDetailsFormNotifier {
  @override
  EditDetailsFormState build() {
    return const EditDetailsFormState();
  }

  void toggleInputEnabled() {
    formLogger.finer("Toggle edit state");
    state = state.copyWith(inputEnabled: !state.inputEnabled);
    clearAllErrors();
  }

  Future<void> pickAvatar(
    String remoteId,
    AppRegisteredProfile existingProfile, {
    Future<File?> Function()? pickAvatarOverride,
    Future<String?> Function(SupabaseClient, File, String)? uploadOverride,
  }) async {
    if (!state.inputEnabled) {
      showSnackbarMessage(
        "Please tap 'Edit Profile Fields' before attempting to change your profile picture.",
      );
      return;
    }
    toggleInputEnabled();

    await startSubmit(() async {
      if (await ref
              .read(biometricConfirmationProvider)
              .tryBiometricConfirmation() ==
          false) {
        return;
      }
      formLogger.info("Picking avatar for user");
      final picker = pickAvatarOverride ?? pickAvatarImage;
      final avatar = await picker();
      if (avatar == null) return;

      // Upload to remote db
      formLogger.info("Uploading avatar to remote storage");
      final uploader = uploadOverride ?? uploadAvatar;
      final url = await uploader(ref.read(supabaseServiceProvider), avatar, remoteId);
      if (url == null) return;

      // Save avatarUrl to local and remote db
      final newProfile = existingProfile.copyWith(avatarUrl: url);
      await ref
          .read(appRegisteredProfileProvider.notifier)
          .updateProfile(remoteId, newProfile);
      showSnackbarMessage("Your profile avatar has been changed.");
    });
  }

  Future<void> changeUsername(
    String remoteId,
    String newUsername,
    AppRegisteredProfile existingProfile,
  ) async {
    if (!state.inputEnabled ||
        newUsername == existingProfile.username ||
        state.hasErrors ||
        await ref
                .read(biometricConfirmationProvider)
                .tryBiometricConfirmation() ==
            false) {
      return;
    }

    await startSubmit(() async {
      formLogger.info("Changing username to '$newUsername'");
      clearAllErrors();
      toggleInputEnabled();
      final newProfile = existingProfile.copyWith(username: newUsername);

      // Check for username conflicts before saving to database
      await ref
          .read(appRegisteredProfileProvider.notifier)
          .updateProfile(remoteId, newProfile, checkForConflicts: true);
      showSnackbarMessage("Your username has been changed.");
    });
  }

  // Helper
  void setUsernameError(String newUsername) {
    if (newUsername.isEmpty) {
      state = state.copyWith(usernameError: "Username cannot be empty.");
      return;
    } else if (newUsername.length > maxUsernameLen) {
      state = state.copyWith(
        usernameError:
            "Username should be less than $maxUsernameLen characters.",
      );
      return;
    } else {
      clearAllErrors();
    }
  }

  void clearAllErrors() {
    state = state.copyWith(usernameError: null);
  }

  Future<void> startSubmit(Future<void> Function() runFunction) async {
    state = state.copyWith(submitting: true);
    await runFunction();
    state = state.copyWith(submitting: false);
  }
}
