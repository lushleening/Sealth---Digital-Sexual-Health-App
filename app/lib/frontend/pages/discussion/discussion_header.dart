import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';

class DiscussionHeader extends ConsumerWidget {
  final VoidCallback? onBack;

  const DiscussionHeader({super.key, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: context.colors.whiteBackground,
      child: Padding(
        padding: const EdgeInsetsGeometry.directional(start: 16, end: 16, top: 8),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.directional(start: baseLength / 2),
              child: Text(
                "Discussion Board",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                Icons.person_outline,
                color: context.colors.textPrimary,
              ),
              onPressed: () => context.go('/discussion/my-posts'),
            ),
          ],
        ),
      ),
    );
  }
}
