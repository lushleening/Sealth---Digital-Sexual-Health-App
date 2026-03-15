import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/textbox_hints.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/navigation/safer_navigation/safer_navigation.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/common_widgets/choice_dialog.dart';
import 'package:sddp_dsh/frontend/common_widgets/warning_btn.dart';

class DeleteAccountBtn extends ConsumerWidget {
  final VoidCallback deleteAccount;
  const DeleteAccountBtn({super.key, required this.deleteAccount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertBtn(
      icon: Icons.remove_circle_outline,
      text: "Delete Account",
      color: context.colors.alert,
      onPressed: () async {
        final bool? del = await showDialog<bool>(
          context: context,
          builder: (_) => ChoiceDialog(
            key: KPage.deleteAccountDialog.key,
            title: "Warning",
            content:
                "Are you sure to delete your account?$irreversibleActionTextWarning",
            noText: "Cancel",
            yesText: "Delete",
            yesStyle: TextStyle(color: context.colors.alert),
          ),
        );
        if (del == true) {
          authLogger.info("Deleting registered account...");
          // await ref.read(appUserProvider.notifier).refreshLocalGuest(); // TODO also use biometric
          showSnackbarMessage("Your account have been deleted.");
          if (context.mounted) navPop(context, ref);
        }
      },
    );
  }
}
