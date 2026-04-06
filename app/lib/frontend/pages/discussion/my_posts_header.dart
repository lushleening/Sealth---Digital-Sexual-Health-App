import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/avatar_helper.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';

class MyPostsHeader extends ConsumerStatefulWidget {
  final VoidCallback? onBack;

  const MyPostsHeader({super.key, this.onBack});

  @override
  ConsumerState<MyPostsHeader> createState() => _MyPostsHeaderState();
}

class _MyPostsHeaderState extends ConsumerState<MyPostsHeader> {
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
        discussionLogger.severe('Error loading profile: $e');
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: context.colors.textPrimary),
              onPressed: widget.onBack ?? () {},
            ),
            Text(
              "My Posts",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            const Spacer(),
            _isLoading
                ? SizedBox(
                    width: 40,
                    height: 40,
                    child: LoadingCircleMainColor(),
                  )
                : buildAvatar(
                    context,
                    _avatarUrl,
                    _username ?? 'User',
                    radius: 20,
                  ),
          ],
        ),
      ),
    );
  }
}
