import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/models/comments.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/user_avatar.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/discussion/post_like_manager.dart';
import 'package:sddp_dsh/backend/discussion/post_comment_manager.dart';
import 'package:sddp_dsh/backend/discussion/avatar_helper.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';

class DiscussionPostPage extends ConsumerStatefulWidget {
  final DiscussionPost post;

  const DiscussionPostPage({super.key, required this.post});

  @override
  ConsumerState<DiscussionPostPage> createState() => _DiscussionPostPageState();
}

class _DiscussionPostPageState extends ConsumerState<DiscussionPostPage> {
  late final DiscussionServices _service;
  late final PostLikeManager _likeManager;
  late final PostCommentManager _commentManager;

  bool isLoading = true;
  List<DiscussionComment> comments = [];
  int totalCommentCount = 0;
  late DiscussionPost post;
  bool isLiked = false;
  int likeCount = 0;
  int shareCount = 0;

  Key _commentsKey = UniqueKey();

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
    shareCount = post.shares;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _service = ref.read(discussionServicesProvider);

      _likeManager = PostLikeManager();
      _commentManager = PostCommentManager();
      _likeManager.initialize(_service);
      _commentManager.initialize(_service);

      _initLike();
      _loadComments();
      _likeManager.addListener(_onLikeChanged);
    });
  }

  @override
  void dispose() {
    _likeManager.removeListener(_onLikeChanged);
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

  Future<void> _loadComments() async {
    try {
      final fetched = await _service.fetchCommentsWithAvatars(post.id);
      final tree = buildCommentTree(fetched);
      if (!mounted) return;
      setState(() {
        comments = tree;
        totalCommentCount = fetched.length;
        isLoading = false;
        _commentsKey = UniqueKey();
      });
      await _commentManager.initializeCommentCount(post.id, fetched.length);
    } catch (e) {
      discussionLogger.severe("COMMENT LOAD ERROR: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> refreshComments() async {
    final fetched = await _service.fetchCommentsWithAvatars(post.id);
    final tree = buildCommentTree(fetched);
    if (mounted) {
      setState(() {
        comments = tree;
        totalCommentCount = fetched.length;
        _commentsKey = UniqueKey();
      });
      await _commentManager.refreshCommentCount(post.id);
    }
  }

  void _showCommentSheet({DiscussionComment? parentComment}) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _showLoginSnackbarForComment();
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CommentBottomSheet(
        post: post,
        parentComment: parentComment,
        onCommentSubmitted: () {
          refreshComments();
        },
      ),
    );
  }

  void _showLoginSnackbarForComment() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to comment'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showLoginSnackbarForLike() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to like posts'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showLoginSnackbarForCreatePost() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to create a post'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleCreatePost() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _showLoginSnackbarForCreatePost();
      return;
    }
    context.push('/discussion/create');
  }

  Future<void> _sharePost() async {
    final shareText = await _service.getShareText(post, likeCount, totalCommentCount);
    await _service.incrementShareCount(post.id);
    
    setState(() {
      shareCount++;
      post = post.copyWith(shares: shareCount);
    });
    
    await SharePlus.instance.share(ShareParams(text: shareText));
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
            style: TextButton.styleFrom(foregroundColor: context.colors.mainColor),
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
          
          ref.invalidate(postsProvider);
          context.pop();
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

  void _showPostMenu(BuildContext context) {
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

  Widget _buildPost() {
    final user = Supabase.instance.client.auth.currentUser;
    final isGuest = user == null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.whiteBackground,
        border: Border.all(color: context.colors.buttonBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              buildAvatar(context, post.avatarUrl, post.authorName, radius: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
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
                              padding: const EdgeInsets.only(left: 4),
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
                      onTap: () => _showPostMenu(context),
                      child: Icon(
                        Icons.more_vert,
                        size: 20,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            post.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(post.content),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  if (isGuest) {
                    _showLoginSnackbarForLike();
                    return;
                  }
                  await _likeManager.toggleLike(post.id);
                },
                child: _iconCounter(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  likeCount,
                  isColored: isLiked,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => _showCommentSheet(parentComment: null),
                child: _iconCounter(
                  Icons.chat_bubble_outline,
                  totalCommentCount,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: _sharePost,
                child: _iconCounter(Icons.repeat, shareCount),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.whiteBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: c.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Padding(
          padding: EdgeInsetsGeometry.directional(start: 16, end: 16, top: 8),
          child: Text("Post"),
        ),
        backgroundColor: c.whiteBackground,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: _handleCreatePost,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.add, color: c.mainColor),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => context.go('/discussion/my-posts'),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: UserAvatar(
                iconRadius: iconSizeSmall,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: isLoading
                ? const Center(child: LoadingCircleMainColor())
                : ListView(
                    key: _commentsKey,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildPost(),
                      const SizedBox(height: 16),
                      if (comments.isEmpty)
                        const Center(child: Text("No comments yet"))
                      else
                        ...comments.map(
                          (c) => CommentWidget(
                            key: ValueKey(c.id),
                            comment: c,
                            depth: 0,
                            onReply: _showCommentSheet,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _iconCounter(IconData icon, int count, {bool isColored = false}) {
    return Row(
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
    );
  }
}

// --- Comment Bottom Sheet (unchanged) ---
class _CommentBottomSheet extends StatefulWidget {
  final DiscussionPost post;
  final DiscussionComment? parentComment;
  final VoidCallback onCommentSubmitted;

  const _CommentBottomSheet({
    required this.post,
    this.parentComment,
    required this.onCommentSubmitted,
  });

  @override
  State<_CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<_CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  DiscussionServices? _service;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _service = ProviderScope.containerOf(context).read(discussionServicesProvider);
      }
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    if (_service == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service not ready. Please try again.')),
        );
      }
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await _service!.addCommentWithAvatar(
        postId: widget.post.id,
        content: content,
        parentCommentId: widget.parentComment?.id,
      );

      if (mounted) {
        Navigator.pop(context);
        widget.onCommentSubmitted();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.parentComment == null
                  ? 'Comment posted!'
                  : 'Reply posted!',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to post: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: context.colors.whiteBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.buttonBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.parentComment == null ? 'Add Comment' : 'Add Reply',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (widget.parentComment != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: context.colors.buttonBorder.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Replying to @${widget.parentComment!.authorName}',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colors.mainColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.parentComment!.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: 5,
            minLines: 3,
            decoration: InputDecoration(
              hintText: widget.parentComment == null
                  ? 'Write a comment...'
                  : 'Write your reply...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.colors.buttonBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.colors.buttonBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: context.colors.mainColor,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: context.colors.textSecondary),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        widget.parentComment == null ? 'Post' : 'Reply',
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// --- Comment Widget (unchanged) ---
class CommentWidget extends StatefulWidget {
  final DiscussionComment comment;
  final int depth;
  final void Function({DiscussionComment? parentComment}) onReply;

  const CommentWidget({
    super.key,
    required this.comment,
    required this.depth,
    required this.onReply,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  DiscussionServices? _service;
  late DiscussionComment comment;

  @override
  void initState() {
    super.initState();
    comment = widget.comment;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _service = ProviderScope.containerOf(context).read(discussionServicesProvider);
      }
    });
  }

  Future<void> _toggleLike() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _showLoginSnackbarForCommentLike();
      return;
    }
    
    if (_service == null) return;
    
    final result = await _service!.toggleCommentLike(comment.id);
    setState(() {
      comment = comment.copyWith(
        isLiked: result,
        likes: result ? comment.likes + 1 : comment.likes - 1,
      );
    });
  }

  void _showLoginSnackbarForCommentLike() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to like comments'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleReply() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to reply'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }
    widget.onReply(parentComment: comment);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.depth * 24.0, top: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colors.whiteBackground,
          border: Border.all(color: context.colors.buttonBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAvatar(
                  context,
                  comment.avatarUrl,
                  comment.authorName,
                  radius: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.authorName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (comment.isVerified)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.verified,
                                size: 14,
                                color: context.colors.mainColor,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(comment.content),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: _toggleLike,
                            child: _iconCounter(
                              comment.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              comment.likes,
                              isColored: comment.isLiked,
                            ),
                          ),
                          if (widget.depth == 0) ...[
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: _handleReply,
                              child: _iconCounter(
                                Icons.chat_bubble_outline,
                                comment.replyCount,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (comment.replies.isNotEmpty)
              ...comment.replies.map(
                (reply) => CommentWidget(
                  key: ValueKey(reply.id),
                  comment: reply,
                  depth: widget.depth + 1,
                  onReply: widget.onReply,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _iconCounter(IconData icon, int count, {bool isColored = false}) {
    return Row(
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
    );
  }
}