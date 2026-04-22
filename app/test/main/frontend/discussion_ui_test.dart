import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/post_like_manager.dart';
import 'package:sddp_dsh/backend/discussion/post_comment_manager.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion_post_tile.dart';
import 'package:sddp_dsh/frontend/pages/discussion/create_post_page.dart';
import 'package:sddp_dsh/frontend/pages/discussion/edit_post_page.dart';
import 'package:sddp_dsh/frontend/pages/discussion/my_post_page.dart';
import 'package:sddp_dsh/frontend/pages/discussion/blocked_users_page.dart';
import 'package:sddp_dsh/frontend/pages/discussion/reported_posts_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/user_avatar.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../helper/mock_objects.dart';

class MockDiscussionServices extends Mock implements DiscussionServices {}
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockUser extends Mock implements User {}
class MockConnectivity extends Mock implements Connectivity {}

class FakeAppRegisteredProfileNotifier extends AppRegisteredProfileNotifier {
  @override
  Stream<AppRegisteredProfile> build() {
    return Stream.value(testAppRegisteredProfile);
  }
}

void main() {
  late MockDiscussionServices mockService;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;
  late MockConnectivity mockConnectivity;

  setUpAll(() {
    registerFallbackValue(testPost);
    registerFallbackValue(testComment);
  });

  setUp(() {
    mockService = MockDiscussionServices();
    mockSupabaseClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();
    mockConnectivity = MockConnectivity();
    
    when(() => mockService.supabase).thenReturn(mockSupabaseClient);
    when(() => mockSupabaseClient.auth).thenReturn(mockAuth);
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn('test-user-id');
    
    when(() => mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.wifi]);
    when(() => mockConnectivity.onConnectivityChanged)
        .thenAnswer((_) => Stream.value([ConnectivityResult.wifi]));
    
    when(() => mockService.fetchPostsWithAvatars()).thenAnswer((_) async => []);
    when(() => mockService.getBlockedUsersWithProfiles()).thenAnswer((_) async => []);
    when(() => mockService.getReportedPosts()).thenAnswer((_) async => []);
    when(() => mockService.isLiked(any())).thenAnswer((_) async => false);
    when(() => mockService.fetchComments(any())).thenAnswer((_) async => []);
    
    PostLikeManager().initialize(mockService);
    PostCommentManager().initialize(mockService);
  });

  Future<void> pumpWidget(WidgetTester tester, Widget widget) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          discussionServicesProvider.overrideWithValue(mockService),
          supabaseServiceProvider.overrideWithValue(mockSupabaseClient),
          appRegisteredProfileProvider.overrideWith(() => FakeAppRegisteredProfileNotifier()),
        ],
        child: MaterialApp(
          theme: ThemeData.light().copyWith(
            extensions: <ThemeExtension<dynamic>>[lightAppColors],
          ),
          home: widget,
        ),
      ),
    );
  }

  group('DiscussionPage', () {
    testWidgets('builds without crashing', (tester) async {
      await pumpWidget(tester, const DiscussionPage());
      await tester.pump();
      expect(find.byType(DiscussionPage), findsOneWidget);
    });
  });

  group('DiscussionPostTile', () {
    testWidgets('builds without crashing', (tester) async {
      await pumpWidget(tester, Scaffold(body: DiscussionPostTile(post: testPost)));
      await tester.pump();
      expect(find.byType(DiscussionPostTile), findsOneWidget);
    });
  });

  group('CreatePostPage', () {
    testWidgets('builds without crashing', (tester) async {
      await pumpWidget(tester, const CreatePostPage());
      await tester.pump();
      expect(find.byType(CreatePostPage), findsOneWidget);
    });
  });

  group('EditPostPage', () {
    testWidgets('builds without crashing', (tester) async {
      await pumpWidget(tester, EditPostPage(post: testPost));
      await tester.pump();
      expect(find.byType(EditPostPage), findsOneWidget);
    });
  });

  group('MyPostsPage', () {
    testWidgets('builds without crashing', (tester) async {
      await pumpWidget(tester, const MyPostsPage());
      await tester.pump();
      expect(find.byType(MyPostsPage), findsOneWidget);
    });
  });

  group('BlockedUsersPage', () {
    testWidgets('builds without crashing', (tester) async {
      await pumpWidget(tester, const BlockedUsersPage());
      await tester.pump();
      expect(find.byType(BlockedUsersPage), findsOneWidget);
    });
  });

  group('ReportedPostsPage', () {
    testWidgets('builds without crashing', (tester) async {
      await pumpWidget(tester, const ReportedPostsPage());
      await tester.pump();
      expect(find.byType(ReportedPostsPage), findsOneWidget);
    });
  });

  group('UserAvatar', () {
    testWidgets('builds without crashing', (tester) async {
      await pumpWidget(tester, const Scaffold(body: Center(child: UserAvatar(iconRadius: iconSizeSmall))));
      await tester.pump();
      expect(find.byType(UserAvatar), findsOneWidget);
    });
  });
}