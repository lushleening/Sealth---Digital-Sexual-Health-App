import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

class LoginRegisterFooter extends ConsumerWidget {
  const LoginRegisterFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.finer("Login register footer generated.");
    final textSize = Theme.of(context).textTheme.labelLarge!;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?",
            style: textSize.copyWith(color: context.colors.textSecondary),
          ),
          TextButton(
            key: KBtn.navRegisterLink.key,
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsetsGeometry.all(4)),
              overlayColor: WidgetStatePropertyAll(
                context.colors.mainColor.withValues(alpha: buttonOverlayAlpha),
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => context.go(AppRoutes.registerP),
            child: Text(
              "Sign up here for free",
              style: textSize.copyWith(
                color: context.colors.mainColor,
                decoration: TextDecoration.underline,
                decorationColor: context.colors.mainColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
