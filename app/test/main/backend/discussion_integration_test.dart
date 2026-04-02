import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/discussion/models/comments.dart';

void main() {
  group('Discussion Models Tests', () {
    test('DiscussionPost.fromMap creates post with all fields', () {
      // Arrange
      final mockData = {
        'id': 'post-1',
        'user_id': 'user-1',
        'author_name': 'Test User',
        'avatar_url': 'https://example.com/avatar.jpg',
        'title': 'Test Post',
        'content': 'Test Content',
        'likes': 10,
        'shares': 5,
        'is_verified': true,
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
        'comments': [
          {'count': 3},
        ],
      };

      // Act
      final post = DiscussionPost.fromMap(mockData);

      // Assert
      expect(post.id, 'post-1');
      expect(post.userId, 'user-1');
      expect(post.authorName, 'Test User');
      expect(post.avatarUrl, 'https://example.com/avatar.jpg');
      expect(post.title, 'Test Post');
      expect(post.content, 'Test Content');
      expect(post.likes, 10);
      expect(post.shares, 5);
      expect(post.isVerified, true);
      expect(post.comments, 3);
    });

    test('DiscussionPost.fromMap handles null avatar', () {
      // Arrange
      final mockData = {
        'id': 'post-2',
        'user_id': 'user-2',
        'author_name': 'Anonymous',
        'title': 'Anonymous Post',
        'content': 'Content',
        'likes': 0,
        'shares': 0,
        'is_verified': false,
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
        'comments': [
          {'count': 0},
        ],
      };

      // Act
      final post = DiscussionPost.fromMap(mockData);

      // Assert
      expect(post.avatarUrl, null);
      expect(post.authorName, 'Anonymous');
    });

    test('DiscussionPost copyWith updates fields correctly', () {
      // Arrange
      final original = DiscussionPost(
        id: 'post-1',
        userId: 'user-1',
        authorName: 'Test User',
        title: 'Original Title',
        content: 'Original Content',
        likes: 5,
        shares: 2,
        isVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        comments: 1,
      );

      // Act
      final updated = original.copyWith(likes: 10, comments: 5);

      // Assert
      expect(updated.likes, 10);
      expect(updated.comments, 5);
      expect(updated.title, 'Original Title'); // Unchanged
    });

    test('DiscussionComment.fromMap creates comment with all fields', () {
      // Arrange
      final mockData = {
        'id': 'comment-1',
        'post_id': 'post-1',
        'user_id': 'user-1',
        'author_name': 'Test User',
        'avatar_url': 'https://example.com/avatar.jpg',
        'content': 'Test comment',
        'is_verified': true,
        'likes': 3,
        'parent_comment_id': null,
        'created_at': '2024-01-01T00:00:00Z',
        'is_liked': true,
        'reply_count': 2,
      };

      // Act
      final comment = DiscussionComment.fromMap(mockData);

      // Assert
      expect(comment.id, 'comment-1');
      expect(comment.authorName, 'Test User');
      expect(comment.avatarUrl, 'https://example.com/avatar.jpg');
      expect(comment.content, 'Test comment');
      expect(comment.isLiked, true);
      expect(comment.replyCount, 2);
    });

    test('buildCommentTree creates proper nested structure', () {
      // Arrange
      final now = DateTime.now();
      final comments = [
        DiscussionComment(
          id: '1',
          postId: 'post-1',
          userId: 'user-1',
          authorName: 'User 1',
          content: 'Root comment',
          isVerified: false,
          likes: 0,
          parentCommentId: null,
          createdAt: now,
          isLiked: false,
          replyCount: 0,
        ),
        DiscussionComment(
          id: '2',
          postId: 'post-1',
          userId: 'user-2',
          authorName: 'User 2',
          content: 'Reply to root',
          isVerified: false,
          likes: 0,
          parentCommentId: '1',
          createdAt: now,
          isLiked: false,
          replyCount: 0,
        ),
        DiscussionComment(
          id: '3',
          postId: 'post-1',
          userId: 'user-3',
          authorName: 'User 3',
          content: 'Another root',
          isVerified: false,
          likes: 0,
          parentCommentId: null,
          createdAt: now,
          isLiked: false,
          replyCount: 0,
        ),
      ];

      // Act
      final tree = buildCommentTree(comments);

      // Assert
      expect(tree.length, 2);
      expect(tree[0].id, '1');
      expect(tree[0].replies.length, 1);
      expect(tree[0].replies[0].id, '2');
      expect(tree[1].id, '3');
      expect(tree[1].replies.length, 0);
    });

    test('buildCommentTree handles empty list', () {
      // Arrange
      final comments = <DiscussionComment>[];

      // Act
      final tree = buildCommentTree(comments);

      // Assert
      expect(tree.isEmpty, true);
    });

    test('buildCommentTree handles orphan replies (parent not found)', () {
      // Arrange
      final now = DateTime.now();
      final comments = [
        DiscussionComment(
          id: '2',
          postId: 'post-1',
          userId: 'user-2',
          authorName: 'User 2',
          content: 'Orphan reply',
          isVerified: false,
          likes: 0,
          parentCommentId: '999', // Non-existent parent
          createdAt: now,
          isLiked: false,
          replyCount: 0,
        ),
      ];

      // Act
      final tree = buildCommentTree(comments);

      // Assert
      expect(tree.isEmpty, true); // Orphan becomes root or is ignored
    });
  });

  group('PostLikeInfo Tests', () {
    test('PostLikeInfo copyWith updates fields', () {
      // This would test your PostLikeInfo model
      // Add if you have a separate file
    });
  });
}
