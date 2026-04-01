import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/widgets/header_elements.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("Register header generated.");
    return Column(
      spacing: 24,
      children: [
        const AuthLogo(),
        const AuthTitles(
          title: "Greetings",
          subtitle: "Your sexual wellness journey starts now.",
        ),
        const AuthAssurance(),
      ],
    );
  }
}
