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
import 'package:sddp_dsh/frontend/pages/discussion/my_post_page.dart';
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

    when(() => mockService.fetchPostsWithAvatars()).thenAnswer((_) async => []);
    when(() => mockService.isLiked(any())).thenAnswer((_) async => false);
    when(() => mockService.fetchComments(any())).thenAnswer((_) async => []);

    PostLikeManager().initialize(mockService);
    PostCommentManager().initialize(mockService);
  });

  final myPost = DiscussionPost(
    id: 'my-post-1',
    userId: 'test-user-id',
    authorName: 'Test User',
    title: 'My Post Title',
    content: 'My post content',
    likes: 0,
    shares: 0,
    isVerified: false,
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );

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
          home: const MyPostsPage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

  group('MyPostsPage async paths', () {
    testWidgets('shows loading then empty state', (tester) async {
      await pumpPage(tester, posts: []);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text("You haven't posted anything yet."), findsOneWidget);
    });

    testWidgets('displays user own post', (tester) async {
      await pumpPage(tester, posts: [myPost]);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('My Post Title'), findsOneWidget);
    });

    testWidgets('long press on post enters selection mode', (tester) async {
      await pumpPage(tester, posts: [myPost]);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.longPress(find.text('My Post Title'));
      await tester.pumpAndSettle();

      // Delete button should appear in bottom nav
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('tap post in selection mode toggles selection', (tester) async {
      await pumpPage(tester, posts: [myPost]);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Enter selection mode
      await tester.longPress(find.text('My Post Title'));
      await tester.pumpAndSettle();

      // Tap again to deselect
      await tester.tap(find.text('My Post Title'));
      await tester.pumpAndSettle();

      // Bottom nav should disappear when nothing selected
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });

    testWidgets('delete button shows confirmation dialog', (tester) async {
      when(() => mockService.deletePosts(any())).thenAnswer((_) async {});

      await pumpPage(tester, posts: [myPost]);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.longPress(find.text('My Post Title'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Delete Posts'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('cancel on delete dialog dismisses it', (tester) async {
      await pumpPage(tester, posts: [myPost]);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.longPress(find.text('My Post Title'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Delete Posts'), findsNothing);
    });

    testWidgets('confirm delete calls deletePosts', (tester) async {
      when(() => mockService.deletePosts(any())).thenAnswer((_) async {});
      when(() => mockService.fetchPostsWithAvatars())
          .thenAnswer((_) async => []);

      await pumpPage(tester, posts: [myPost]);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.longPress(find.text('My Post Title'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      verify(() => mockService.deletePosts(any())).called(1);
    });

    testWidgets('shows edit button when exactly one post selected',
        (tester) async {
      await pumpPage(tester, posts: [myPost]);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.longPress(find.text('My Post Title'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });
  });
}