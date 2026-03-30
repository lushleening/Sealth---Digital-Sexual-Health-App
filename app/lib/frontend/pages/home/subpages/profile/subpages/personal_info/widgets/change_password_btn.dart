import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/common_widgets/warning_btn.dart';

class ChangePasswordBtn extends ConsumerWidget {
  final String remoteId;
  const ChangePasswordBtn({super.key, required this.remoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertBtn(
      key: KBtn.piChangePassword.key,
      icon: Icons.password,
      text: "Change Password",
      color: context.colors.textPrimary,
      onPressed: () async {
        // context.go(AppRoute.resetPassword);
        // navPush(context, ref, const ResetPasswordPage());

      
    //   onPressed: () async {
    //     final bool? change = await showDialog<bool>(
    //       context: context,
    //       builder: (_) => ChoiceDialog(
    //         key: KPage.alertBtn.key,
    //         title: "Change Password",
    //         content: "Are you sure to change your account's password?",
    //         yesStyle: TextStyle(color: context.colors.alert),
    //       ),
    //     );
    //     if (change == true) {
    //       formLogger.info(
    //         "Changing password for registered user with remoteId: $remoteId",
    //       );
    //       await ref.read(editDetailsFormProvider.notifier).changePassword("hello");
    //     }
  //     Future<void> changePassword(String newPassword) async {
  //   if (await tryBiometricAuth() == false) return;

  //   await startSubmit(() async {
  //     formLogger.info("Changing password to $newPassword");
  //     // TODO
  //     showSnackbarMessage("Your password has been changed.");
  //   });
    
  // }
      },
    );
  }
}
