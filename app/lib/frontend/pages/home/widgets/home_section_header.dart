import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/navigation/main_page_route/main_page_route.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

// Title for sections with the underlined "See More" text
class HomeSectionHeader extends StatelessWidget {
  final String title;
  final MainPageRoute seeMorelinkedPage;
  final KBtn btnKey;

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.seeMorelinkedPage,
    required this.btnKey,
  });

  @override
  Widget build(BuildContext context) {
    uiLogger.fine("Home section header with title '$title' generated.");
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
            TextButton(
              style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll(
                  context.colors.mainColor.withValues(
                    alpha: buttonOverlayAlpha,
                  ),
                ),
              ),
              onPressed: () => ref
                  .read(mainPageRouteProvider.notifier)
                  .setPage(seeMorelinkedPage),
              child: Text(
                key: btnKey.key,
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
