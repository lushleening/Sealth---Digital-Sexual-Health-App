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
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;
  String? errorMessage;
  List<DiscussionPost> posts = [];
  List<DiscussionPost> filteredPosts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadPosts();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      filteredPosts = posts.where((post) {
        final title = post.title.trim().toLowerCase();
        return title.contains(query); // Only filter by title
      }).toList();
    });
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
        // Apply current search query on titles only
        final query = _searchController.text.trim().toLowerCase();
        filteredPosts = posts.where((post) {
          final title = post.title.trim().toLowerCase();
          return title.contains(query);
        }).toList();
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
            DiscussionHeader(onBack: () => context.pop()),
            Container(
              color: context.colors.whiteBackground,
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: context.colors.textPrimary),
                decoration: InputDecoration(
                  hintText: "Search discussions...",
                  hintStyle: TextStyle(color: context.colors.textSecondary),
                  prefixIcon: Icon(Icons.search, color: context.colors.textSecondary),
                  filled: true,
                  fillColor: context.colors.textBoxFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
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
                          ? const Center(child: Text('No discussion posts found'))
                          : RefreshIndicator(
                              onRefresh: _loadPosts,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                itemCount: filteredPosts.length,
                                separatorBuilder: (_, _) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final post = filteredPosts[index];
                                  return DiscussionPostTile(
                                    key: ValueKey(post.id),
                                    post: post,
                                  );
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
