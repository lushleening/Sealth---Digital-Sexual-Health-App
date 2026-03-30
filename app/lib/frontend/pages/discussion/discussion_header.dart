import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:go_router/go_router.dart';

class DiscussionHeader extends ConsumerWidget {
  final VoidCallback? onBack;

  const DiscussionHeader({super.key, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: context.colors.whiteBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Text(
              "Discussion Board",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: context.colors.textPrimary,
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