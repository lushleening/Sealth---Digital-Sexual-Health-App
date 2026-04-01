// In discussion_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';

final discussionServicesProvider = Provider<DiscussionServices>((ref) {
  return DiscussionServices();
});

// Provider that fetches posts with avatars
final postsProvider = FutureProvider<List<DiscussionPost>>((ref) {
  final service = ref.watch(discussionServicesProvider);
  // CHANGE THIS LINE to use the new method
  return service.fetchPostsWithAvatars(); // 👈 WAS: service.fetchPosts()
});