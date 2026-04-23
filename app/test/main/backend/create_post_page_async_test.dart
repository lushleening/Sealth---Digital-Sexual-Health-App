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
import 'package:sddp_dsh/frontend/pages/discussion/create_post_page.dart';
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
          home: const CreatePostPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('CreatePostPage UI elements', () {
    testWidgets('displays Post Title label', (tester) async {
      await pumpPage(tester);
      expect(find.text('Post Title *'), findsOneWidget);
    });

    testWidgets('displays Post Content label', (tester) async {
      await pumpPage(tester);
      expect(find.text('Post Content *'), findsOneWidget);
    });

    testWidgets('displays anonymous post toggle', (tester) async {
      await pumpPage(tester);
      expect(find.text('Anonymous post'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('displays Post button', (tester) async {
      await pumpPage(tester);
      expect(find.text('Post'), findsOneWidget);
    });

    testWidgets('displays title text field', (tester) async {
      await pumpPage(tester);
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('anonymous checkbox is checked by default', (tester) async {
      await pumpPage(tester);
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
    });

    testWidgets('toggling anonymous checkbox changes state', (tester) async {
      await pumpPage(tester);
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);
    });
  });

  group('CreatePostPage validation async paths', () {
    testWidgets('shows snackbar when title is empty on submit', (tester) async {
      await pumpPage(tester);

      // Find all text fields - there should be 2 (title and content)
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));
      
      // Enter content only (second text field)
      await tester.enterText(textFields.at(1), 'Some content');
      await tester.pump();

      // Tap the Post button
      final postButton = find.text('Post');
      expect(postButton, findsOneWidget);
      await tester.tap(postButton);
      await tester.pump();

      // Wait for snackbar to appear
      await tester.pump(const Duration(milliseconds: 500));

      // Check for the error message
      expect(find.text('Please enter a title'), findsOneWidget);
    });

    testWidgets('shows snackbar when content is empty on submit',
        (tester) async {
      await pumpPage(tester);

      // Find all text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));
      
      // Enter title only (first text field)
      await tester.enterText(textFields.at(0), 'My Title');
      await tester.pump();

      // Tap the Post button
      final postButton = find.text('Post');
      expect(postButton, findsOneWidget);
      await tester.tap(postButton);
      await tester.pump();

      // Wait for snackbar to appear
      await tester.pump(const Duration(milliseconds: 500));

      // Check for the error message
      expect(find.text('Please enter post content'), findsOneWidget);
    });

    testWidgets('calls createPost when title and content are filled',
        (tester) async {
      when(() => mockService.createPost(
            title: any(named: 'title'),
            content: any(named: 'content'),
            isAnonymous: any(named: 'isAnonymous'),
            tags: any(named: 'tags'),
          )).thenAnswer((_) async => testPost);

      when(() => mockService.fetchPostsWithAvatars())
          .thenAnswer((_) async => []);

      await pumpPage(tester);

      // Find all text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));
      
      // Enter both title and content
      await tester.enterText(textFields.at(0), 'My Title');
      await tester.enterText(textFields.at(1), 'My Content');
      await tester.pump();

      // Tap the Post button
      final postButton = find.text('Post');
      expect(postButton, findsOneWidget);
      await tester.tap(postButton);
      await tester.pump();

      // Wait for async operations to complete
      await tester.pumpAndSettle(const Duration(seconds: 1));

      verify(() => mockService.createPost(
            title: 'My Title',
            content: 'My Content',
            isAnonymous: any(named: 'isAnonymous'),
            tags: any(named: 'tags'),
          )).called(1);
    });

    testWidgets('shows error snackbar when createPost fails', (tester) async {
      when(() => mockService.createPost(
            title: any(named: 'title'),
            content: any(named: 'content'),
            isAnonymous: any(named: 'isAnonymous'),
            tags: any(named: 'tags'),
          )).thenThrow(Exception('Server error'));

      await pumpPage(tester);

      // Find all text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));
      
      // Enter both title and content
      await tester.enterText(textFields.at(0), 'My Title');
      await tester.enterText(textFields.at(1), 'My Content');
      await tester.pump();

      // Tap the Post button
      final postButton = find.text('Post');
      expect(postButton, findsOneWidget);
      await tester.tap(postButton);
      await tester.pump();

      // Wait for async operations and snackbar
      await tester.pump(const Duration(milliseconds: 500));

      // Check for error message (using contains since the exact message might vary)
      expect(find.textContaining('Failed to create post'), findsOneWidget);
    });
  });
}