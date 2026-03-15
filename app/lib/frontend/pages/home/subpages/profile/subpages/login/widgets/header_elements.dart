import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/assets.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("Login Logo generated.");
    return Container(
      padding: const EdgeInsetsGeometry.all(baseLength),
      decoration: BoxDecoration(
        color: context.colors.mainColoredBox,
        shape: BoxShape.circle,
      ),
      child: Transform.translate(
        offset: Offset(0, 2),
        child: Image.asset(
          logoImage,
          width: iconSizeVeryLarge,
          height: iconSizeVeryLarge,
        ),
      ),
    );
  }
}

class LoginTitles extends StatelessWidget {
  final String title;
  final String subtitle;

  const LoginTitles({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("Login page style title with text '$title' generated.");
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: context.colors.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: context.colors.textSecondary),
        ),
      ],
    );
  }
}

class LoginAssurance extends StatelessWidget {
  const LoginAssurance({super.key});

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("Login Assurance generated.");
    return Container(
      padding: EdgeInsetsGeometry.all(baseLength),
      decoration: BoxDecoration(
        border: BoxBorder.all(
          color: context.colors.mainColor.withValues(alpha: .5),
        ),
        color: context.colors.mainColoredBox,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_outline,
            color: context.colors.mainColor,
            size: iconSizeMedium,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "All your data is encrypted and secure. We will never share your information without your consent.",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: context.colors.mainColor),
            ),
          ),
        ],
      ),
    );
  }
}
