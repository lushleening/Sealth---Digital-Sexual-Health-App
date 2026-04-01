import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/widgets/header_elements.dart';

class ResetPasswordHeader extends StatelessWidget {
  const ResetPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("Reset Password header generated.");
    return Column(
      spacing: 24,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const AuthLogo(),
        const AuthTitles(
          title: "Greetings",
          subtitle: "Continue your journey towards sexual wellness.",
        ),
        const AuthAssurance(),
      ],
    );
  }
}
