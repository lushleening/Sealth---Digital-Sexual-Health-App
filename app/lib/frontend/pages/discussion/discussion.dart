import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_post_tile.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_header.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:go_router/go_router.dart';

class DiscussionPage extends ConsumerStatefulWidget {
  const DiscussionPage({super.key});

  @override
  ConsumerState<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends ConsumerState<DiscussionPage> 
    with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  List<DiscussionPost> filteredPosts = [];
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Optional: Refresh when app comes back to foreground
    if (state == AppLifecycleState.resumed) {
      _refreshPosts();
    }
  }

  @override
  void didUpdateWidget(covariant DiscussionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // This will be called when navigating back to this page
    _refreshPosts();
  }

  void _onSearchChanged() {
    final postsAsync = ref.read(postsProvider);
    final query = _searchController.text.trim().toLowerCase();
    
    setState(() {
      if (postsAsync.value != null) {
        filteredPosts = postsAsync.value!.where((post) {
          final title = post.title.trim().toLowerCase();
          return title.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _refreshPosts() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
    });
    
    // Invalidate the provider to trigger a refresh
    ref.invalidate(postsProvider);
    // Wait a bit for the refresh to happen
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsProvider);
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/discussion/create');
          // No need to manually refresh here because didUpdateWidget will handle it
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
              child: postsAsync.when(
                data: (posts) {
                  // Update filtered posts when data changes
                  final query = _searchController.text.trim().toLowerCase();
                  final displayPosts = query.isEmpty ? posts : posts.where((post) {
                    final title = post.title.trim().toLowerCase();
                    return title.contains(query);
                  }).toList();
                  
                  // Update filteredPosts if needed
                  if (filteredPosts != displayPosts) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          filteredPosts = displayPosts;
                        });
                      }
                    });
                  }
                  
                  return displayPosts.isEmpty
                      ? const Center(child: Text('No discussion posts found'))
                      : RefreshIndicator(
                          onRefresh: _refreshPosts,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: displayPosts.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final post = displayPosts[index];
                              return DiscussionPostTile(
                                key: ValueKey(post.id),
                                post: post,
                              );
                            },
                          ),
                        );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error loading posts:\n$error',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshPosts,
                        child: const Text('Retry'),
                      ),
                    ],
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