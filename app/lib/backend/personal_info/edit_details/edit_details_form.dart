import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';

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
}

// Used to validate auth forms
@riverpod
class EditDetailsNotifier extends _$EditDetailsNotifier {
  @override
  EditDetailsFormState build() {
    return const EditDetailsFormState();
  }

  void toggleEditState() {
    formLogger.finer("Toggle edit state");
    state = state.copyWith(inputEnabled: !state.inputEnabled);
  }

  void pickAvatar() {
    if (!state.inputEnabled) {
      showSnackbarMessage(
        "Please tap the button 'Edit Profile Fields' before attempting to change your profile picture.",
      );
      return;
    }
    formLogger.info("Picking avatar");
    // TODO
  }

  void changeUsername(
    String remoteId,
    AppRegisteredProfile existingProfile,
    String newUsername,
  ) {
    if (newUsername.isEmpty) {
      state = state.copyWith(usernameError: "Username cannot be empty.");
      return;
    }
    formLogger.info("Changing to $newUsername");

    final newProfile = existingProfile.copyWith(username: newUsername);
    ref
        .read(appRegisteredProfileProvider.notifier)
        .updateProfile(remoteId, newProfile);
  }

  void changePassword() {
    //  TODO show prompt

  }
  void deleteAccount() async{

    // TODO show warning
  }
}
