import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/colors/dark_mode_enabled/dark_mode_enabled.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginChoicePopup extends StatelessWidget {
  const LoginChoicePopup({super.key});

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("Login Choice generated.");
    return Dialog(
      backgroundColor: context.colors.whiteBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          spacing: baseLength / 2,
          mainAxisSize: MainAxisSize.min,
          children: [
            // App name
            Text(
              "Select a method to sign in with",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: context.colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: baseLength / 2),

            Consumer(
              builder: (context, ref, _) {
                // Change button style if needed
                final darkModeEnabled = ref.read(darkModeEnabledProvider);
                return Column(
                  spacing: baseLength / 4,
                  children: [
                    SignInButton(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      Buttons.google,
                      onPressed: () {
                        context.pop();
                        // TODO: google login
                        // final GoogleSignInAccount? account = GoogleSignIn.instance
                      },
                    ),
                    SignInButton(
                      padding: const EdgeInsets.fromLTRB(4, 0, 16, 0),
                      darkModeEnabled ? Buttons.apple : Buttons.appleDark,
                      onPressed: () {
                        context.pop();
                        // TODO: Lets see if got time first
                      },
                    ),
                    SignInButton(
                      Buttons.email,
                      padding: const EdgeInsets.fromLTRB(4, 0, 16, 0),
                      onPressed: () {
                        context.pop();
                        context.go(AppRoutes.loginP);
                      },
                    ),
                  ],
                );
              },
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(
                    context.colors.mainColor,
                  ),
                  overlayColor: WidgetStatePropertyAll(
                    context.colors.mainColor.withValues(
                      alpha: buttonOverlayAlpha,
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(key: KBtn.closePopup.key, 'Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
