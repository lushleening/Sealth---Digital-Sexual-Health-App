import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/biometric/biometric_auth/biometric_confirmation.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/common_widgets/choice_dialog.dart';
import 'package:sddp_dsh/frontend/common_widgets/warning_btn.dart';

class DeleteLocalCacheBtn extends ConsumerWidget {
  final String remoteId;
  const DeleteLocalCacheBtn({super.key, required this.remoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertBtn(
      icon: Icons.remove_circle_outline,
      text: "Delete Local Cache and Sign Out",
      color: context.colors.alert,
      onPressed: () async {
        final bool? del = await showDialog<bool>(
          context: context,
          builder: (ctx) => ChoiceDialog(
            key: KBtn.authDeleteLocalCache.key,
            title: "Warning",
            content:
                "Are you sure to delete your account's local cache on this device and sign out?",
            noText: "Cancel",
            yesText: "Delete",
            yesStyle: TextStyle(color: ctx.colors.alert),
          ),
        );

        if (del == true) {
          formLogger.info(
            "Removing local cache of user with remoteId: $remoteId",
          );

          // Early return to prevent tab hell
          final bio = ref.read(biometricConfirmationProvider);
          if (await bio.tryBiometricConfirmation() == false) return;

          await ref
              .read(usersRepositoryProvider)
              .deleteRegisteredUserLocalCache(remoteId);

          if (context.mounted) context.go('/');
          ref.read(supabaseAuthProvider).signOut();
          showSnackbarMessage("Your account's local cache has been deleted.");
        }
      },
    );
  }
}
