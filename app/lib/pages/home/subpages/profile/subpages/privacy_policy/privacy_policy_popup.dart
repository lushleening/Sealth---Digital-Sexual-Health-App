import 'package:flutter/material.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/testing/key_enum.dart';

class PrivacyPolicyPopup extends StatelessWidget {
  const PrivacyPolicyPopup({super.key});

  @override
  Widget build(BuildContext context) {
    uiLogger.fine("Privacy Policy popup generated.");
    return Dialog(
      backgroundColor: context.colors.whiteBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Policy text
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  privacyPolicyText,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.colors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // OK button
            const SizedBox(height: 16),
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
                child: Text(key: KBtn.closePopup.key, 'OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
