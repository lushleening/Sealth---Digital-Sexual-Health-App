import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/common_widgets/choice_dialog.dart';
import 'package:sddp_dsh/frontend/common_widgets/warning_btn.dart';

class LogoutBtn extends ConsumerWidget {
  const LogoutBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertBtn(
      icon: Icons.logout,
      text: "Sign Out",
      color: context.colors.alert,
      onPressed: () async {
        final bool? logout = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return ChoiceDialog(
              title: "Sign Out",
              content: "Are you sure to sign out from this account?",
              yesStyle: TextStyle(color: dialogContext.colors.alert),
            );
          },
        );

        if (logout == true && context.mounted) {
          context.pop();
          ref.read(supabaseAuthProvider).signOut();
          showSnackbarMessage("You have successfully signed out.");
        }
      },
    );
  }
}
