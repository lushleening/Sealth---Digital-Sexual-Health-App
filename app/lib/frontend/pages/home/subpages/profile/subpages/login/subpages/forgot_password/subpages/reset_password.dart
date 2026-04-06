import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/snackbar/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/forgot_password/subpages/widgets/reset_password_header.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/forgot_password/subpages/widgets/reset_password_input.dart';

class ResetPasswordPage extends StatelessWidget {
  final bool loggedIn;
  final String email;
  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.loggedIn,
  });

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("Reset Password page generated.");
    return SafeContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TopAppBar(
          title: "Reset Password",
          fg: context.colors.textPrimary,
          bg: context.colors.whiteBackground,
        ),
        body: SafeContainer(
          child: SingleChildScrollView(
            padding: EdgeInsetsGeometry.all(baseLength),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ResetPasswordHeader(),
                ResetPasswordInput(
                  email: email,
                  successCallback: () {
                    if (loggedIn) {
                      showSnackbarMessage(
                        "Your password has been changed successfully.",
                      );
                    } else {
                      showSnackbarMessage(
                        "Password reset successful. Please log in.",
                      );
                      context.go(AppRoute.resetLogin);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
