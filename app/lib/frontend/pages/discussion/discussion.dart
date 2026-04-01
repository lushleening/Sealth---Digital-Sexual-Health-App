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
  bool _shouldRefresh = false;
  Key _listKey = UniqueKey(); // 👈 ADD THIS

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
    if (state == AppLifecycleState.resumed) {
      _refreshPosts();
    }
  }

  @override
  void didUpdateWidget(covariant DiscussionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _refreshPosts();
  }

  @override
  void activate() {
    super.activate();
    if (_shouldRefresh) {
      _refreshPosts();
      _shouldRefresh = false;
    }
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

    print('🔄 Refreshing posts...');
    setState(() {
      _isRefreshing = true;
    });

    // Invalidate the provider to trigger a refresh
    ref.invalidate(postsProvider);
    
    // Wait for the new data to load
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      // Generate a new key to force rebuild of the list
      setState(() {
        _listKey = UniqueKey(); // 👈 FORCE REBUILD
        _isRefreshing = false;
      });
      print('✅ Posts refreshed and list rebuilt');
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/discussion/create');
          _shouldRefresh = true;
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
                  prefixIcon: Icon(
                    Icons.search,
                    color: context.colors.textSecondary,
                  ),
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
                  final query = _searchController.text.trim().toLowerCase();
                  final displayPosts = query.isEmpty
                      ? posts
                      : posts.where((post) {
                          final title = post.title.trim().toLowerCase();
                          return title.contains(query);
                        }).toList();

                  return displayPosts.isEmpty
                      ? const Center(child: Text('No discussion posts found'))
                      : RefreshIndicator(
                          onRefresh: _refreshPosts,
                          child: ListView.separated(
                            key: _listKey, // 👈 ADD THIS KEY
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: displayPosts.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final post = displayPosts[index];
                              return DiscussionPostTile(
                                key: ValueKey('${post.id}_${post.updatedAt}'), // 👈 ADD updatedAt to key
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