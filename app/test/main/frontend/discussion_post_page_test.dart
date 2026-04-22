import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/discussion/models/comments.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_post_page.dart';
import '../../helper/mock_objects.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';

void main() {
  group('DiscussionPostPage', () {
    testWidgets('widget can be instantiated', (tester) async {
      expect(() => DiscussionPostPage(post: testPost), returnsNormally);
    });
  });

  group('CommentWidget', () {
    testWidgets('widget can be instantiated', (tester) async {
      expect(
        () => CommentWidget(
          comment: testComment,
          depth: 0,
          onReply: ({parentComment}) {},
        ),
        returnsNormally,
      );
    });
  });

  group('buildCommentTree', () {
    test('returns empty list for empty input', () {
      final tree = buildCommentTree([]);
      expect(tree, isEmpty);
    });

    test('creates nested structure', () {
      final now = DateTime.now();
      final comments = [
        DiscussionComment(
          id: '1',
          postId: 'post-1',
          userId: 'user-1',
          authorName: 'Root',
          content: 'Root',
          isVerified: false,
          likes: 0,
          parentCommentId: null,
          createdAt: now,
        ),
        DiscussionComment(
          id: '2',
          postId: 'post-1',
          userId: 'user-2',
          authorName: 'Reply',
          content: 'Reply',
          isVerified: false,
          likes: 0,
          parentCommentId: '1',
          createdAt: now,
        ),
      ];
      final tree = buildCommentTree(comments);
      expect(tree.length, 1);
      expect(tree[0].replies.length, 1);
    });
  });

  group('DiscussionPost Model', () {
    test('fromMap creates correct post', () {
      final map = {
        'id': 'test-id',
        'user_id': 'user-1',
        'author_name': 'Test Author',
        'title': 'Test Title',
        'content': 'Test Content',
        'likes': 10,
        'shares': 5,
        'is_verified': true,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'comments': [{'count': 3}],
      };
      final post = DiscussionPost.fromMap(map);
      expect(post.id, 'test-id');
      expect(post.likes, 10);
      expect(post.comments, 3);
    });
  });
}