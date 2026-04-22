import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';
import 'package:sddp_dsh/backend/discussion/post_like_manager.dart';
import 'package:sddp_dsh/backend/discussion/post_comment_manager.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_post_tile.dart';
import '../../helper/mock_objects.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';

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
    when(() => mockService.fetchComments(any())).thenAnswer((_) async => []);
    when(() => mockService.getShareText(any(), any(), any())).thenAnswer((_) async => 'Share text');
    
    PostLikeManager().initialize(mockService);
    PostCommentManager().initialize(mockService);
  });

  Future<void> pumpTile(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          discussionServicesProvider.overrideWithValue(mockService),
        ],
        child: MaterialApp(
          theme: ThemeData.light().copyWith(
            extensions: <ThemeExtension<dynamic>>[lightAppColors],
          ),
          home: Scaffold(
            body: DiscussionPostTile(post: testPost),
          ),
        ),
      ),
    );
  }

  group('DiscussionPostTile', () {
    testWidgets('builds without crashing', (tester) async {
      await pumpTile(tester);
      await tester.pump();
      expect(find.byType(DiscussionPostTile), findsOneWidget);
    });

    testWidgets('displays post title', (tester) async {
      await pumpTile(tester);
      await tester.pump();
      expect(find.text('Test Post'), findsOneWidget);
    });

    testWidgets('displays author name', (tester) async {
      await pumpTile(tester);
      await tester.pump();
      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('displays verified icon for verified user', (tester) async {
      await pumpTile(tester);
      await tester.pump();
      expect(find.byIcon(Icons.verified), findsOneWidget);
    });

    testWidgets('displays like count', (tester) async {
      await pumpTile(tester);
      await tester.pump();
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('displays comment count', (tester) async {
      await pumpTile(tester);
      await tester.pump();
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('displays share count', (tester) async {
      await pumpTile(tester);
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('displays like icon', (tester) async {
      await pumpTile(tester);
      await tester.pump();
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('displays comment icon', (tester) async {
      await pumpTile(tester);
      await tester.pump();
      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
    });

    testWidgets('displays share icon', (tester) async {
      await pumpTile(tester);
      await tester.pump();
      expect(find.byIcon(Icons.repeat), findsOneWidget);
    });

    testWidgets('displays menu button', (tester) async {
      await pumpTile(tester);
      await tester.pump();
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('displays avatar', (tester) async {
      await pumpTile(tester);
      await tester.pump();
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });

  group('DiscussionPostTile with unverified user', () {
    testWidgets('does not display verified icon for unverified user', (tester) async {
      final unverifiedPost = DiscussionPost(
        id: 'test-post-2',
        userId: 'user-1',
        authorName: 'Test User',
        title: 'Test Post',
        content: 'Content',
        likes: 5,
        shares: 2,
        isVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        comments: 3,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            discussionServicesProvider.overrideWithValue(mockService),
          ],
          child: MaterialApp(
            theme: ThemeData.light().copyWith(
              extensions: <ThemeExtension<dynamic>>[lightAppColors],
            ),
            home: Scaffold(
              body: DiscussionPostTile(post: unverifiedPost),
            ),
          ),
        ),
      );
      await tester.pump();
      
      expect(find.byIcon(Icons.verified), findsNothing);
    });
  });
}