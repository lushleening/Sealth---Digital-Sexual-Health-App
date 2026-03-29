import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_post_tile.dart';
import 'package:sddp_dsh/frontend/pages/discussion/my_posts_header.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyPostsPage extends ConsumerStatefulWidget {
  const MyPostsPage({super.key});

  @override
  ConsumerState<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends ConsumerState<MyPostsPage> {
  final DiscussionServices _discussionService = DiscussionServices();

  bool isLoading = true;
  String? errorMessage;
  List<DiscussionPost> posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedPosts = await _discussionService.fetchPosts();

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

  @override
  Widget build(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;
    final currentUserId = currentUser?.id;

    final myPosts = currentUserId == null
        ? <DiscussionPost>[]
        : posts.where((post) => post.userId == currentUserId).toList();

    return Scaffold(
      body: SafeContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyPostsHeader(
              onBack: () => context.pop(),
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
                                        return DiscussionPostTile(
                                          post: myPosts[index],
                                        );
                                      },
                                    ),
                                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}