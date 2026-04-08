import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/frontend/common_widgets/user_avatar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DiscussionHeader extends ConsumerStatefulWidget {
  final VoidCallback? onBack;

  const DiscussionHeader({super.key, this.onBack});

  @override
  ConsumerState<DiscussionHeader> createState() => _DiscussionHeaderState();
}

class _DiscussionHeaderState extends ConsumerState<DiscussionHeader> {
  // Removed unused _service variable

  @override
  void initState() {
    super.initState();
    // Removed _service initialization since it's not used
  }

  void _showLoginSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please log in to create a post'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleCreatePost() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _showLoginSnackbar();
      return;
    }
    context.push('/discussion/create');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.whiteBackground,
      child: Padding(
        padding: const EdgeInsets.all(baseLength),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Discussion Board",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: _handleCreatePost,
                  child: Icon(Icons.add, color: context.colors.mainColor),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => context.go('/discussion/my-posts'),
                  child: UserAvatar(
                    iconRadius: iconSizeSmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}