import 'package:flutter/material.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/testing/key_enum.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';

// A dialog with yes or no choices
// Helps you navigator.pop() so you don't have to
class ChoiceDialog extends StatelessWidget {
  final String title;
  final String content;

  const ChoiceDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    uiLogger.fine("ChoiceDialog with '$title' generated");
    final btnStyle = ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(context.colors.mainColor),
      overlayColor: WidgetStatePropertyAll(
        context.colors.mainColor.withValues(alpha: buttonOverlayAlpha),
      ),
    );

    return AlertDialog(
      backgroundColor: context.colors.whiteBackground,
      title: Text(title, style: TextStyle(color: context.colors.textPrimary)),
      content: Text(
        content,
        style: TextStyle(color: context.colors.textPrimary),
      ),
      actions: [
        TextButton(
          key: KBtn.choiceDialogNo.key,
          style: btnStyle,
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No'),
        ),
        TextButton(
          key: KBtn.choiceDialogYes.key,
          style: btnStyle,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Yes'),
        ),
      ],
    );
  }
}
