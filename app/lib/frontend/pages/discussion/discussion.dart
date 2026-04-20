import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_post_tile.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/frontend/common_widgets/user_avatar.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';

enum SortOption {
  newest('Most Recently Updated', 'updated_at', false),
  mostLiked('Most Liked', 'likes', true),
  mostCommented('Most Commented', 'comments', true),
  mostShared('Most Shared', 'shares', true);

  final String label;
  final String field;
  final bool descending;

  const SortOption(this.label, this.field, this.descending);
}

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
  
  // Sort option state
  SortOption _currentSort = SortOption.newest;

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

  void _setSortOption(SortOption option) {
    setState(() {
      _currentSort = option;
    });
    _refreshPosts();
  }

  Future<void> _refreshPosts() async {
    if (_isRefreshing) return;

    discussionLogger.info('🔄 Refreshing posts...');
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
      discussionLogger.info('✅ Posts refreshed and list rebuilt');
    }
  }

  void _showLoginSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please log in to create a post'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleCreatePost() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _showLoginSnackbar();
      return;
    }
    
    // ✅ CHANGE THIS - Wait for result and refresh if post was created
    final result = await context.push('/discussion/create');
    if (result == true) {
      // Refresh the posts list
      ref.invalidate(postsProvider);
    }
  }

  void _showProfileMenu(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to view your profile')),
      );
      return;
    }
    
    // Get the profile async value
    final profileAsync = ref.read(appRegisteredProfileProvider);
    
    // Extract verified status
    bool isVerified = false;
    profileAsync.when(
      data: (profile) => isVerified = profile?.verified ?? false,
      loading: () => isVerified = false,
      error: (_, _) => isVerified = false,
    );
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.article, color: Colors.blue),
              title: const Text('My Posts'),
              onTap: () {
                Navigator.pop(context);
                context.go('/discussion/my-posts');
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Blocked Users'),
              onTap: () {
                Navigator.pop(context);
                context.push('/discussion/blocked-users');
              },
            ),
            // Show only if user is verified
            if (isVerified)
              ListTile(
                leading: const Icon(Icons.flag, color: Colors.orange),
                title: const Text('View Reported Posts'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/discussion/reported-posts');
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsProvider);
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.whiteBackground,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsetsGeometry.directional(start: 16, end: 16, top: 8),
          child: Text("Discussion Board"),
        ),
        backgroundColor: c.whiteBackground,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: _handleCreatePost,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.add, color: c.mainColor),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _showProfileMenu(context),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: UserAvatar(
                iconRadius: iconSizeSmall,
              ),
            ),
          ),
        ],
      ),
      body: SafeContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Section
              Container(
                color: c.whiteBackground,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: c.textPrimary),
                  cursorColor: c.mainColor,
                  decoration: InputDecoration(
                    hintText: "Search discussions...",
                    hintStyle: TextStyle(color: c.textSecondary),
                    prefixIcon: Icon(
                      Icons.search,
                      color: c.textSecondary,
                    ),
                    filled: true,
                    fillColor: c.textBoxFill,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sort Button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => _SortBottomSheet(
                        currentSort: _currentSort,
                        onSortSelected: _setSortOption,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: c.mainColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: c.mainColor.withValues(alpha: 0.15)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 6,
                      children: [
                        Icon(
                          Icons.sort,
                          size: 18,
                          color: c.mainColor,
                        ),
                        Text(
                          "Sort",
                          style: TextStyle(color: c.mainColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Posts list
              Expanded(
                child: postsAsync.when(
                  data: (posts) {
                    // Sort posts based on selected option
                    // For 'newest', posts are already sorted by database, so just use as-is
                    List<DiscussionPost> sortedPosts;
                    
                    if (_currentSort.field == 'updated_at') {
                      // Database already returns sorted by updated_at descending
                      // So no need to sort again
                      sortedPosts = [...posts];
                    } else if (_currentSort.field == 'likes') {
                      sortedPosts = [...posts];
                      sortedPosts.sort((a, b) => b.likes.compareTo(a.likes));
                    } else if (_currentSort.field == 'comments') {
                      sortedPosts = [...posts];
                      sortedPosts.sort((a, b) => b.comments.compareTo(a.comments));
                    } else if (_currentSort.field == 'shares') {
                      sortedPosts = [...posts];
                      sortedPosts.sort((a, b) => b.shares.compareTo(a.shares));
                    } else {
                      sortedPosts = [...posts];
                    }
                    
                    final query = _searchController.text.trim().toLowerCase();
                    final displayPosts = query.isEmpty
                        ? sortedPosts
                        : sortedPosts.where((post) {
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
                              separatorBuilder: (_, _) =>
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
                  loading: () =>
                      const Center(child: LoadingCircleMainColor()),
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

// Sort Bottom Sheet
class _SortBottomSheet extends StatelessWidget {
  final SortOption currentSort;
  final Function(SortOption) onSortSelected;

  const _SortBottomSheet({
    required this.currentSort,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      SortOption.newest,
      SortOption.mostLiked,
      SortOption.mostCommented,
      SortOption.mostShared,
    ];

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                const Text(
                  "Sort by",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ...sortOptions.map((option) {
                  final isSelected = currentSort == option;

                  return ListTile(
                    title: Text(option.label),
                    trailing: isSelected
                        ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                        : null,
                    onTap: () {
                      onSortSelected(option);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

