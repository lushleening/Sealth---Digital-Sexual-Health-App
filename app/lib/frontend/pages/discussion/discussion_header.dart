import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/discussion/avatar_helper.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';

class DiscussionHeader extends ConsumerStatefulWidget {
  final VoidCallback? onBack;

  const DiscussionHeader({super.key, this.onBack});

  @override
  ConsumerState<DiscussionHeader> createState() => _DiscussionHeaderState();
}

class _DiscussionHeaderState extends ConsumerState<DiscussionHeader> {
  String? _avatarUrl;
  String? _username;
  bool _isLoading = true;

  // Don't create service directly - get it from provider
  late final DiscussionServices _service;

  @override
  void initState() {
    super.initState();
    // Get service after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _service = ref.read(discussionServicesProvider);
      _loadUserProfile();
    });
  }

  Future<void> _loadUserProfile() async {
    final user = _service.supabase.auth.currentUser;

    if (user != null) {
      try {
        final response = await _service.supabase
            .from('profiles')
            .select('avatar_url, username')
            .eq('supabase_id', user.id)
            .maybeSingle();

        if (mounted) {
          setState(() {
            _avatarUrl = response?['avatar_url'];
            _username = response?['username'];
            _isLoading = false;
          });
        }
      } catch (e) {
        discussionLogger.info('Error loading profile: $e');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                  onTap: () => context.push('/discussion/create'),
                  child: Icon(Icons.add, color: context.colors.mainColor),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => context.go('/discussion/my-posts'),
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.colors.mainColor,
                          ),
                        )
                      : buildAvatar(
                          context,
                          _avatarUrl,
                          _username ?? 'User',
                          radius: 12,
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
