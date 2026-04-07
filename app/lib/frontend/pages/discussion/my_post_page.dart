import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_post_tile.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';
import 'package:sddp_dsh/backend/discussion/avatar_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyPostsPage extends ConsumerStatefulWidget {
  const MyPostsPage({super.key});

  @override
  ConsumerState<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends ConsumerState<MyPostsPage> {
  DiscussionServices? _discussionService;
  bool _isDisposed = false;

  bool isLoading = true;
  String? errorMessage;
  List<DiscussionPost> posts = [];

  final Set<String> _selectedPostIds = {};
  bool _isSelectionMode = false;

  String? _avatarUrl;
  String? _username;
  bool _isLoadingAvatar = true;

  @override
  void initState() {
    super.initState();
    // Initialize immediately, not in post frame callback
    _discussionService = ref.read(discussionServicesProvider);
    _loadUserProfile();
    _loadPosts();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final user = _discussionService!.supabase.auth.currentUser;

    if (user != null) {
      try {
        final response = await _discussionService!.supabase
            .from('profiles')
            .select('avatar_url, username')
            .eq('supabase_id', user.id)
            .maybeSingle();

        if (mounted) {
          setState(() {
            _avatarUrl = response?['avatar_url'];
            _username = response?['username'];
            _isLoadingAvatar = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoadingAvatar = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoadingAvatar = false;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Use addPostFrameCallback to avoid calling during build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to view your posts'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    });
  }

  Future<void> _loadPosts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      _clearSelection();
    });

    try {
      final fetchedPosts = await _discussionService!.fetchPostsWithAvatars();

      if (!mounted) return;

      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _clearSelection() {
    _selectedPostIds.clear();
    _isSelectionMode = false;
  }

  void _toggleSelection(String postId) {
    setState(() {
      if (_selectedPostIds.contains(postId)) {
        _selectedPostIds.remove(postId);
        if (_selectedPostIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedPostIds.add(postId);
        _isSelectionMode = true;
      }
    });
  }

  Future<void> _deleteSelectedPosts() async {
    if (_selectedPostIds.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Posts'),
        content: Text(
          'Are you sure you want to delete ${_selectedPostIds.length} post${_selectedPostIds.length > 1 ? 's' : ''}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final deletedCount = _selectedPostIds.length;
    final postsToDelete = _selectedPostIds.toList();

    setState(() {
      isLoading = true;
    });

    try {
      await _discussionService!.deletePosts(postsToDelete);
      _clearSelection();
      await _loadPosts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Deleted $deletedCount post${deletedCount > 1 ? 's' : ''}',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting posts: $e')));
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _editSelectedPost() async {
    if (_selectedPostIds.length != 1) return;

    final postToEdit = posts.firstWhere((p) => p.id == _selectedPostIds.first);

    final result = await context.push(
      '/discussion/edit-post',
      extra: postToEdit,
    );

    if (result == true) {
      await _loadPosts();
    }

    _clearSelection();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _discussionService?.supabase.auth.currentUser;
    final currentUserId = currentUser?.id;

    final myPosts = currentUserId == null
        ? <DiscussionPost>[]
        : posts.where((post) => post.userId == currentUserId).toList();

    final selectedCount = _selectedPostIds.length;
    final showEditButton = selectedCount == 1;
    final showDeleteButton = selectedCount > 0;

    return Scaffold(
      backgroundColor: context.colors.grayBackground,
      appBar: AppBar(
        title: const Text("My Posts"),
        backgroundColor: context.colors.mainColor,
        foregroundColor: context.colors.textWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _isLoadingAvatar
                ? const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : buildAvatar(
                    context,
                    _avatarUrl,
                    _username ?? 'User',
                    radius: 16,
                  ),
          ),
        ],
      ),
      body: SafeContainer(
        child: isLoading
            ? const Center(child: LoadingCircleMainColor())
            : errorMessage != null
                ? Center(
                    child: Text(
                      'Error loading your posts:\n$errorMessage',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                : currentUserId == null
                    ? const Center(
                        child: Text(
                          'No signed-in user found.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : myPosts.isEmpty
                        ? const Center(
                            child: Text(
                              "You haven't posted anything yet.",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadPosts,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              itemCount: myPosts.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final post = myPosts[index];
                                final isSelected = _selectedPostIds.contains(
                                  post.id,
                                );

                                return _buildPostTile(
                                  post: post,
                                  isSelected: isSelected,
                                  onTap: () {
                                    if (_isSelectionMode) {
                                      _toggleSelection(post.id);
                                    } else {
                                      context.push('/discussion/post', extra: post);
                                    }
                                  },
                                  onLongPress: () {
                                    if (!_isSelectionMode) {
                                      _toggleSelection(post.id);
                                    }
                                  },
                                  onCheckboxTap: () => _toggleSelection(post.id),
                                );
                              },
                            ),
                          ),
      ),
      bottomNavigationBar: showDeleteButton
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.colors.whiteBackground,
                border: Border(
                  top: BorderSide(
                    color: context.colors.buttonBorder,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (showEditButton)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _editSelectedPost,
                        icon: const Icon(Icons.edit, size: 20),
                        label: Text('Edit Post ($selectedCount)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.mainColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  if (showEditButton && showDeleteButton)
                    const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _deleteSelectedPosts,
                      icon: const Icon(Icons.delete_outline, size: 20),
                      label: Text(
                        'Delete ${selectedCount > 1 ? '($selectedCount)' : ''}',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildPostTile({
    required DiscussionPost post,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback onLongPress,
    required VoidCallback onCheckboxTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: isSelected
            ? Border.all(color: context.colors.mainColor, width: 2)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          DiscussionPostTile(post: post),
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: onCheckboxTap,
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.whiteBackground,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Checkbox(
                  value: isSelected,
                  onChanged: (_) => onCheckboxTap(),
                  activeColor: context.colors.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                onLongPress: onLongPress,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}