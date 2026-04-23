import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/post_like_manager.dart';
import 'package:sddp_dsh/backend/discussion/post_comment_manager.dart';
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
    when(() => mockService.fetchPostsWithAvatars()).thenAnswer((_) async => []);

    PostLikeManager().initialize(mockService);
    PostCommentManager().initialize(mockService);
  });

  Future<void> pumpPage(WidgetTester tester) async {
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
          home: DiscussionPostPage(post: testPost),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

  group('DiscussionPostPage async paths', () {
    testWidgets('loads and displays comments', (tester) async {
      when(() => mockService.fetchCommentsWithAvatars(any()))
          .thenAnswer((_) async => [testComment]);

      await pumpPage(tester);
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Test Comment'), findsOneWidget);
    });

    testWidgets('shows no comments text when list is empty', (tester) async {
      await pumpPage(tester);
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('No comments yet'), findsOneWidget);
    });

    testWidgets('shows snackbar when guest taps like', (tester) async {
      when(() => mockAuth.currentUser).thenReturn(null);

      await pumpPage(tester);
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byIcon(Icons.favorite_border).first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Please log in to like posts'), findsOneWidget);
    });

    testWidgets('shows snackbar when guest taps comment button', (tester) async {
      when(() => mockAuth.currentUser).thenReturn(null);

      await pumpPage(tester);
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byIcon(Icons.chat_bubble_outline).first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Please log in to comment'), findsOneWidget);
    });

    testWidgets('shows snackbar when guest taps add post', (tester) async {
      when(() => mockAuth.currentUser).thenReturn(null);

      await pumpPage(tester);
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Please log in to create a post'), findsOneWidget);
    });

    testWidgets('shows snackbar when guest taps share', (tester) async {
      when(() => mockAuth.currentUser).thenReturn(null);

      await pumpPage(tester);
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byIcon(Icons.repeat).first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Please log in to share posts'), findsOneWidget);
    });

    testWidgets('shows post menu on more_vert tap', (tester) async {
      await pumpPage(tester);
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pump();
      // Use pump instead of pumpAndSettle to avoid timeout
      await tester.pump(const Duration(milliseconds: 500));

      // Should show report/block options for other user's post
      expect(find.text('Report Post'), findsOneWidget);
      expect(find.text('Block User'), findsOneWidget);
      
      // Close the bottom sheet
      await tester.tapAt(const Offset(10, 10));
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('shows edit option in menu for own post', (tester) async {
      // Make mockUser.id match the post userId
      when(() => mockUser.id).thenReturn('user-1'); // testPost.userId

      await pumpPage(tester);
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Edit Post'), findsOneWidget);
      
      // Close the bottom sheet
      await tester.tapAt(const Offset(10, 10));
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('comment like count is displayed', (tester) async {
      final comment = DiscussionComment(
        id: 'c1',
        postId: testPost.id,
        userId: 'u2',
        authorName: 'Commenter',
        content: 'A comment',
        isVerified: false,
        likes: 4,
        parentCommentId: null,
        createdAt: DateTime(2024),
      );

      when(() => mockService.fetchCommentsWithAvatars(any()))
          .thenAnswer((_) async => [comment]);

      await pumpPage(tester);
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('shows snackbar when guest taps comment like', (tester) async {
      when(() => mockAuth.currentUser).thenReturn(null);

      final comment = DiscussionComment(
        id: 'c1',
        postId: testPost.id,
        userId: 'u2',
        authorName: 'Commenter',
        content: 'A comment',
        isVerified: false,
        likes: 0,
        parentCommentId: null,
        createdAt: DateTime(2024),
      );

      when(() => mockService.fetchCommentsWithAvatars(any()))
          .thenAnswer((_) async => [comment]);

      await pumpPage(tester);
      await tester.pump(const Duration(seconds: 1));

      // Find the comment like icon (favorite_border)
      final likeIcons = find.byIcon(Icons.favorite_border);
      // There should be at least one (post like) and one (comment like)
      // Tap the last one (comment like)
      await tester.tap(likeIcons.last);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Please log in to like comments'), findsOneWidget);
    });
  });
}