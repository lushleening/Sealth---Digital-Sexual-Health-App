import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/discussion/models/comments.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_header.dart';

class DiscussionPostPage extends ConsumerWidget {
  final DiscussionPost post;

  const DiscussionPostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colors.whiteBackground,

      body: SafeArea(
        child: Column(
          children: [
            DiscussionHeader(
              onBack: () {}// =>
                  // navPop(context, ref), // changed to use navPop instead
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  CommentWidget(
                    comment: DiscussionComment(
                      id: post.id,
                      postId: post.id,
                      authorName: post.authorName,
                      content: post.content,
                      isVerified: post.isVerified,
                      likes: post.likes,
                      repliesCount: post.comments.length,
                      replies: post.comments,
                    ),
                    depth: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final DiscussionComment comment;
  final int depth;

  const CommentWidget({super.key, required this.comment, required this.depth});

  Widget _iconCounter(BuildContext context, icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.colors.textSecondary),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: depth * 24.0, top: depth == 0 ? 4 : 12),
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
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              comment.authorName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (comment.isVerified)
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
                      const SizedBox(height: 4),
                      Text(comment.content),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: depth == 0
                            ? [
                                _iconCounter(
                                  context,
                                  Icons.favorite_border,
                                  comment.likes,
                                ),
                                const SizedBox(width: 16),
                                _iconCounter(
                                  context,
                                  Icons.chat_bubble_outline,
                                  comment.replies.length,
                                ),
                                const SizedBox(width: 16),
                                _iconCounter(context, Icons.repeat, 0),
                              ]
                            : [
                                _iconCounter(
                                  context,
                                  Icons.favorite_border,
                                  comment.likes,
                                ),
                                const SizedBox(width: 16),
                                _iconCounter(
                                  context,
                                  Icons.chat_bubble_outline,
                                  comment.replies.length,
                                ),
                              ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (comment.replies.isNotEmpty)
              ...comment.replies.map(
                (reply) => CommentWidget(comment: reply, depth: depth + 1),
              ),
          ],
        ),
      ),
    );
  }
}
