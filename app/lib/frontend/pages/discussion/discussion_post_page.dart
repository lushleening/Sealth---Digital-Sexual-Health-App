import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/models/comments.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_header.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/discussion/post_like_manager.dart';
import 'package:sddp_dsh/backend/discussion/post_comment_manager.dart';

class DiscussionPostPage extends ConsumerStatefulWidget {
  final DiscussionPost post;

  const DiscussionPostPage({super.key, required this.post});

  @override
  ConsumerState<DiscussionPostPage> createState() =>
      _DiscussionPostPageState();
}

class _DiscussionPostPageState extends ConsumerState<DiscussionPostPage> {
  final DiscussionServices _service = DiscussionServices();
  final PostLikeManager _likeManager = PostLikeManager();
  final PostCommentManager _commentManager = PostCommentManager();

  bool isLoading = true;
  List<DiscussionComment> comments = [];
  int totalCommentCount = 0;
  late DiscussionPost post;
  bool isLiked = false;
  int likeCount = 0;
  
  // Add this key to force rebuild of the comment list
  Key _commentsKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    post = widget.post;
    _initLike();
    _loadComments();
    _likeManager.addListener(_onLikeChanged);
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
      final fetched = await _service.fetchComments(post.id);
      final tree = buildCommentTree(fetched);
      if (!mounted) return;
      setState(() {
        comments = tree;
        totalCommentCount = fetched.length;
        isLoading = false;
        _commentsKey = UniqueKey();
      });
      // Initialize the comment count in the manager
      await _commentManager.initializeCommentCount(post.id, fetched.length);
    } catch (e) {
      print("COMMENT LOAD ERROR: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> refreshComments() async {
    final fetched = await _service.fetchComments(post.id);
    final tree = buildCommentTree(fetched);
    if (mounted) {
      setState(() {
        comments = tree;
        totalCommentCount = fetched.length;
        _commentsKey = UniqueKey();
      });
      // Also update the comment count in the manager
      await _commentManager.refreshCommentCount(post.id);
    }
  }

  void _showCommentSheet({DiscussionComment? parentComment}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CommentBottomSheet(
        post: post,
        parentComment: parentComment,
        onCommentSubmitted: () {
          // Refresh comments after posting
          refreshComments();
        },
      ),
    );
  }

  Widget _buildPost() {
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
              CircleAvatar(
                radius: 20,
                child: Text(post.authorName[0].toUpperCase()),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
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
            ],
          ),
          const SizedBox(height: 8),
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(post.content),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
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
                child: _iconCounter(Icons.chat_bubble_outline, totalCommentCount),
              ),
              const SizedBox(width: 16),
              _iconCounter(Icons.repeat, post.shares),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.whiteBackground,
      body: SafeArea(
        child: Column(
          children: [
            DiscussionHeader(onBack: () => context.pop()),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      key: _commentsKey, // Add this key
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildPost(),
                        const SizedBox(height: 16),
                        if (comments.isEmpty)
                          const Center(
                            child: Text("No comments yet"),
                          )
                        else
                          ...comments.map(
                            (c) => CommentWidget(
                              key: ValueKey(c.id), // Add key to each comment
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

// --- Comment Bottom Sheet ---
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
  final DiscussionServices _service = DiscussionServices();
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Auto-focus when sheet opens
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

    setState(() {
      isSubmitting = true;
    });

    try {
      await _service.addComment(
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post: $e')),
        );
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
          // Handle bar
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
          
          // Header
          Text(
            widget.parentComment == null ? 'Add Comment' : 'Add Reply',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Replying to indicator
          if (widget.parentComment != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: context.colors.buttonBorder.withOpacity(0.1),
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
          
          // Input field
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
                borderSide: BorderSide(color: context.colors.mainColor, width: 2),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 16),
          
          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: context.colors.textSecondary,
                  ),
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

// --- Comment Widget ---
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
  final DiscussionServices _service = DiscussionServices();
  late DiscussionComment comment;

  @override
  void initState() {
    super.initState();
    comment = widget.comment;
  }

  Future<void> _toggleLike() async {
    final result = await _service.toggleCommentLike(comment.id);
    setState(() {
      comment = comment.copyWith(
        isLiked: result,
        likes: result ? comment.likes + 1 : comment.likes - 1,
      );
    });
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
                CircleAvatar(
                  radius: 18,
                  child: Text(comment.authorName[0].toUpperCase()),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                          // 👇 ONLY SHOW REPLY BUTTON IF THIS IS A TOP-LEVEL COMMENT (depth == 0)
                          if (widget.depth == 0) ...[
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => widget.onReply(parentComment: comment),
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
            // 👇 Nested replies will show but without reply buttons
            if (comment.replies.isNotEmpty)
              ...comment.replies.map(
                (reply) => CommentWidget(
                  key: ValueKey(reply.id), // Add key to each reply
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