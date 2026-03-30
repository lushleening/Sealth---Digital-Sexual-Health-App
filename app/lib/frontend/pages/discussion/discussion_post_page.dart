import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/models/comments.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_header.dart';
import 'package:go_router/go_router.dart';

class DiscussionPostPage extends ConsumerStatefulWidget {
  final DiscussionPost post;

  const DiscussionPostPage({super.key, required this.post});

  @override
  ConsumerState<DiscussionPostPage> createState() =>
      _DiscussionPostPageState();
}

class _DiscussionPostPageState extends ConsumerState<DiscussionPostPage> {
  final DiscussionServices _service = DiscussionServices();

  bool isLoading = true;
  List<DiscussionComment> comments = [];
  int totalCommentCount = 0;
  late DiscussionPost post;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    _initLike();
    _loadComments();
  }

  Future<void> _initLike() async {
    final liked = await _service.isLiked(post.id);
    if (mounted) setState(() => isLiked = liked);
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
      });
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
      });
    }
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
                  final result = await _service.toggleLike(post.id);
                  setState(() {
                    isLiked = result;
                    post = post.copyWith(
                        likes: isLiked ? post.likes + 1 : post.likes - 1);
                  });
                },
                child: _iconCounter(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  post.likes,
                  isColored: isLiked,
                ),
              ),
              const SizedBox(width: 16),
              _iconCounter(Icons.chat_bubble_outline, totalCommentCount),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildPost(), // Always show the post
                        const SizedBox(height: 16),
                        if (comments.isEmpty)
                          const Center(
                            child: Text("No comments yet"),
                          )
                        else
                          ...comments.map(
                            (c) => CommentWidget(comment: c, depth: 0),
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

// --- Comment Widget ---
class CommentWidget extends StatefulWidget {
  final DiscussionComment comment;
  final int depth;

  const CommentWidget({super.key, required this.comment, required this.depth});

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
                      Text(comment.authorName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
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
                          const SizedBox(width: 16),
                          // UPDATE THIS LINE - show reply count instead of 0
                          _iconCounter(
                            Icons.chat_bubble_outline, 
                            comment.replyCount, // CHANGED FROM 0
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (comment.replies.isNotEmpty)
              ...comment.replies
                  .map((reply) => CommentWidget(comment: reply, depth: widget.depth + 1))
                  ,
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