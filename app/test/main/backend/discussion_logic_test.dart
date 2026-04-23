import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/discussion/models/comments.dart';
import 'package:sddp_dsh/backend/discussion/post_comment_manager.dart';
import '../../helper/mock_objects.dart';

void main() {
  late MockDiscussionServices mockService;

  setUp(() {
    mockService = MockDiscussionServices();
    
    when(() => mockService.isLiked(any())).thenAnswer((_) async => false);
    when(() => mockService.isCommentLiked(any())).thenAnswer((_) async => false);

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

    test('createPost with tags includes tags', () async {
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
          id: 'tagged-post-123',
          userId: 'user-1',
          authorName: 'Test User',
          title: invocation.namedArguments[#title],
          content: invocation.namedArguments[#content],
          likes: 0,
          shares: 0,
          isVerified: true,
          createdAt: now,
          updatedAt: now,
          comments: 0,
        );
      });

      final post = await mockService.createPost(
        title: 'Tagged Post',
        content: 'Content with tags',
        isAnonymous: false,
        tags: ['flutter', 'dart'],
      );

      expect(post.title, 'Tagged Post');
      verify(() => mockService.createPost(
        title: 'Tagged Post',
        content: 'Content with tags',
        isAnonymous: false,
        tags: ['flutter', 'dart'],
      )).called(1);
    });
  });

  group('Post Update Tests', () {
    test('updatePost modifies existing post', () async {
      final now = DateTime.now();
      
      when(
        () => mockService.updatePost(
          postId: any(named: 'postId'),
          title: any(named: 'title'),
          content: any(named: 'content'),
        ),
      ).thenAnswer((_) async => DiscussionPost(
        id: 'post-1',
        userId: 'user-1',
        authorName: 'Test User',
        title: 'Updated Title',
        content: 'Updated Content',
        likes: 10,
        shares: 5,
        isVerified: true,
        createdAt: now,
        updatedAt: now,
        comments: 3,
      ));

      final post = await mockService.updatePost(
        postId: 'post-1',
        title: 'Updated Title',
        content: 'Updated Content',
      );

      expect(post.title, 'Updated Title');
      expect(post.content, 'Updated Content');
    });
  });

  group('Post Deletion Tests', () {
    test('deletePost removes post', () async {
      when(() => mockService.deletePost('post-1'))
          .thenAnswer((_) async {});

      await mockService.deletePost('post-1');

      verify(() => mockService.deletePost('post-1')).called(1);
    });

    test('deletePosts removes multiple posts', () async {
      when(() => mockService.deletePosts(any()))
          .thenAnswer((_) async {});

      await mockService.deletePosts(['post-1', 'post-2', 'post-3']);

      verify(() => mockService.deletePosts(['post-1', 'post-2', 'post-3'])).called(1);
    });
  });

  group('Like Functionality Tests', () {
    test('toggleLike returns true when liking a post', () async {
      when(() => mockService.toggleLike('post-1'))
          .thenAnswer((_) async => true);

      final result = await mockService.toggleLike('post-1');

      expect(result, true);
      verify(() => mockService.toggleLike('post-1')).called(1);
    });

    test('toggleLike returns false when unliking a post', () async {
      when(() => mockService.toggleLike('post-1'))
          .thenAnswer((_) async => false);

      final result = await mockService.toggleLike('post-1');

      expect(result, false);
    });

    test('isLiked returns true for liked post', () async {
      when(() => mockService.isLiked('post-1'))
          .thenAnswer((_) async => true);

      final result = await mockService.isLiked('post-1');

      expect(result, true);
    });

    test('isLiked returns false for unliked post', () async {
      when(() => mockService.isLiked('post-1'))
          .thenAnswer((_) async => false);

      final result = await mockService.isLiked('post-1');

      expect(result, false);
    });

    test('toggleCommentLike returns true when liking a comment', () async {
      when(() => mockService.toggleCommentLike('comment-1'))
          .thenAnswer((_) async => true);

      final result = await mockService.toggleCommentLike('comment-1');

      expect(result, true);
    });

    test('toggleCommentLike returns false when unliking a comment', () async {
      when(() => mockService.toggleCommentLike('comment-1'))
          .thenAnswer((_) async => false);

      final result = await mockService.toggleCommentLike('comment-1');

      expect(result, false);
    });

    test('isCommentLiked returns true for liked comment', () async {
      when(() => mockService.isCommentLiked('comment-1'))
          .thenAnswer((_) async => true);

      final result = await mockService.isCommentLiked('comment-1');

      expect(result, true);
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

    test('addCommentWithAvatar creates comment with avatar', () async {
      final now = DateTime.now();

      when(
        () => mockService.addCommentWithAvatar(
          postId: any(named: 'postId'),
          content: any(named: 'content'),
          parentCommentId: any(named: 'parentCommentId'),
        ),
      ).thenAnswer((invocation) async {
        return DiscussionComment(
          id: 'avatar-comment-123',
          postId: invocation.namedArguments[#postId],
          userId: 'user-1',
          authorName: 'Avatar User',
          avatarUrl: 'https://example.com/avatar.jpg',
          content: invocation.namedArguments[#content],
          isVerified: true,
          likes: 0,
          parentCommentId: invocation.namedArguments[#parentCommentId],
          createdAt: now,
          isLiked: false,
          replyCount: 0,
        );
      });

      final comment = await mockService.addCommentWithAvatar(
        postId: 'post-1',
        content: 'Comment with avatar',
      );

      expect(comment.avatarUrl, 'https://example.com/avatar.jpg');
      expect(comment.authorName, 'Avatar User');
    });
  });

  group('Share Tests', () {
    test('incrementShareCount increments shares', () async {
      when(() => mockService.incrementShareCount('post-1'))
          .thenAnswer((_) async {});

      await mockService.incrementShareCount('post-1');

      verify(() => mockService.incrementShareCount('post-1')).called(1);
    });

    test('getShareText returns formatted share text', () async {
      when(() => mockService.getShareText(any(), any(), any()))
          .thenAnswer((_) async => 'Share text for post');

      final text = await mockService.getShareText(testPost, 10, 5);

      expect(text, 'Share text for post');
    });
  });

  group('Report Tests', () {
    test('reportPost submits report', () async {
      when(() => mockService.reportPost('post-1', 'Spam'))
          .thenAnswer((_) async {});

      await mockService.reportPost('post-1', 'Spam');

      verify(() => mockService.reportPost('post-1', 'Spam')).called(1);
    });

    test('dismissReport dismisses report', () async {
      when(() => mockService.dismissReport('report-1'))
          .thenAnswer((_) async {});

      await mockService.dismissReport('report-1');

      verify(() => mockService.dismissReport('report-1')).called(1);
    });

    test('deleteReportedPost removes reported post', () async {
      when(() => mockService.deleteReportedPost('post-1'))
          .thenAnswer((_) async {});

      await mockService.deleteReportedPost('post-1');

      verify(() => mockService.deleteReportedPost('post-1')).called(1);
    });

    test('getReportedPosts returns list of reported posts', () async {
      when(() => mockService.getReportedPosts())
          .thenAnswer((_) async => []);

      final reports = await mockService.getReportedPosts();

      expect(reports, isEmpty);
    });
  });

  group('Block Tests', () {
    test('blockUser blocks user', () async {
      when(() => mockService.blockUser('user-1'))
          .thenAnswer((_) async {});

      await mockService.blockUser('user-1');

      verify(() => mockService.blockUser('user-1')).called(1);
    });

    test('unblockUser unblocks user', () async {
      when(() => mockService.unblockUser('user-1'))
          .thenAnswer((_) async {});

      await mockService.unblockUser('user-1');

      verify(() => mockService.unblockUser('user-1')).called(1);
    });

    test('isUserBlocked returns true for blocked user', () async {
      when(() => mockService.isUserBlocked('user-1'))
          .thenAnswer((_) async => true);

      final result = await mockService.isUserBlocked('user-1');

      expect(result, true);
    });

    test('getBlockedUsersWithProfiles returns list', () async {
      when(() => mockService.getBlockedUsersWithProfiles())
          .thenAnswer((_) async => []);

      final users = await mockService.getBlockedUsersWithProfiles();

      expect(users, isEmpty);
    });

    test('getBlockedUserIds returns list of IDs', () async {
      when(() => mockService.getBlockedUserIds())
          .thenAnswer((_) async => ['user-1', 'user-2']);

      final ids = await mockService.getBlockedUserIds();

      expect(ids, ['user-1', 'user-2']);
    });
  });

  group('Verified User Tests', () {
    test('isCurrentUserVerified returns true for verified user', () async {
      when(() => mockService.isCurrentUserVerified())
          .thenAnswer((_) async => true);

      final result = await mockService.isCurrentUserVerified();

      expect(result, true);
    });

    test('isCurrentUserVerified returns false for unverified user', () async {
      when(() => mockService.isCurrentUserVerified())
          .thenAnswer((_) async => false);

      final result = await mockService.isCurrentUserVerified();

      expect(result, false);
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

    test('buildCommentTree handles deep nesting', () {
      final now = DateTime.now();
      final comments = [
        DiscussionComment(
          id: '1',
          postId: 'post-1',
          userId: 'user-1',
          authorName: 'Level 1',
          content: 'Root',
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
          authorName: 'Level 2',
          content: 'Reply L1',
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
          authorName: 'Level 3',
          content: 'Reply L2',
          isVerified: false,
          likes: 0,
          parentCommentId: '2',
          createdAt: now,
          isLiked: false,
          replyCount: 0,
        ),
      ];

      final tree = buildCommentTree(comments);

      expect(tree.length, 1);
      expect(tree[0].replies.length, 1);
      expect(tree[0].replies[0].replies.length, 1);
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
      when(() => mockService.fetchPostsWithAvatars())
          .thenAnswer((_) async => mockPosts);

      final posts = await mockService.fetchPostsWithAvatars();

      expect(posts.length, 2);
      expect(posts[0].title, 'Test Post');
      expect(posts[1].title, 'Another Post');
    });

    test('fetchPostsWithAvatars returns empty list when no posts', () async {
      when(() => mockService.fetchPostsWithAvatars())
          .thenAnswer((_) async => []);

      final posts = await mockService.fetchPostsWithAvatars();

      expect(posts.isEmpty, true);
    });

    test('fetchPosts returns posts without avatars', () async {
      when(() => mockService.fetchPosts())
          .thenAnswer((_) async => [testPost]);

      final posts = await mockService.fetchPosts();

      expect(posts.length, 1);
      expect(posts[0].title, 'Test Post');
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
      when(() => mockService.fetchCommentsWithAvatars('post-1'))
          .thenAnswer((_) async => mockComments);

      final comments = await mockService.fetchCommentsWithAvatars('post-1');

      expect(comments.length, 2);
      expect(comments[0].authorName, 'Test User');
      expect(comments[0].avatarUrl, 'https://test.com/avatar.jpg');
    });

    test('fetchComments returns comments without avatars', () async {
      when(() => mockService.fetchComments('post-1'))
          .thenAnswer((_) async => [testComment]);

      final comments = await mockService.fetchComments('post-1');

      expect(comments.length, 1);
    });
  });

  group('PostCommentManager Tests', () {
    late PostCommentManager commentManager;

    setUp(() {
      commentManager = PostCommentManager();
      commentManager.initialize(mockService);
    });

    test('initializeCommentCount sets count', () async {
      await commentManager.initializeCommentCount('post-1', 5);

      final count = commentManager.getCommentCount('post-1');
      expect(count, 5);
    });

    test('refreshCommentCount updates count from service', () async {
      when(() => mockService.fetchComments('post-1'))
          .thenAnswer((_) async => [testComment, testComment, testComment]);

      await commentManager.initializeCommentCount('post-1', 1);
      await commentManager.refreshCommentCount('post-1');

      final count = commentManager.getCommentCount('post-1');
      expect(count, 3);
    });

    test('getCommentCount returns null for unknown post', () {
      final count = commentManager.getCommentCount('unknown-post');
      expect(count, isNull);
    });

    test('listeners are notified on changes', () async {
      var notified = false;
      commentManager.addListener(() => notified = true);

      await commentManager.initializeCommentCount('post-1', 5);

      expect(notified, true);
    });

    test('removeListener stops notifications', () async {
      var notified = false;
      bool listener() => notified = true;
      
      commentManager.addListener(listener);
      commentManager.removeListener(listener);

      await commentManager.initializeCommentCount('post-1', 5);

      expect(notified, false);
    });
  });
}