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
      children: [
        const LoginLogo(),
        const LoginTitles(
          title: "Greetings",
          subtitle: "Continue embarking on your journey towards sexual wellness.",
        ),
        const LoginAssurance(),
      ],
    );
  }
}
