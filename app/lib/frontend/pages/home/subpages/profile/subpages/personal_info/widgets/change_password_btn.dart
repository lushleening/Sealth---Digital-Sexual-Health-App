import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/biometric/biometric_confirmation.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/common_widgets/choice_dialog.dart';
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
        final bool? change = await showDialog<bool>(
          context: context,
          builder: (_) => ChoiceDialog(
            title: "Change Password",
            content: "Are you sure to change your account's password?",
            yesStyle: TextStyle(color: context.colors.alert),
          ),
        );
        if (change == true) {
          final bio = await ref
              .read(biometricConfirmationProvider)
              .tryBiometricConfirmation();

          if (bio != false && context.mounted) {
            formLogger.info(
              "Changing password for registered user with remoteId: $remoteId",
            );
            context.go(AppRoute.changePassword);
          }
        }
      },
    );
  }
}
