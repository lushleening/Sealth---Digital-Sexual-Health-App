import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/post_like_manager.dart';
import 'package:sddp_dsh/backend/discussion/post_comment_manager.dart';
import 'package:sddp_dsh/backend/discussion/avatar_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';

class DiscussionPostTile extends StatefulWidget {
  final DiscussionPost post;

  const DiscussionPostTile({super.key, required this.post});

  @override
  State<DiscussionPostTile> createState() => _DiscussionPostTileState();
}

class _DiscussionPostTileState extends State<DiscussionPostTile> {
  late DiscussionPost post;
  bool isLiked = false;
  int likeCount = 0;
  int commentCount = 0;
  int shareCount = 0;
  final PostLikeManager _likeManager = PostLikeManager();
  final PostCommentManager _commentManager = PostCommentManager();
  late final DiscussionServices _service;

  final List<String> _reportReasons = [
    'Spam',
    'Harassment',
    'Hate speech',
    'Misinformation',
    'Inappropriate content',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    post = widget.post;
    commentCount = post.comments;
    likeCount = post.likes;
    shareCount = post.shares;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _service = ProviderScope.containerOf(
        context,
      ).read(discussionServicesProvider);
      _initLike();
      _initCommentCount();
      _likeManager.addListener(_onLikeChanged);
      _commentManager.addListener(_onCommentCountChanged);
    });
  }

  @override
  void dispose() {
    _likeManager.removeListener(_onLikeChanged);
    _commentManager.removeListener(_onCommentCountChanged);
    super.dispose();
  }

  void _onLikeChanged() {
    if (mounted) {
      final info = _likeManager.getLikeInfo(post.id);
      if (info != null) {
        setState(() {
          isLiked = info.isLiked;
          likeCount = info.likeCount;
          post = post.copyWith(likes: info.likeCount);
        });
      }
    }
  }

  void _onCommentCountChanged() {
    if (mounted) {
      final count = _commentManager.getCommentCount(post.id);
      if (count != null && count != commentCount) {
        setState(() {
          commentCount = count;
          post = post.copyWith(comments: count);
        });
      }
    }
  }

  Future<void> _initLike() async {
    await _likeManager.initializeLike(post.id, post.likes);
    final info = _likeManager.getLikeInfo(post.id);
    if (info != null && mounted) {
      setState(() {
        isLiked = info.isLiked;
        likeCount = info.likeCount;
      });
    }
  }

  Future<void> _initCommentCount() async {
    await _commentManager.initializeCommentCount(post.id, post.comments);
  }

  Future<void> _toggleLike() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _showLoginSnackbar('like');
      return;
    }
    await _likeManager.toggleLike(post.id);
  }

  Future<void> _sharePost() async {
    final String shareText =
        '''
📢 "${post.title}"

${post.content.length > 300 ? '${post.content.substring(0, 300)}...' : post.content}

— Posted by ${post.authorName} on Sealth
❤️ $likeCount likes | 💬 $commentCount comments
''';

    await _service.incrementShareCount(post.id);

    setState(() {
      shareCount++;
      post = post.copyWith(shares: shareCount);
    });

    await SharePlus.instance.share(
      ShareParams(text: shareText),
    );
  }

  Future<void> _reportPost() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to report')),
        );
      }
      return;
    }
    
    String? selectedReason;
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Post'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Why are you reporting this post?'),
              const SizedBox(height: 16),
              ..._reportReasons.map((reason) => ListTile(
                title: Text(reason),
                trailing: selectedReason == reason
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.circle_outlined),
                onTap: () {
                  selectedReason = reason;
                  Navigator.pop(context, reason);
                },
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    
    if (result != null && mounted) {
      try {
        await _service.reportPost(post.id, result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post reported. Thank you for your feedback.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to report: $e')),
          );
        }
      }
    }
  }

  Future<void> _blockUser() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to block users')),
        );
      }
      return;
    }
    
    // Check for anonymous users
    if (post.authorName == 'Anonymous') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot block anonymous users')),
        );
      }
      return;
    }
    
    if (post.userId == user.id) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You cannot block yourself')),
        );
      }
      return;
    }
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text('Are you sure you want to block ${post.authorName}? You will no longer see their posts.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Block'),
          ),
        ],
      ),
    );
    
    if (confirm == true && mounted) {
      try {
        await _service.blockUser(post.userId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${post.authorName} has been blocked.')),
          );
          
          // Invalidate the provider to refresh the discussion page
          final container = ProviderScope.containerOf(context);
          container.invalidate(postsProvider);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to block user: $e')),
          );
        }
      }
    }
  }

  void _showMenu(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final isOwnPost = user?.id == post.userId;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isOwnPost) ...[
              ListTile(
                leading: const Icon(Icons.flag, color: Colors.orange),
                title: const Text('Report Post'),
                onTap: () {
                  Navigator.pop(context);
                  _reportPost();
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Block User'),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser();
                },
              ),
            ],
            if (isOwnPost)
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Edit Post'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/discussion/edit-post', extra: post);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showLoginSnackbar(String action) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please log in to $action posts'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _iconCounter(
    BuildContext context,
    IconData icon,
    int count, {
    bool isColored = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isColored ? Colors.red : context.colors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push('/discussion/post', extra: post);
        },
        child: Container(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.colors.whiteBackground,
            border: Border.all(color: context.colors.buttonBorder, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAvatar(context, post.avatarUrl, post.authorName, radius: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              Text(
                                post.authorName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (post.isVerified)
                                Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.verified,
                                    size: 16,
                                    color: context.colors.mainColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showMenu(context),
                          child: Icon(
                            Icons.more_vert,
                            size: 20,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _iconCounter(
                          context,
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          likeCount,
                          isColored: isLiked,
                          onTap: _toggleLike,
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            context.push('/discussion/post', extra: post);
                          },
                          child: _iconCounter(
                            context,
                            Icons.chat_bubble_outline,
                            commentCount,
                          ),
                        ),
                        const SizedBox(width: 16),
                        _iconCounter(
                          context,
                          Icons.repeat,
                          shareCount,
                          onTap: _sharePost,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}