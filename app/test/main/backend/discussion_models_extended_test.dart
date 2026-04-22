import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/discussion/models/comments.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';

void main() {
  group('DiscussionComment model', () {
    final baseComment = DiscussionComment(
      id: 'c1',
      postId: 'p1',
      userId: 'u1',
      authorName: 'Alice',
      content: 'Hello',
      isVerified: false,
      likes: 2,
      parentCommentId: null,
      createdAt: DateTime(2024, 1, 1),
    );

    test('default values are correct', () {
      expect(baseComment.isLiked, false);
      expect(baseComment.replyCount, 0);
      expect(baseComment.replies, isEmpty);
      expect(baseComment.avatarUrl, isNull);
    });

    test('fromMap uses default values for missing optional fields', () {
      final comment = DiscussionComment.fromMap({
        'id': 'c2',
        'post_id': 'p1',
        'user_id': 'u1',
        'content': 'Hi',
        'is_verified': false,
        'likes': 0,
        'parent_comment_id': null,
        'created_at': '2024-01-01T00:00:00Z',
      });
      expect(comment.authorName, 'Unknown');
      expect(comment.avatarUrl, isNull);
      expect(comment.isLiked, false);
      expect(comment.replyCount, 0);
    });

    test('fromMap parses all fields correctly', () {
      final comment = DiscussionComment.fromMap({
        'id': 'c3',
        'post_id': 'p2',
        'user_id': 'u2',
        'author_name': 'Bob',
        'avatar_url': 'https://example.com/bob.jpg',
        'content': 'Test content',
        'is_verified': true,
        'likes': 5,
        'parent_comment_id': 'c1',
        'created_at': '2024-06-01T12:00:00Z',
        'is_liked': true,
        'reply_count': 3,
      });
      expect(comment.authorName, 'Bob');
      expect(comment.avatarUrl, 'https://example.com/bob.jpg');
      expect(comment.isVerified, true);
      expect(comment.likes, 5);
      expect(comment.parentCommentId, 'c1');
      expect(comment.isLiked, true);
      expect(comment.replyCount, 3);
    });

    test('copyWith updates likes and isLiked', () {
      final updated = baseComment.copyWith(likes: 10, isLiked: true);
      expect(updated.likes, 10);
      expect(updated.isLiked, true);
      expect(updated.authorName, 'Alice'); // unchanged
      expect(updated.content, 'Hello');    // unchanged
    });

    test('copyWith updates replyCount', () {
      final updated = baseComment.copyWith(replyCount: 5);
      expect(updated.replyCount, 5);
    });

    test('copyWith updates avatarUrl', () {
      final updated = baseComment.copyWith(avatarUrl: 'https://new.com/avatar.jpg');
      expect(updated.avatarUrl, 'https://new.com/avatar.jpg');
    });

    test('copyWith updates replies', () {
      final reply = baseComment.copyWith(replies: [baseComment]);
      expect(reply.replies.length, 1);
    });

    test('copyWith with no arguments preserves all fields', () {
      final copy = baseComment.copyWith();
      expect(copy.id, baseComment.id);
      expect(copy.likes, baseComment.likes);
      expect(copy.isLiked, baseComment.isLiked);
    });
  });

  group('DiscussionPost model', () {
    test('fromMap with empty comments list gives 0 count', () {
      final post = DiscussionPost.fromMap({
        'id': 'p1',
        'user_id': 'u1',
        'author_name': 'User',
        'title': 'Title',
        'content': 'Content',
        'likes': 0,
        'shares': 0,
        'is_verified': false,
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
        'comments': [],
      });
      expect(post.comments, 0);
    });

    test('fromMap with null comments gives 0 count', () {
      final post = DiscussionPost.fromMap({
        'id': 'p1',
        'user_id': 'u1',
        'author_name': 'User',
        'title': 'Title',
        'content': 'Content',
        'likes': 0,
        'shares': 0,
        'is_verified': false,
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
        'comments': null,
      });
      expect(post.comments, 0);
    });

    test('fromMap uses default author name when null', () {
      final post = DiscussionPost.fromMap({
        'id': 'p1',
        'user_id': 'u1',
        'title': 'Title',
        'content': 'Content',
        'likes': 0,
        'shares': 0,
        'is_verified': false,
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
      });
      expect(post.authorName, 'Unknown User');
    });

    test('fromMap uses empty string for null title and content', () {
      final post = DiscussionPost.fromMap({
        'id': 'p1',
        'user_id': 'u1',
        'likes': 0,
        'shares': 0,
        'is_verified': false,
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
      });
      expect(post.title, '');
      expect(post.content, '');
    });

    test('copyWith updates shares', () {
      final post = DiscussionPost(
        id: 'p1',
        userId: 'u1',
        authorName: 'User',
        title: 'Title',
        content: 'Content',
        likes: 0,
        shares: 0,
        isVerified: false,
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );
      final updated = post.copyWith(shares: 10);
      expect(updated.shares, 10);
      expect(updated.title, 'Title'); // unchanged
    });

    test('copyWith updates avatarUrl', () {
      final post = DiscussionPost(
        id: 'p1',
        userId: 'u1',
        authorName: 'User',
        title: 'Title',
        content: 'Content',
        likes: 0,
        shares: 0,
        isVerified: false,
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );
      final updated = post.copyWith(avatarUrl: 'https://example.com/avatar.jpg');
      expect(updated.avatarUrl, 'https://example.com/avatar.jpg');
    });

    test('copyWith with no args preserves all fields', () {
      final post = DiscussionPost(
        id: 'p1',
        userId: 'u1',
        authorName: 'User',
        title: 'Title',
        content: 'Content',
        likes: 5,
        shares: 3,
        isVerified: true,
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
        comments: 2,
      );
      final copy = post.copyWith();
      expect(copy.id, post.id);
      expect(copy.likes, post.likes);
      expect(copy.shares, post.shares);
      expect(copy.comments, post.comments);
    });
  });

  group('buildCommentTree', () {
    test('handles multiple replies to same parent', () {
      final now = DateTime.now();
      final comments = [
        DiscussionComment(
          id: '1', postId: 'p1', userId: 'u1', authorName: 'Root',
          content: 'Root', isVerified: false, likes: 0,
          parentCommentId: null, createdAt: now,
        ),
        DiscussionComment(
          id: '2', postId: 'p1', userId: 'u2', authorName: 'Reply1',
          content: 'Reply1', isVerified: false, likes: 0,
          parentCommentId: '1', createdAt: now,
        ),
        DiscussionComment(
          id: '3', postId: 'p1', userId: 'u3', authorName: 'Reply2',
          content: 'Reply2', isVerified: false, likes: 0,
          parentCommentId: '1', createdAt: now,
        ),
      ];
      final tree = buildCommentTree(comments);
      expect(tree.length, 1);
      expect(tree[0].replies.length, 2);
    });

    test('all root comments with no replies', () {
      final now = DateTime.now();
      final comments = List.generate(3, (i) => DiscussionComment(
        id: '$i', postId: 'p1', userId: 'u$i', authorName: 'User$i',
        content: 'Content$i', isVerified: false, likes: 0,
        parentCommentId: null, createdAt: now,
      ));
      final tree = buildCommentTree(comments);
      expect(tree.length, 3);
      for (final node in tree) {
        expect(node.replies, isEmpty);
      }
    });
  });
}