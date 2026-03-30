// In discussion_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';

final discussionServicesProvider = Provider<DiscussionServices>((ref) {
  return DiscussionServices();
});

// Provider that fetches posts and can be refreshed
final postsProvider = FutureProvider<List<DiscussionPost>>((ref) {
  final service = ref.watch(discussionServicesProvider);
  return service.fetchPosts();
});