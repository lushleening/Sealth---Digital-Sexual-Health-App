import 'package:flutter/material.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';

// Draw a red dot indicating status update
class RedDot extends StatelessWidget {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? radius;
  const RedDot({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    uiLogger.fine("Red dot signifying there is new stuff was generated");
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          color: context.colors.warning,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
