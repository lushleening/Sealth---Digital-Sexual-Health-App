import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/helper/safe_nav.dart';
import 'package:sddp_dsh/pages/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/pages/discussion/discussion_post_page.dart';
import 'package:sddp_dsh/helper/colors.dart';

class DiscussionPostTile extends ConsumerWidget {
  final DiscussionPost post;

  const DiscussionPostTile({super.key, required this.post});

  Widget _iconCounter(BuildContext context, IconData icon, int count) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => navPush(context, ref, DiscussionPostPage(post: post)),
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
                          Icons.favorite_border,
                          post.likes,
                        ),
                        const SizedBox(width: 16),
                        _iconCounter(
                          context,
                          Icons.chat_bubble_outline,
                          post.comments.length,
                        ),
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
