import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/post_like_manager.dart';
import 'package:sddp_dsh/backend/discussion/post_comment_manager.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/discussion/models/comments.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_post_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../helper/mock_objects.dart';

class MockDiscussionServices extends Mock implements DiscussionServices {}
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockUser extends Mock implements User {}

class FakeAppRegisteredProfileNotifier extends AppRegisteredProfileNotifier {
  @override
  Stream<AppRegisteredProfile> build() => Stream.value(testAppRegisteredProfile);
}

void main() {
  late MockDiscussionServices mockService;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;

  setUpAll(() {
    registerFallbackValue(testPost);
    registerFallbackValue(testComment);
  });

  setUp(() {
    mockService = MockDiscussionServices();
    mockSupabaseClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();

    when(() => mockService.supabase).thenReturn(mockSupabaseClient);
    when(() => mockSupabaseClient.auth).thenReturn(mockAuth);
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn('test-user-id');

    when(() => mockService.isLiked(any())).thenAnswer((_) async => false);
    when(() => mockService.fetchCommentsWithAvatars(any()))
        .thenAnswer((_) async => []);
    when(() => mockService.fetchComments(any())).thenAnswer((_) async => []);

    PostLikeManager().initialize(mockService);
    PostCommentManager().initialize(mockService);
  });

  Future<void> pumpPage(WidgetTester tester, DiscussionPost post) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          discussionServicesProvider.overrideWithValue(mockService),
          supabaseServiceProvider.overrideWithValue(mockSupabaseClient),
          appRegisteredProfileProvider
              .overrideWith(() => FakeAppRegisteredProfileNotifier()),
        ],
        child: MaterialApp(
          theme: ThemeData.light().copyWith(
            extensions: <ThemeExtension<dynamic>>[lightAppColors],
          ),
          home: DiscussionPostPage(post: post),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('DiscussionPostPage UI', () {
    testWidgets('builds without crashing', (tester) async {
      await pumpPage(tester, testPost);
      expect(find.byType(DiscussionPostPage), findsOneWidget);
    });

    testWidgets('displays Post title in appbar', (tester) async {
      await pumpPage(tester, testPost);
      expect(find.text('Post'), findsOneWidget);
    });

    testWidgets('displays post title in body', (tester) async {
      await pumpPage(tester, testPost);
      expect(find.text('Test Post'), findsOneWidget);
    });

    testWidgets('displays post content', (tester) async {
      await pumpPage(tester, testPost);
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('displays post author name', (tester) async {
      await pumpPage(tester, testPost);
      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('displays no comments message when empty', (tester) async {
      await pumpPage(tester, testPost);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('No comments yet'), findsOneWidget);
    });

    testWidgets('displays like icon', (tester) async {
      await pumpPage(tester, testPost);
      expect(find.byIcon(Icons.favorite_border), findsWidgets);
    });

    testWidgets('displays comment icon', (tester) async {
      await pumpPage(tester, testPost);
      expect(find.byIcon(Icons.chat_bubble_outline), findsWidgets);
    });

    testWidgets('displays share icon', (tester) async {
      await pumpPage(tester, testPost);
      expect(find.byIcon(Icons.repeat), findsWidgets);
    });

    testWidgets('displays add button in appbar', (tester) async {
      await pumpPage(tester, testPost);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('displays back button', (tester) async {
      await pumpPage(tester, testPost);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('displays more_vert menu button on post', (tester) async {
      await pumpPage(tester, testPost);
      await tester.pump(const Duration(seconds: 1));
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('displays verified icon for verified post author',
        (tester) async {
      await pumpPage(tester, testPost);
      await tester.pump(const Duration(seconds: 1));
      expect(find.byIcon(Icons.verified), findsOneWidget);
    });

    testWidgets('does not display verified icon for unverified author',
        (tester) async {
      final post = DiscussionPost(
        id: 'p2',
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
      await pumpPage(tester, post);
      await tester.pump(const Duration(seconds: 1));
      expect(find.byIcon(Icons.verified), findsNothing);
    });

    testWidgets('displays comments when loaded', (tester) async {
      final comment = DiscussionComment(
        id: 'c1',
        postId: testPost.id,
        userId: 'u1',
        authorName: 'Commenter',
        content: 'Great post!',
        isVerified: false,
        likes: 0,
        parentCommentId: null,
        createdAt: DateTime(2024),
      );

      when(() => mockService.fetchCommentsWithAvatars(any()))
          .thenAnswer((_) async => [comment]);

      await pumpPage(tester, testPost);
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Great post!'), findsOneWidget);
      expect(find.text('Commenter'), findsOneWidget);
    });
  });

  group('CommentWidget UI', () {
    Future<void> pumpComment(WidgetTester tester, DiscussionComment comment,
        {int depth = 0}) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            discussionServicesProvider.overrideWithValue(mockService),
            supabaseServiceProvider.overrideWithValue(mockSupabaseClient),
            appRegisteredProfileProvider
                .overrideWith(() => FakeAppRegisteredProfileNotifier()),
          ],
          child: MaterialApp(
            theme: ThemeData.light().copyWith(
              extensions: <ThemeExtension<dynamic>>[lightAppColors],
            ),
            home: Scaffold(
              body: CommentWidget(
                comment: comment,
                depth: depth,
                onReply: ({parentComment}) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('builds without crashing', (tester) async {
      await pumpComment(tester, testComment);
      expect(find.byType(CommentWidget), findsOneWidget);
    });

    testWidgets('displays comment content', (tester) async {
      await pumpComment(tester, testComment);
      expect(find.text('Test Comment'), findsOneWidget);
    });

    testWidgets('displays comment author', (tester) async {
      await pumpComment(tester, testComment);
      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('displays like icon on comment', (tester) async {
      await pumpComment(tester, testComment);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('displays reply icon at depth 0', (tester) async {
      await pumpComment(tester, testComment, depth: 0);
      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
    });

    testWidgets('does not display reply icon at depth > 0', (tester) async {
      await pumpComment(tester, testComment, depth: 1);
      expect(find.byIcon(Icons.chat_bubble_outline), findsNothing);
    });

    testWidgets('displays verified icon for verified commenter', (tester) async {
      final verifiedComment = DiscussionComment(
        id: 'c1',
        postId: 'p1',
        userId: 'u1',
        authorName: 'Verified User',
        content: 'Verified comment',
        isVerified: true,
        likes: 0,
        parentCommentId: null,
        createdAt: DateTime(2024),
      );
      await pumpComment(tester, verifiedComment);
      expect(find.byIcon(Icons.verified), findsOneWidget);
    });

    testWidgets('displays liked heart when comment is liked', (tester) async {
      final likedComment = DiscussionComment(
        id: 'c1',
        postId: 'p1',
        userId: 'u1',
        authorName: 'User',
        content: 'Liked comment',
        isVerified: false,
        likes: 3,
        parentCommentId: null,
        createdAt: DateTime(2024),
        isLiked: true,
      );
      await pumpComment(tester, likedComment);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('displays like count', (tester) async {
      final commentWithLikes = DiscussionComment(
        id: 'c1',
        postId: 'p1',
        userId: 'u1',
        authorName: 'User',
        content: 'Comment',
        isVerified: false,
        likes: 7,
        parentCommentId: null,
        createdAt: DateTime(2024),
      );
      await pumpComment(tester, commentWithLikes);
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('displays nested reply', (tester) async {
      final reply = DiscussionComment(
        id: 'r1',
        postId: 'p1',
        userId: 'u2',
        authorName: 'Replier',
        content: 'This is a reply',
        isVerified: false,
        likes: 0,
        parentCommentId: 'c1',
        createdAt: DateTime(2024),
      );
      final parent = DiscussionComment(
        id: 'c1',
        postId: 'p1',
        userId: 'u1',
        authorName: 'Parent',
        content: 'Parent comment',
        isVerified: false,
        likes: 0,
        parentCommentId: null,
        createdAt: DateTime(2024),
        replies: [reply],
      );
      await pumpComment(tester, parent);
      expect(find.text('This is a reply'), findsOneWidget);
      expect(find.text('Replier'), findsOneWidget);
    });
  });
}