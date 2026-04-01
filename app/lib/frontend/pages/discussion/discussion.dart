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
  Key _listKey = UniqueKey();

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

    ref.invalidate(postsProvider);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() {
        _listKey = UniqueKey();
        _isRefreshing = false;
      });
      print('✅ Posts refreshed and list rebuilt');
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      body: SafeContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DiscussionHeader(onBack: () => context.pop()),
              const SizedBox(height: 20),
              // Search section - matching articles page style
              Container(
                color: context.colors.whiteBackground,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
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
              const SizedBox(height: 20),
              // Posts list
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
                              key: _listKey,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 8,
                              ),
                              itemCount: displayPosts.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final post = displayPosts[index];
                                return DiscussionPostTile(
                                  key: ValueKey('${post.id}_${post.updatedAt}'),
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
      ),
    );
  }
}