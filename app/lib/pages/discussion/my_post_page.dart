import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/helper/safe_nav.dart';
import '../../common_widgets/safe_container.dart';
import 'package:sddp_dsh/pages/discussion/discussion_post_tile.dart';
import 'package:sddp_dsh/pages/discussion/my_posts_header.dart';
import 'discussion.dart'; // so we can access dummyPosts
import 'package:sddp_dsh/helper/colors.dart';

class MyPostsPage extends ConsumerStatefulWidget {
  const MyPostsPage({super.key});

  @override
  ConsumerState<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends ConsumerState<MyPostsPage> {
  final String currentUser = "A";

  @override
  Widget build(BuildContext context) {
    final myPosts = dummyPosts
        .where((post) => post.authorName == currentUser)
        .toList();

    return Scaffold(
      body: SafeContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyPostsHeader(
              onBack: () {
                navPop(context, ref); // changed to use navPop instead;
              },
            ),

            Expanded(
              child: Container(
                color: context.colors.whiteBackground,
                child: myPosts.isEmpty
                    ? const Center(
                        child: Text(
                          "You haven't posted anything yet.",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: myPosts.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return DiscussionPostTile(post: myPosts[index]);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
