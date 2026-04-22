import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

// Title for sections with the underlined "See More" text
class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String? seeMorelinkedPage;
  final KBtn? btnKey;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.seeMorelinkedPage,
    this.btnKey,
  });

  @override
  Widget build(BuildContext context) {
    final s = seeMorelinkedPage;
    uiLogger.finer("Home section header with title '$title' generated.");
    return Consumer(
      builder: (context, ref, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: context.colors.textPrimary,
              ),
            ),

            if (s != null)
              TextButton(
                style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(
                    context.colors.mainColor.withValues(
                      alpha: buttonOverlayAlpha,
                    ),
                  ),
                ),
                onPressed: () => context.go(s),
                child: Text(
                  key: btnKey?.key,
                  'See More',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: context.colors.mainColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: context.colors.mainColor,
                    decorationThickness: 1.5,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
