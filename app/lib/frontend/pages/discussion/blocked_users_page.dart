import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/avatar_helper.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:go_router/go_router.dart';

class BlockedUsersPage extends ConsumerStatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  ConsumerState<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends ConsumerState<BlockedUsersPage> {
  late final DiscussionServices _service;
  List<BlockedUser> _blockedUsers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final supabase = ref.read(supabaseServiceProvider);
    _service = DiscussionServices(supabase: supabase);
    _loadBlockedUsers();
  }

  Future<void> _loadBlockedUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = _service.supabase.auth.currentUser?.id;
      if (userId == null) {
        setState(() {
          _errorMessage = 'Please log in to view blocked users';
          _isLoading = false;
        });
        return;
      }

      final blockedProfiles = await _service.getBlockedUsersWithProfiles();
      
      if (mounted) {
        setState(() {
          _blockedUsers = blockedProfiles.map((profile) => BlockedUser(
            userId: profile['user_id'],
            username: profile['username'],
            avatarUrl: profile['avatar_url'],
          )).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load blocked users: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _unblockUser(String userIdToUnblock, String username) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unblock User'),
        content: Text('Are you sure you want to unblock $username?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Unblock'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await _service.unblockUser(userIdToUnblock);
        
        if (mounted) {
          setState(() {
            _blockedUsers.removeWhere((user) => user.userId == userIdToUnblock);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$username has been unblocked')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to unblock: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.whiteBackground,
      appBar: AppBar(
        title: const Text("Blocked Users"),
        backgroundColor: c.mainColor,
        foregroundColor: c.textWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: LoadingCircleMainColor())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: c.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadBlockedUsers,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _blockedUsers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.block,
                            size: 64,
                            color: c.textSecondary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No blocked users',
                            style: TextStyle(
                              fontSize: 18,
                              color: c.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Users you block will appear here',
                            style: TextStyle(
                              fontSize: 14,
                              color: c.textSecondary.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadBlockedUsers,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: _blockedUsers.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final user = _blockedUsers[index];
                          return _BlockedUserTile(
                            user: user,
                            onUnblock: () => _unblockUser(user.userId, user.username),
                          );
                        },
                      ),
                    ),
    );
  }
}

class _BlockedUserTile extends StatelessWidget {
  final BlockedUser user;
  final VoidCallback onUnblock;

  const _BlockedUserTile({
    required this.user,
    required this.onUnblock,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          buildAvatar(context, user.avatarUrl, user.username, radius: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              user.username,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: c.textPrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: onUnblock,
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text(
              'Unblock',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlockedUser {
  final String userId;
  final String username;
  final String? avatarUrl;

  BlockedUser({
    required this.userId,
    required this.username,
    this.avatarUrl,
  });
}