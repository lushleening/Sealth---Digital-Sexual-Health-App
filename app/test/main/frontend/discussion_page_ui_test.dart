import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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

class MockDiscussionServices extends Mock implements DiscussionServices {}
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockUser extends Mock implements User {}
class MockConnectivity extends Mock implements Connectivity {}

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
    await tester.pump(const Duration(milliseconds: 500));
  }

  group('DiscussionPage UI', () {
    testWidgets('builds without crashing', (tester) async {
      await pumpPage(tester);
      expect(find.byType(DiscussionPage), findsOneWidget);
    });

    testWidgets('displays Discussion Board title', (tester) async {
      await pumpPage(tester);
      expect(find.text('Discussion Board'), findsOneWidget);
    });

    testWidgets('displays search field', (tester) async {
      await pumpPage(tester);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('displays search hint text', (tester) async {
      await pumpPage(tester);
      expect(find.text('Search discussions...'), findsOneWidget);
    });

    testWidgets('displays sort button', (tester) async {
      await pumpPage(tester);
      expect(find.text('Sort'), findsOneWidget);
    });

    testWidgets('displays sort icon', (tester) async {
      await pumpPage(tester);
      expect(find.byIcon(Icons.sort), findsOneWidget);
    });

    testWidgets('displays add post button', (tester) async {
      await pumpPage(tester);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('displays empty state when no posts', (tester) async {
      await pumpPage(tester, posts: []);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('No discussion posts found'), findsOneWidget);
    });

    testWidgets('displays posts when loaded', (tester) async {
      await pumpPage(tester, posts: [testPost]);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Test Post'), findsOneWidget);
    });

    testWidgets('displays multiple posts', (tester) async {
      final post2 = DiscussionPost(
        id: 'p2',
        userId: 'u2',
        authorName: 'User 2',
        title: 'Second Post',
        content: 'Content 2',
        likes: 0,
        shares: 0,
        isVerified: false,
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );
      await pumpPage(tester, posts: [testPost, post2]);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Test Post'), findsOneWidget);
      expect(find.text('Second Post'), findsOneWidget);
    });

    testWidgets('sort bottom sheet appears on sort tap', (tester) async {
      await pumpPage(tester);
      await tester.tap(find.text('Sort'));
      await tester.pumpAndSettle();
      expect(find.text('Sort by'), findsOneWidget);
      expect(find.text('Most Recently Updated'), findsOneWidget);
      expect(find.text('Most Liked'), findsOneWidget);
      expect(find.text('Most Commented'), findsOneWidget);
      expect(find.text('Most Shared'), findsOneWidget);
    });

    testWidgets('search filters posts by title', (tester) async {
      final post2 = DiscussionPost(
        id: 'p2',
        userId: 'u2',
        authorName: 'User 2',
        title: 'Flutter Tips',
        content: 'Content',
        likes: 0,
        shares: 0,
        isVerified: false,
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );
      await pumpPage(tester, posts: [testPost, post2]);
      await tester.pump(const Duration(seconds: 1));

      await tester.enterText(find.byType(TextField), 'flutter');
      await tester.pump();

      expect(find.text('Flutter Tips'), findsOneWidget);
      expect(find.text('Test Post'), findsNothing);
    });
  });

  group('SortOption enum', () {
    test('has 4 values', () {
      expect(SortOption.values.length, 4);
    });

    test('newest has correct properties', () {
      expect(SortOption.newest.label, 'Most Recently Updated');
      expect(SortOption.newest.field, 'updated_at');
      expect(SortOption.newest.descending, false);
    });

    test('mostLiked has correct properties', () {
      expect(SortOption.mostLiked.label, 'Most Liked');
      expect(SortOption.mostLiked.field, 'likes');
      expect(SortOption.mostLiked.descending, true);
    });

    test('mostCommented has correct properties', () {
      expect(SortOption.mostCommented.label, 'Most Commented');
      expect(SortOption.mostCommented.field, 'comments');
      expect(SortOption.mostCommented.descending, true);
    });

    test('mostShared has correct properties', () {
      expect(SortOption.mostShared.label, 'Most Shared');
      expect(SortOption.mostShared.field, 'shares');
      expect(SortOption.mostShared.descending, true);
    });
  });
}