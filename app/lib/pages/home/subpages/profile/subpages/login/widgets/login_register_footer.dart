import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/testing/key_enum.dart';
import 'package:sddp_dsh/helper/safe_nav.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/login/subpages/register/register.dart';

class LoginRegisterFooter extends ConsumerWidget {
  const LoginRegisterFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.fine("Login register footer generated.");
    final textSize = Theme.of(context).textTheme.labelMedium!;
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
            onPressed: () =>
                navPush(context, ref, RegisterPage(key: KPage.register.key)),
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
