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

  @override
  void initState() {
    super.initState();
    post = widget.post;
    commentCount = post.comments;
    likeCount = post.likes;
    shareCount = post.shares;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _service = ProviderScope.containerOf(context).read(discussionServicesProvider);
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
    final String shareText = '''
📢 "${post.title}"

${post.content.length > 300 ? post.content.substring(0, 300) + '...' : post.content}

— Posted by ${post.authorName} on Sealth
❤️ ${likeCount} likes | 💬 ${commentCount} comments
''';
    
    // Increment share count in database
    await _service.incrementShareCount(post.id);
    
    // Update local UI
    setState(() {
      shareCount++;
      post = post.copyWith(shares: shareCount);
    });
    
    // Then share
    await Share.share(shareText);
  }

  void _showLoginSnackbar(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please log in to $action posts'),
        duration: const Duration(seconds: 2),
      ),
    );
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
                      children: [
                        Flexible(
                          child: Text(
                            post.authorName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
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