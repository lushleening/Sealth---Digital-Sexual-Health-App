import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/constants/textbox_hints.dart';
import 'package:sddp_dsh/frontend/common_widgets/choice_dialog.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/navigation/safer_navigation/safer_navigation.dart';

class AlertBtn extends ConsumerWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final Color color;

  const AlertBtn({
    super.key,
    required this.text,
    required this.color,
    this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.fine("Alert button with text '$text' generated.");
    return OutlinedButton.icon(
      key: KBtn.logoutBtn.key,
      onPressed: onPressed,
      label: Text(text, style: TextStyle(color: color)),
      icon: Icon(icon, color: color),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(longBtnWidth, longBtnHeight),
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(baseLength),
        ),
        overlayColor: color,
      ),
    );
  }
}

class LogoutBtn extends ConsumerWidget {
  const LogoutBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertBtn(
      icon: Icons.logout,
      text: "Log Out",
      color: context.colors.alert,
      onPressed: () async {
        final bool? logout = await showDialog<bool>(
          context: context,
          builder: (_) {
            return ChoiceDialog(
              key: KPage.logoutDialog.key,
              title: "Log Out",
              content: "Are you sure to log out?",
            );
          },
        );

        if (logout == true && context.mounted) {
          navPop(context, ref);
          // ref.read(appStatusProvider.notifier).setUnauthenticated(); // TODO
          ref.read(supabaseAuthProvider).signOut();
          showSnackbarMessage("You have successfully logged out.");
        }
      },
    );
  }
}

class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertBtn(
      icon: Icons.delete_forever,
      text: "Delete Account",
      color: context.colors.textSecondary,
      onPressed: () async {
        final bool? del = await showDialog<bool>(
          context: context,
          builder: (_) => const ChoiceDialog(
            title: "Warning",
            content:
                "Are you sure to delete your account?$irreversibleActionTextWarning",
          ),
        );
        if (del == true) {
          authLogger.warning("Account is deleted."); // TODO
        }
      },
    );
  }
}

class RemoveGuestDataButton extends ConsumerWidget {
  const RemoveGuestDataButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertBtn(
      icon: Icons.delete_sweep_rounded,
      text: "Remove Account Data",
      color: context.colors.alert,
      onPressed: () async {
        final bool? rm = await showDialog<bool>(
          context: context,
          builder: (_) => const ChoiceDialog(
            title: "Warning",
            content:
                "Are you sure to remove your account's data?$irreversibleActionTextWarning",
          ),
        );
        if (rm == true) {
          authLogger.warning("Removing guest account data"); // TODO
          // ref.read(appUserProvider.notifier).createLocalGuest();
        }
      },
    );
  }
}
