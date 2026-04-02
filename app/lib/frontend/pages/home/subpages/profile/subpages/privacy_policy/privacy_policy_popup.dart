import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/privacy_policy_text.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

class PrivacyPolicyPopup extends StatelessWidget {
  const PrivacyPolicyPopup({super.key});

  List<Widget> _buildPolicyWidgets(BuildContext context) {
    final parts = privacyPolicyText.split(privacyPolicyDivider);
    List<Widget> widgets = [];
    for (int i = 0; i < parts.length; i++) {
      widgets.add(
        SelectableText(
          parts[i].trim(),
          style: TextStyle(fontSize: 14, color: context.colors.textPrimary),
          // textAlign: TextAlign.center,
        ),
      );

      // Add real divider between sections
      if (i != parts.length - 1) {
        widgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
        );
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("Privacy Policy popup generated.");

    return Dialog(
      backgroundColor: context.colors.whiteBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildPolicyWidgets(context),
                ),
              ),
            ),

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
                child: Text(key: KBtn.navClosePopup.key, 'OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
