import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/post_like_manager.dart';
import 'package:sddp_dsh/backend/discussion/post_comment_manager.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/frontend/pages/discussion/edit_post_page.dart';
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
          home: EditPostPage(post: testPost),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  group('EditPostPage UI elements', () {
    testWidgets('displays Edit Post title', (tester) async {
      await pumpPage(tester);
      expect(find.text('Edit Post'), findsOneWidget);
    });

    testWidgets('displays Post Title label', (tester) async {
      await pumpPage(tester);
      expect(find.text('Post Title *'), findsOneWidget);
    });

    testWidgets('displays Post Content label', (tester) async {
      await pumpPage(tester);
      expect(find.text('Post Content *'), findsOneWidget);
    });

    testWidgets('pre-fills title with existing post title', (tester) async {
      await pumpPage(tester);
      expect(find.text('Test Post'), findsOneWidget);
    });

    testWidgets('pre-fills content with existing post content', (tester) async {
      await pumpPage(tester);
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('displays Save button in appbar', (tester) async {
      await pumpPage(tester);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('displays Save Changes button at bottom', (tester) async {
      await pumpPage(tester);
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('displays back button', (tester) async {
      await pumpPage(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });

  group('EditPostPage validation async paths', () {
    testWidgets('shows error when title is cleared and saved', (tester) async {
      await pumpPage(tester);

      final titleField = find.byType(TextFormField).first;
      await tester.tap(titleField);
      await tester.pump();
      await tester.enterText(titleField, '');
      await tester.pump();

      await tester.tap(find.text('Save Changes'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Please enter a title'), findsOneWidget);
    });

    testWidgets('shows error when content is cleared and saved', (tester) async {
      await pumpPage(tester);

      final contentField = find.byType(TextFormField).last;
      await tester.tap(contentField);
      await tester.pump();
      await tester.enterText(contentField, '');
      await tester.pump();

      await tester.tap(find.text('Save Changes'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Please enter content'), findsOneWidget);
    });

    testWidgets('calls updatePost when form is valid', (tester) async {
      when(() => mockService.updatePost(
            postId: any(named: 'postId'),
            title: any(named: 'title'),
            content: any(named: 'content'),
          )).thenAnswer((_) async => testPost);

      await pumpPage(tester);

      final titleField = find.byType(TextFormField).first;
      await tester.enterText(titleField, 'Updated Title');
      await tester.pump();

      await tester.tap(find.text('Save Changes'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockService.updatePost(
            postId: testPost.id,
            title: any(named: 'title'),
            content: any(named: 'content'),
          )).called(1);
    });

    testWidgets('shows error snackbar when updatePost fails', (tester) async {
      when(() => mockService.updatePost(
            postId: any(named: 'postId'),
            title: any(named: 'title'),
            content: any(named: 'content'),
          )).thenThrow(Exception('Update failed'));

      await pumpPage(tester);

      await tester.tap(find.text('Save Changes'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('Error updating post'), findsOneWidget);
    });
  });
}