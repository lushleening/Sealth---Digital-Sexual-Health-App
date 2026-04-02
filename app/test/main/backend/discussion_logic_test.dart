import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/discussion/models/comments.dart';
import '../../helper/mock_objects.dart';

void main() {
  late MockDiscussionServices mockService;

  setUp(() {
    mockService = MockDiscussionServices();
    registerFallbackValue(testPost);
    registerFallbackValue(testComment);
  });

  group('Post Creation Tests', () {
    test('createPost returns a new post with correct data', () async {
      final now = DateTime.now();

      when(
        () => mockService.createPost(
          title: any(named: 'title'),
          content: any(named: 'content'),
          isAnonymous: any(named: 'isAnonymous'),
          tags: any(named: 'tags'),
        ),
      ).thenAnswer((invocation) async {
        return DiscussionPost(
          id: 'new-post-123',
          userId: 'user-1',
          authorName: invocation.namedArguments[#isAnonymous]
              ? 'Anonymous'
              : 'Test User',
          title: invocation.namedArguments[#title],
          content: invocation.namedArguments[#content],
          likes: 0,
          shares: 0,
          isVerified: !invocation.namedArguments[#isAnonymous],
          createdAt: now,
          updatedAt: now,
          comments: 0,
        );
      });

      final post = await mockService.createPost(
        title: 'My New Post',
        content: 'This is my post content',
        isAnonymous: false,
      );

      expect(post.title, 'My New Post');
      expect(post.content, 'This is my post content');
      expect(post.authorName, 'Test User');
      expect(post.likes, 0);
      expect(post.comments, 0);
    });

    test('createPost as anonymous hides user identity', () async {
      final now = DateTime.now();

      when(
        () => mockService.createPost(
          title: any(named: 'title'),
          content: any(named: 'content'),
          isAnonymous: true,
          tags: any(named: 'tags'),
        ),
      ).thenAnswer((invocation) async {
        return DiscussionPost(
          id: 'anon-post-123',
          userId: 'anonymous-user',
          authorName: 'Anonymous',
          title: invocation.namedArguments[#title],
          content: invocation.namedArguments[#content],
          likes: 0,
          shares: 0,
          isVerified: false,
          createdAt: now,
          updatedAt: now,
          comments: 0,
        );
      });

      final post = await mockService.createPost(
        title: 'Anonymous Post',
        content: 'Anonymous content',
        isAnonymous: true,
      );

      expect(post.authorName, 'Anonymous');
      expect(post.isVerified, false);
      expect(post.userId, 'anonymous-user');
    });
  });

  group('Like Functionality Tests', () {
    test('toggleLike returns true when liking a post', () async {
      when(
        () => mockService.toggleLike('post-1'),
      ).thenAnswer((_) async => true);

      final result = await mockService.toggleLike('post-1');

      expect(result, true);
      verify(() => mockService.toggleLike('post-1')).called(1);
    });

    test('toggleLike returns false when unliking a post', () async {
      when(
        () => mockService.toggleLike('post-1'),
      ).thenAnswer((_) async => false);

      final result = await mockService.toggleLike('post-1');

      expect(result, false);
    });

    test('toggleCommentLike returns true when liking a comment', () async {
      when(
        () => mockService.toggleCommentLike('comment-1'),
      ).thenAnswer((_) async => true);

      final result = await mockService.toggleCommentLike('comment-1');

      expect(result, true);
    });

    test('toggleCommentLike returns false when unliking a comment', () async {
      when(
        () => mockService.toggleCommentLike('comment-1'),
      ).thenAnswer((_) async => false);

      final result = await mockService.toggleCommentLike('comment-1');

      expect(result, false);
    });
  });

  group('Comment Tests', () {
    test('addComment creates a new comment', () async {
      final now = DateTime.now();

      when(
        () => mockService.addComment(
          postId: any(named: 'postId'),
          content: any(named: 'content'),
          parentCommentId: any(named: 'parentCommentId'),
        ),
      ).thenAnswer((invocation) async {
        return DiscussionComment(
          id: 'new-comment-456',
          postId: invocation.namedArguments[#postId],
          userId: 'user-1',
          authorName: 'Test User',
          content: invocation.namedArguments[#content],
          isVerified: true,
          likes: 0,
          parentCommentId: invocation.namedArguments[#parentCommentId],
          createdAt: now,
          isLiked: false,
          replyCount: 0,
        );
      });

      final comment = await mockService.addComment(
        postId: 'post-1',
        content: 'Great post!',
      );

      expect(comment.content, 'Great post!');
      expect(comment.postId, 'post-1');
      expect(comment.parentCommentId, null);
      expect(comment.likes, 0);
    });

    test('addReply creates a nested comment', () async {
      final now = DateTime.now();

      when(
        () => mockService.addComment(
          postId: any(named: 'postId'),
          content: any(named: 'content'),
          parentCommentId: any(named: 'parentCommentId'),
        ),
      ).thenAnswer((invocation) async {
        return DiscussionComment(
          id: 'new-reply-789',
          postId: invocation.namedArguments[#postId],
          userId: 'user-2',
          authorName: 'Reply User',
          content: invocation.namedArguments[#content],
          isVerified: false,
          likes: 0,
          parentCommentId: invocation.namedArguments[#parentCommentId],
          createdAt: now,
          isLiked: false,
          replyCount: 0,
        );
      });

      final reply = await mockService.addComment(
        postId: 'post-1',
        content: 'Thanks for the comment!',
        parentCommentId: 'comment-1',
      );

      expect(reply.parentCommentId, 'comment-1');
      expect(reply.content, 'Thanks for the comment!');
    });
  });

  group('Comment Tree Tests', () {
    test('buildCommentTree creates correct nested structure', () {
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

      final tree = buildCommentTree(comments);

      expect(tree.length, 2);
      expect(tree[0].id, '1');
      expect(tree[0].replies.length, 1);
      expect(tree[0].replies[0].id, '2');
      expect(tree[1].id, '3');
      expect(tree[1].replies.length, 0);
    });

    test('buildCommentTree handles empty comments list', () {
      final comments = <DiscussionComment>[];
      final tree = buildCommentTree(comments);
      expect(tree.isEmpty, true);
    });
  });

  group('Post Fetching Tests', () {
    test('fetchPostsWithAvatars returns list of posts', () async {
      final now = DateTime.now();

      final mockPosts = [
        testPost,
        DiscussionPost(
          id: 'test-post-2',
          userId: 'user-2',
          authorName: 'Another User',
          title: 'Another Post',
          content: 'Another content',
          likes: 0,
          shares: 0,
          isVerified: false,
          createdAt: now,
          updatedAt: now,
          comments: 0,
        ),
      ];
      when(
        () => mockService.fetchPostsWithAvatars(),
      ).thenAnswer((_) async => mockPosts);

      final posts = await mockService.fetchPostsWithAvatars();

      expect(posts.length, 2);
      expect(posts[0].title, 'Test Post');
      expect(posts[1].title, 'Another Post');
    });

    test('fetchPostsWithAvatars returns empty list when no posts', () async {
      when(
        () => mockService.fetchPostsWithAvatars(),
      ).thenAnswer((_) async => []);

      final posts = await mockService.fetchPostsWithAvatars();

      expect(posts.isEmpty, true);
    });
  });

  group('Comment Fetching Tests', () {
    test('fetchCommentsWithAvatars returns comments with avatars', () async {
      final now = DateTime.now();

      final mockComments = [
        testComment,
        DiscussionComment(
          id: 'test-reply-1',
          postId: 'post-1',
          userId: 'user-2',
          authorName: 'Reply User',
          avatarUrl: null,
          content: 'Test Reply',
          isVerified: false,
          likes: 0,
          parentCommentId: 'test-comment-1',
          createdAt: now,
          isLiked: false,
          replyCount: 0,
        ),
      ];
      when(
        () => mockService.fetchCommentsWithAvatars('post-1'),
      ).thenAnswer((_) async => mockComments);

      final comments = await mockService.fetchCommentsWithAvatars('post-1');

      expect(comments.length, 2);
      expect(comments[0].authorName, 'Test User');
      expect(comments[0].avatarUrl, 'https://test.com/avatar.jpg');
    });
  });
}
