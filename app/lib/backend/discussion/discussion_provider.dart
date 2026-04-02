import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';

final discussionServicesProvider = Provider<DiscussionServices>((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  return DiscussionServices(supabase: supabase);
});

final postsProvider = FutureProvider<List<DiscussionPost>>((ref) {
  final service = ref.watch(discussionServicesProvider);
  return service.fetchPostsWithAvatars();
});