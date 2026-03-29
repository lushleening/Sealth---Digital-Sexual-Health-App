import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_post_tile.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_header.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:go_router/go_router.dart';

class DiscussionPage extends ConsumerStatefulWidget {
  const DiscussionPage({super.key});

  @override
  ConsumerState<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends ConsumerState<DiscussionPage> {
  final DiscussionServices _discussionService = DiscussionServices();

  String searchQuery = "";
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

    print('LOAD POSTS STARTED');

    try {
      final fetchedPosts = await _discussionService.fetchPosts();
      print('FETCHED POSTS IN PAGE: ${fetchedPosts.length}');

      if (!mounted) return;

      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });

      print('POSTS STORED IN STATE: ${posts.length}');
    } catch (e) {
      print('LOAD POSTS ERROR: $e');

      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPosts = posts.where((post) {
      final query = searchQuery.toLowerCase();
      return post.title.toLowerCase().contains(query) ||
          post.content.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push('/discussion/create');

          if (result == true) {
            _loadPosts();
          }
        },
        backgroundColor: context.colors.textBoxFill,
        child: Icon(Icons.add, size: 28, color: context.colors.textPrimary),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: SafeContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DiscussionHeader(
              onBack: () {
                // Use your Riverpod page notifier to go back to Home
                context.pop(); // changed to use navPop instead; // changed to use navPop instead
              },
            ),

            Container(
              color: context.colors.whiteBackground,
              padding: const EdgeInsets.all(16),
              child: TextField(
                style: TextStyle(color: context.colors.textPrimary),
                decoration: InputDecoration(
                  hintText: "Search discussions...",
                  hintStyle: TextStyle(color: context.colors.textPrimary),
                  prefixIcon: Icon(
                    Icons.search,
                    color: context.colors.textPrimary,
                  ),
                  filled: true,
                  fillColor: context.colors.textBoxFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),

            Expanded(
              child: Container(
                color: context.colors.whiteBackground,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(
                            child: Text(
                              'Error loading posts:\n$errorMessage',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : filteredPosts.isEmpty
                            ? const Center(
                                child: Text('No discussion posts found'),
                              )
                            : RefreshIndicator(
                                onRefresh: _loadPosts,
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  itemCount: filteredPosts.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    return DiscussionPostTile(
                                      post: filteredPosts[index],
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