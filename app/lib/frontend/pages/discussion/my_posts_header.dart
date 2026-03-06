import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/navigation/safer_navigation/safer_navigation.dart';

class MyPostsHeader extends ConsumerWidget {
  final VoidCallback? onBack;

  const MyPostsHeader({super.key, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: context.colors.whiteBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: context.colors.textPrimary),
              onPressed: onBack ?? () => navPop(context, ref),
            ),
            Text(
              "My Posts",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
