import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

// A dialog with yes or no choices
// Helps you navigator.pop() after choice click so you don't have to
class ChoiceDialog extends StatelessWidget {
  final String title;
  final String content;

  final String yesText;
  final TextStyle? yesStyle;

  final String noText;
  final TextStyle? noStyle;

  const ChoiceDialog({
    super.key,
    required this.title,
    required this.content,
    this.yesText = "Yes",
    this.yesStyle,
    this.noText = "No",
    this.noStyle,
  });

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("ChoiceDialog with '$title' generated");
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
          child: Text(noText, style: noStyle),
        ),
        TextButton(
          key: KBtn.choiceDialogYes.key,
          style: btnStyle,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(yesText, style: yesStyle),
        ),
      ],
    );
  }
}
