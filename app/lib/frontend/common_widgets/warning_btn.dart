import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

class AlertBtn extends ConsumerWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final Color color;

  const AlertBtn({
    super.key,
    required this.text,
    required this.color,
    this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.finer("Alert button with text '$text' generated.");
    return OutlinedButton.icon(
      onPressed: onPressed,
      label: Text(text, style: TextStyle(color: color)),
      icon: Icon(icon, color: color),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(longBtnWidth, longBtnHeight),
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(baseLength),
        ),
        overlayColor: color,
      ),
    );
  }
}
