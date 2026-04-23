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
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../helper/mock_objects.dart';
import 'package:sddp_dsh/frontend/common_widgets/user_avatar.dart';

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

    when(() => mockService.fetchPostsWithAvatars()).thenAnswer((_) async => []);
    when(() => mockService.isLiked(any())).thenAnswer((_) async => false);
    when(() => mockService.fetchComments(any())).thenAnswer((_) async => []);

    PostLikeManager().initialize(mockService);
    PostCommentManager().initialize(mockService);
  });

  Future<void> pumpPage(WidgetTester tester,
      {List<DiscussionPost> posts = const []}) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    when(() => mockService.fetchPostsWithAvatars())
        .thenAnswer((_) async => posts);

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
          home: const DiscussionPage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

  group('DiscussionPage async paths', () {
    testWidgets('shows login snackbar when user is null and taps add',
        (tester) async {
      when(() => mockAuth.currentUser).thenReturn(null);
      await pumpPage(tester);

      // Wait for any async operations
      await tester.pumpAndSettle();
      
      // Find and tap the add button
      final addButton = find.byIcon(Icons.add);
      expect(addButton, findsOneWidget);
      
      await tester.tap(addButton);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.text('Please log in to create a post'),
        findsOneWidget,
      );
    });

    testWidgets('shows login snackbar when user taps profile and not logged in',
        (tester) async {
      when(() => mockAuth.currentUser).thenReturn(null);
      await pumpPage(tester);

      // Wait for any async operations
      await tester.pumpAndSettle();

      // Find the profile avatar (the second GestureDetector in the AppBar actions)
      // The profile menu is the last GestureDetector in the AppBar
      final profileButton = find.byWidgetPredicate((widget) {
        if (widget is GestureDetector) {
          // Look for the GestureDetector that contains a UserAvatar
          final child = widget.child;
          if (child is Padding && child.child is UserAvatar) {
            return true;
          }
        }
        return false;
      });
      
      expect(profileButton, findsOneWidget);
      
      await tester.tap(profileButton);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.text('Please log in to view your profile'),
        findsOneWidget,
      );
    });

    testWidgets('sort bottom sheet closes after selecting option',
        (tester) async {
      await pumpPage(tester, posts: [testPost]);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sort'));
      await tester.pumpAndSettle();

      expect(find.text('Most Liked'), findsOneWidget);

      await tester.tap(find.text('Most Liked'));
      await tester.pumpAndSettle();

      expect(find.text('Sort by'), findsNothing);
    });

    testWidgets('search filters posts correctly', (tester) async {
      final post2 = DiscussionPost(
        id: 'p2',
        userId: 'u2',
        authorName: 'User 2',
        title: 'Flutter Guide',
        content: 'Content',
        likes: 0,
        shares: 0,
        isVerified: false,
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );

      await pumpPage(tester, posts: [testPost, post2]);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'flutter');
      await tester.pump();

      expect(find.text('Flutter Guide'), findsOneWidget);
      expect(find.text('Test Post'), findsNothing);
    });

    testWidgets('shows no posts found when search has no results',
        (tester) async {
      await pumpPage(tester, posts: [testPost]);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'zzznomatch');
      await tester.pump();

      expect(find.text('No discussion posts found'), findsOneWidget);
    });

    testWidgets('posts sorted by most liked when selected', (tester) async {
      final post1 = DiscussionPost(
        id: 'p1',
        userId: 'u1',
        authorName: 'User 1',
        title: 'Low Likes Post',
        content: 'Content',
        likes: 1,
        shares: 0,
        isVerified: false,
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );
      final post2 = DiscussionPost(
        id: 'p2',
        userId: 'u2',
        authorName: 'User 2',
        title: 'High Likes Post',
        content: 'Content',
        likes: 100,
        shares: 0,
        isVerified: false,
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );

      await pumpPage(tester, posts: [post1, post2]);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sort'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Most Liked'));
      await tester.pumpAndSettle();

      expect(find.text('High Likes Post'), findsOneWidget);
      expect(find.text('Low Likes Post'), findsOneWidget);
    });
  });
}