import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/textbox_hints.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/navigation/safer_navigation/safer_navigation.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:sddp_dsh/frontend/common_widgets/choice_dialog.dart';
import 'package:sddp_dsh/frontend/common_widgets/warning_btn.dart';

class RemoveGuestDataButton extends ConsumerWidget {
  const RemoveGuestDataButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertBtn(
      icon: Icons.delete_sweep_rounded,
      text: "Remove Account Data",
      color: context.colors.alert,
      onPressed: () async {
        final bool? del = await showDialog<bool>(
          context: context,
          builder: (_) => ChoiceDialog(
            title: "Remove Guest Data",
            content:
                "Are you sure to remove ALL of your guest account's data and start anew?\n$irreversibleActionTextWarning",
            yesStyle: TextStyle(color: context.colors.alert),
          ),
        );
        if (del == true) {
          authLogger.info("Disposing and recreating a new guest account");
          await ref.read(appUserProvider.notifier).refreshLocalGuest();
          showSnackbarMessage("All of your data in this guest account have been deleted.");
          if (context.mounted) navPop(context, ref);
        }
      },
    );
  }
}
