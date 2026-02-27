import 'package:flutter/material.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/login/widgets/header_elements.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    uiLogger.fine("Register header generated.");
    return Column(
      spacing: 24,
      children: [
        const LoginLogo(),
        const LoginTitles(
          title: "Greetings",
          subtitle: "Your sexual wellness journey starts now.",
        ),
        const LoginAssurance(),
      ],
    );
  }
}
