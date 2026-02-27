import 'package:flutter/material.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/login/widgets/header_elements.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    uiLogger.fine("Login header generated.");
    return Column(
      spacing: 24,
      children: [
        const LoginLogo(),
        const LoginTitles(
          title: "Welcome back",
          subtitle: "Your confidential sexual health portal",
        ),
        const LoginAssurance(),
      ],
    );
  }
}
