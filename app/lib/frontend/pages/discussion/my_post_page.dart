import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_post_tile.dart';
import 'package:sddp_dsh/frontend/pages/discussion/my_posts_header.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';

class MyPostsPage extends ConsumerStatefulWidget {
  const MyPostsPage({super.key});

  @override
  ConsumerState<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends ConsumerState<MyPostsPage> {
  late final DiscussionServices _discussionService;

  bool isLoading = true;
  String? errorMessage;
  List<DiscussionPost> posts = [];

  // Multi-select state
  final Set<String> _selectedPostIds = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _discussionService = ref.read(discussionServicesProvider);
      _loadPosts();
    });
  }

  Future<void> _loadPosts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      _clearSelection();
    });

    try {
      final fetchedPosts = await _discussionService.fetchPostsWithAvatars();

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
      await _discussionService.deletePosts(postsToDelete);
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

    // Navigate to edit page
    final result = await context.push(
      '/discussion/edit-post',
      extra: postToEdit,
    );

    if (result == true) {
      // Refresh if edit was successful
      await _loadPosts();
    }

    _clearSelection();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _discussionService.supabase.auth.currentUser;
    final currentUserId = currentUser?.id;

    final myPosts = currentUserId == null
        ? <DiscussionPost>[]
        : posts.where((post) => post.userId == currentUserId).toList();

    final selectedCount = _selectedPostIds.length;
    final showEditButton = selectedCount == 1;
    final showDeleteButton = selectedCount > 0;

    return Scaffold(
      body: SafeContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyPostsHeader(
              onBack: () {
                if (_isSelectionMode) {
                  setState(() {
                    _clearSelection();
                  });
                } else {
                  context.pop();
                }
              },
            ),
            Expanded(
              child: Container(
                color: context.colors.whiteBackground,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
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
            ),
            // Bottom Action Bar
            if (showDeleteButton)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
              ),
          ],
        ),
      ),
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
          // Post content
          DiscussionPostTile(post: post),
          // Checkbox overlay (positioned to the right)
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
          // Make entire tile tappable for selection mode
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
