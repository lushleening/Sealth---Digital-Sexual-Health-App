import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/navigation/safer_navigation/safer_navigation.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/common_widgets/choice_dialog.dart';
import 'package:sddp_dsh/frontend/common_widgets/warning_btn.dart';

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
              yesStyle: TextStyle(color: context.colors.alert),
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
