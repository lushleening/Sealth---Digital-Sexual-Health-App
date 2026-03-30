import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:go_router/go_router.dart';

class DiscussionPostTile extends ConsumerStatefulWidget {
  final DiscussionPost post;

  const DiscussionPostTile({super.key, required this.post});

  @override
  ConsumerState<DiscussionPostTile> createState() =>
      _DiscussionPostTileState();
}

class _DiscussionPostTileState extends ConsumerState<DiscussionPostTile> {
  late DiscussionPost post;
  final DiscussionServices _service = DiscussionServices();
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    _initLike();
  }

  Future<void> _initLike() async {
    final liked = await _service.isLiked(post.id);
    if (!mounted) return;
    setState(() {
      isLiked = liked;
    });
  }

  Future<void> _toggleLike() async {
    final result = await _service.toggleLike(post.id);
    if (!mounted) return;
    setState(() {
      isLiked = result;
      post = post.copyWith(
          likes: isLiked ? post.likes + 1 : post.likes - 1);
    });
  }

  Widget _iconCounter(BuildContext context, IconData icon, int count,
      {bool isColored = false, VoidCallback? onTap}) {
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
              CircleAvatar(
                radius: 20,
                child: Text(post.authorName[0].toUpperCase()),
              ),
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
                          post.likes,
                          isColored: isLiked,
                          onTap: _toggleLike,
                        ),
                        const SizedBox(width: 16),
                        _iconCounter(context, Icons.chat_bubble_outline,
                            post.comments),
                        const SizedBox(width: 16),
                        _iconCounter(context, Icons.repeat, post.shares),
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