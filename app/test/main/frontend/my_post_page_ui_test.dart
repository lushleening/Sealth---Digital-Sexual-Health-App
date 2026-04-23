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
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
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
    await tester.pump(const Duration(milliseconds: 500));
  }

  group('MyPostsPage UI', () {
    testWidgets('builds without crashing', (tester) async {
      await pumpPage(tester);
      expect(find.byType(MyPostsPage), findsOneWidget);
    });

    testWidgets('displays My Posts title', (tester) async {
      await pumpPage(tester);
      expect(find.text('My Posts'), findsOneWidget);
    });

    testWidgets('displays back button', (tester) async {
      await pumpPage(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('shows empty state when user has no posts', (tester) async {
      await pumpPage(tester, posts: []);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("You haven't posted anything yet."), findsOneWidget);
    });

    testWidgets('displays user posts when available', (tester) async {
      final myPost = DiscussionPost(
        id: 'my-post-1',
        userId: 'test-user-id', // matches mockUser.id
        authorName: 'Test User',
        title: 'My Post Title',
        content: 'My post content',
        likes: 0,
        shares: 0,
        isVerified: false,
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );

      await pumpPage(tester, posts: [myPost]);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('My Post Title'), findsOneWidget);
    });

    testWidgets('does not display other users posts', (tester) async {
      final otherPost = DiscussionPost(
        id: 'other-post-1',
        userId: 'other-user-id', // different from test-user-id
        authorName: 'Other User',
        title: 'Other Post',
        content: 'Other content',
        likes: 0,
        shares: 0,
        isVerified: false,
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );

      await pumpPage(tester, posts: [otherPost]);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("You haven't posted anything yet."), findsOneWidget);
    });
  });
}