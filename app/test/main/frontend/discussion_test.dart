import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion.dart';
import 'package:sddp_dsh/frontend/pages/discussion/create_post_page.dart';
import 'package:sddp_dsh/frontend/pages/discussion/edit_post_page.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_post_tile.dart';
import 'package:sddp_dsh/frontend/pages/discussion/my_post_page.dart';
import 'package:sddp_dsh/frontend/pages/discussion/blocked_users_page.dart';
import 'package:sddp_dsh/frontend/pages/discussion/reported_posts_page.dart';
import '../../helper/mock_objects.dart';

void main() {
  group("Widget Instantiation Tests", () {
    testWidgets("DiscussionPage can be instantiated", (tester) async {
      expect(() => const DiscussionPage(), returnsNormally);
    });

    testWidgets("CreatePostPage can be instantiated", (tester) async {
      expect(() => const CreatePostPage(), returnsNormally);
    });

    testWidgets("EditPostPage can be instantiated", (tester) async {
      expect(() => EditPostPage(post: testPost), returnsNormally);
    });

    testWidgets("MyPostsPage can be instantiated", (tester) async {
      expect(() => const MyPostsPage(), returnsNormally);
    });

    testWidgets("BlockedUsersPage can be instantiated", (tester) async {
      expect(() => const BlockedUsersPage(), returnsNormally);
    });

    testWidgets("ReportedPostsPage can be instantiated", (tester) async {
      expect(() => const ReportedPostsPage(), returnsNormally);
    });

    testWidgets("DiscussionPostTile can be instantiated", (tester) async {
      expect(() => DiscussionPostTile(post: testPost), returnsNormally);
    });
  });

  group("DiscussionPage Type Tests", () {
    test("DiscussionPage has correct type", () {
      final page = const DiscussionPage();
      expect(page, isA<DiscussionPage>());
    });

    test("CreatePostPage has correct type", () {
      final page = const CreatePostPage();
      expect(page, isA<CreatePostPage>());
    });
  });

  group("SortOption Enum Tests", () {
    test("SortOption values are correct", () {
      expect(SortOption.values.length, 4);
      expect(SortOption.newest.label, 'Most Recently Updated');
      expect(SortOption.mostLiked.label, 'Most Liked');
      expect(SortOption.mostCommented.label, 'Most Commented');
      expect(SortOption.mostShared.label, 'Most Shared');
    });

    test("SortOption fields are correct", () {
      expect(SortOption.newest.field, 'updated_at');
      expect(SortOption.mostLiked.field, 'likes');
      expect(SortOption.mostCommented.field, 'comments');
      expect(SortOption.mostShared.field, 'shares');
    });
  });
}