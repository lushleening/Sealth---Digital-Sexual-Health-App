import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/avatar_helper.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart'; 

class ReportedPostsPage extends ConsumerStatefulWidget {
  const ReportedPostsPage({super.key});

  @override
  ConsumerState<ReportedPostsPage> createState() => _ReportedPostsPageState();
}

class _ReportedPostsPageState extends ConsumerState<ReportedPostsPage> {
  late final DiscussionServices _service;
  List<Map<String, dynamic>> _reportedPosts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final supabase = ref.read(supabaseServiceProvider);
    _service = DiscussionServices(supabase: supabase);
    _loadReportedPosts();
  }

  Future<void> _loadReportedPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final reportedPosts = await _service.getReportedPosts();
      
      // Group reports by post_id to get count
      final Map<String, List<Map<String, dynamic>>> groupedReports = {};
      for (final report in reportedPosts) {
        final postId = report['post_id'];
        if (!groupedReports.containsKey(postId)) {
          groupedReports[postId] = [];
        }
        groupedReports[postId]!.add(report);
      }
      
      // Create a list of unique posts with their reports
      final List<Map<String, dynamic>> uniquePosts = [];
      for (final entry in groupedReports.entries) {
        final reports = entry.value;
        final firstReport = reports.first;
        final postData = firstReport['posts'] as Map<String, dynamic>;
        
        // Get the author profile from inside the posts data
        final postAuthorProfile = postData['profiles'] as Map<String, dynamic>?;
        
        uniquePosts.add({
          'post_id': entry.key,
          'post': {
            ...postData,
            'author_avatar_url': postAuthorProfile?['avatar_url'],
            'author_username': postAuthorProfile?['username'] ?? postData['author_name'],
            'author_verified': postAuthorProfile?['verified'] ?? false,
          },
          'report_count': reports.length,
          'reports': reports.map((r) {
            return {
              ...r,
              'reporter_profile': r['reported_by_profile'],
            };
          }).toList(),
        });
      }
      
      if (mounted) {
        setState(() {
          _reportedPosts = uniquePosts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load reported posts: $e';
          _isLoading = false;
        });
      }
    }
  }

  // ✅ ADD THIS METHOD
  void _goBack() {
    ref.invalidate(postsProvider);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.whiteBackground,
      appBar: AppBar(
        title: const Text("Reported Posts"),
        backgroundColor: c.mainColor,
        foregroundColor: c.textWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack, // ✅ CHANGED THIS
        ),
      ),
      body: _isLoading
          ? const Center(child: LoadingCircleMainColor())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: c.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadReportedPosts,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _reportedPosts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.flag,
                            size: 64,
                            color: c.textSecondary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No reported posts',
                            style: TextStyle(
                              fontSize: 18,
                              color: c.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Posts that users report will appear here',
                            style: TextStyle(
                              fontSize: 14,
                              color: c.textSecondary.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadReportedPosts,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: _reportedPosts.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = _reportedPosts[index];
                          final post = item['post'] as Map<String, dynamic>;
                          final reportCount = item['report_count'];
                          final reports = item['reports'] as List<Map<String, dynamic>>;
                          
                          return _ReportedPostTile(
                            postId: item['post_id'],
                            post: post,
                            reportCount: reportCount,
                            reports: reports,
                            onRefresh: _loadReportedPosts,
                          );
                        },
                      ),
                    ),
    );
  }
}

class _ReportedPostTile extends StatelessWidget {
  final String postId;
  final Map<String, dynamic> post;
  final int reportCount;
  final List<Map<String, dynamic>> reports;
  final VoidCallback onRefresh;

  const _ReportedPostTile({
    required this.postId,
    required this.post,
    required this.reportCount,
    required this.reports,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    
    return Card(
      color: c.whiteBackground,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: c.buttonBorder),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportedPostDetailPage(
                postId: postId,
                post: post,
                reportCount: reportCount,
                reports: reports,
                onRefresh: onRefresh,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reported count badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Reported $reportCount time${reportCount > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Post header - using author avatar from profile
              Row(
                children: [
                  buildAvatar(
                    context, 
                    post['author_avatar_url'], 
                    post['author_username'] ?? post['author_name'] ?? 'Unknown User', 
                    radius: 20
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              post['author_username'] ?? post['author_name'] ?? 'Unknown User',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (post['author_verified'] == true)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.verified,
                                  size: 14,
                                  color: c.mainColor,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          post['title'] ?? 'No title',
                          style: const TextStyle(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Post content preview
              Text(
                post['content'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: c.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              
              // Report reasons preview
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: c.buttonBorder.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report reasons:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: c.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: reports.map((report) {
                        final reason = report['reason'] as String? ?? 'Unknown';
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            reason,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.red.shade700,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              
              // Tap to view details indicator
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Tap to view details',
                    style: TextStyle(
                      fontSize: 11,
                      color: c.mainColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 16, color: c.mainColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============ DETAIL PAGE ============

class ReportedPostDetailPage extends ConsumerStatefulWidget {
  final String postId;
  final Map<String, dynamic> post;
  final int reportCount;
  final List<Map<String, dynamic>> reports;
  final VoidCallback onRefresh;

  const ReportedPostDetailPage({
    super.key,
    required this.postId,
    required this.post,
    required this.reportCount,
    required this.reports,
    required this.onRefresh,
  });

  @override
  ConsumerState<ReportedPostDetailPage> createState() => _ReportedPostDetailPageState();
}

class _ReportedPostDetailPageState extends ConsumerState<ReportedPostDetailPage> {
  late final DiscussionServices _service;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    final supabase = ref.read(supabaseServiceProvider);
    _service = DiscussionServices(supabase: supabase);
  }

  Future<void> _deletePost() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Post'),
        content: const Text('Are you sure you want to permanently remove this post? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: context.colors.mainColor),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() {
        _isDeleting = true;
      });
      
      try {
        await _service.deleteReportedPost(widget.postId);
        widget.onRefresh();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post has been removed')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to remove post: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isDeleting = false;
          });
        }
      }
    }
  }

  Future<void> _dismissReport(String reportId) async {
    try {
      await _service.dismissReport(reportId);
      widget.onRefresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report dismissed')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to dismiss report: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final post = widget.post;

    return Scaffold(
      backgroundColor: c.whiteBackground,
      appBar: AppBar(
        title: const Text("Reported Post"),
        backgroundColor: c.mainColor,
        foregroundColor: c.textWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isDeleting
          ? const Center(child: LoadingCircleMainColor())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reported count badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Reported ${widget.reportCount} time${widget.reportCount > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Post header with author avatar from profile
                  Row(
                    children: [
                      buildAvatar(
                        context, 
                        post['author_avatar_url'], 
                        post['author_username'] ?? post['author_name'] ?? 'Unknown User', 
                        radius: 24
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  post['author_username'] ?? post['author_name'] ?? 'Unknown User',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (post['author_verified'] == true)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(
                                      Icons.verified,
                                      size: 16,
                                      color: c.mainColor,
                                    ),
                                  ),
                              ],
                            ),
                            Text(
                              post['title'] ?? 'No title',
                              style: TextStyle(
                                fontSize: 14,
                                color: c.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Full post content
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: c.whiteBackground,
                      border: Border.all(color: c.buttonBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      post['content'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Report reasons section
                  Text(
                    'Report Reasons',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...widget.reports.asMap().entries.map((entry) {
                    final index = entry.key;
                    final report = entry.value;
                    final reporter = report['reporter_profile'] as Map<String, dynamic>?;
                    final reason = report['reason'] as String? ?? 'Unknown';
                    final reportedAt = report['created_at'] != null
                        ? DateTime.parse(report['created_at']).toString().substring(0, 16)
                        : 'Unknown date';
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: c.buttonBorder.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Report #${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => _dismissReport(report['id']),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(60, 30),
                                ),
                                child: const Text('Dismiss'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Reason: $reason',
                            style: TextStyle(
                              fontSize: 13,
                              color: c.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Reported by: ${reporter?['username'] ?? 'Unknown user'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: c.textSecondary,
                            ),
                          ),
                          Text(
                            'Date: $reportedAt',
                            style: TextStyle(
                              fontSize: 12,
                              color: c.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 30),
                  
                  // Remove Post button at the bottom
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _deletePost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Remove Post',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}