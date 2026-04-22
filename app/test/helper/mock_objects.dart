import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/biometric/biometric_confirmation.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/notifications_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/profiles_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/settings_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_service.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_cacher.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_fetcher.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_rt_service.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/appointments_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart' hide User;
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/notifications/notification_service.dart';
import 'package:sddp_dsh/backend/notifications/notification_type.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:flutter/widgets.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/appointments/appointment_sync.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/backend/articles/providers/articles_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/recently_viewed_provider.dart';
import 'package:sddp_dsh/backend/home/home_data.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/recently_viewed_articles_dao.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/discussion/models/comments.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Some constants for easier testing
const localId = 'local-test-id';
const remoteId = 'supabase-test-id';
const email = 'test@gmail.com';
const password = '111111'; // At least 6 characters
const newPassword = '222222'; // At least 6 characters
const strongPassword = 'Test@129384'; // Check recommendStrongPassword

const username = "username";
const newUsername = "newUsername";

final testGuestAppUser = AppUser(
  localId: localId,
  lastLoggedIn: DateTime.now(),
);

final testRegisteredAppUser = AppUser(
  localId: localId,
  remoteId: remoteId,
  lastLoggedIn: DateTime.now(),
);

final testAppRegisteredProfile = AppRegisteredProfile(
  username: username,
  avatarUrl: null,
  verified: false,
);

final testAppSettings = AppSettings(
  darkMode: false,
  receiveNotifications: false,
  biometricConfirmation: false,
);

const List<AppNotifications> testAppNotificationsNone = [];

final testAppNotificationsOneHasNotRead = AppNotifications(
  uuid: 'test',
  title: "title",
  description: "description",
  notificationType: NotificationType.discussion.name,
  isAlertMessage: false,
  hasRead: false,
  linkToPage: AppRoute.discussion,
  scheduledAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

final testAppNotificationsOneHasRead = AppNotifications(
  uuid: 'test-2',
  title: "title",
  description: "description",
  notificationType: NotificationType.discussion.name,
  isAlertMessage: false,
  hasRead: true,
  linkToPage: AppRoute.discussion,
  scheduledAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

const testClinicId = 'clinic-test-id';
const testServiceId = 'service-test-id';
const testAppointmentId = 'appointment-test-id';

final testAppointment = Appointment(
  id: testAppointmentId,
  name: 'Test Clinic',
  description: 'STI Screening',
  datetime: DateTime(2026, 11, 9, 10, 0),
  clinicId: testClinicId,
  serviceId: testServiceId,
  notes: 'Some notes',
);

final testAppointmentMap = {
  'id': testAppointmentId,
  'user_id': remoteId,
  'clinic_id': testClinicId,
  'services_id': testServiceId,
  'clinics': {'name': 'Test Clinic'},
  'services': {'name': 'STI Screening'},
  'start_time': '2026-11-09T10:00:00.000',
  'end_time': '2026-11-09T10:30:00.000',
  'notes': 'Some notes',
};

// Test data
final testPost = DiscussionPost(
  id: 'test-post-1',
  userId: 'user-1',
  authorName: 'Test User',
  avatarUrl: 'https://test.com/avatar.jpg',
  title: 'Test Post',
  content: 'Test Content',
  likes: 5,
  shares: 2,
  isVerified: true,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  comments: 3,
);

final testComment = DiscussionComment(
  id: 'test-comment-1',
  postId: 'test-post-1',
  userId: 'user-1',
  authorName: 'Test User',
  avatarUrl: 'https://test.com/avatar.jpg',
  content: 'Test Comment',
  isVerified: true,
  likes: 2,
  parentCommentId: null,
  createdAt: DateTime.now(),
  isLiked: false,
  replyCount: 0,
);

final testReply = DiscussionComment(
  id: 'test-reply-1',
  postId: 'test-post-1',
  userId: 'user-2',
  authorName: 'Reply User',
  avatarUrl: null,
  content: 'Test Reply',
  isVerified: false,
  likes: 0,
  parentCommentId: 'test-comment-1',
  createdAt: DateTime.now(),
  isLiked: false,
  replyCount: 0,
);

// Provider overrides
const testAppMetadata = AppMetadata(appName: 'test', version: 'x.x.x');

class TestAppGuestNotifier extends AppUserNotifier {
  @override
  Future<AppUser> build() async => testGuestAppUser;
}

class TestAppRegisteredNotifier extends AppUserNotifier {
  @override
  Future<AppUser> build() async => testRegisteredAppUser;
}

class TestAppRegisteredProfileNotifier extends AppRegisteredProfileNotifier {
  @override
  Stream<AppRegisteredProfile> build() async* {
    yield* Stream.value(testAppRegisteredProfile);
  }
}

class TestAppSettingsNotifier extends AppSettingsNotifier {
  @override
  Stream<AppSettings> build() async* {
    yield* Stream.value(testAppSettings);
  }
}

class TestHasBioSettingsNotifier extends AppSettingsNotifier {
  @override
  Stream<AppSettings> build() async* {
    yield* Stream.value(testAppSettings.copyWith(biometricConfirmation: true));
  }
}

class TestNoBioSettingsNotifier extends AppSettingsNotifier {
  @override
  Stream<AppSettings> build() async* {
    yield* Stream.value(testAppSettings.copyWith(biometricConfirmation: false));
  }
}

class TestAppNotificationNoneNotifier extends AppNotificationNotifier {
  @override
  Stream<List<AppNotifications>> build() async* {
    yield* Stream.value(testAppNotificationsNone);
  }
}

class TestAppNotificationOneHasReadNotifier
    extends TestAppNotificationNoneNotifier {
  @override
  Stream<List<AppNotifications>> build() async* {
    yield* Stream.value([testAppNotificationsOneHasRead]);
  }
}

class TestAppNotificationOneHasNotReadNotifier
    extends TestAppNotificationNoneNotifier {
  @override
  Stream<List<AppNotifications>> build() async* {
    yield* Stream.value([testAppNotificationsOneHasNotRead]);
  }
}

class TestAppNotificationsMoreNotifier extends TestAppNotificationNoneNotifier {
  @override
  Stream<List<AppNotifications>> build() async* {
    yield* Stream.value([
      testAppNotificationsOneHasNotRead,
      testAppNotificationsOneHasRead,
    ]);
  }
}

class TestAppMetadataNotifier extends AppMetadataNotifier {
  @override
  Future<AppMetadata> build() async => testAppMetadata;
}

// ─── Article test data ────────────────────────────────────────────────────────

final testArticle = Article(
  articleId: 'home-test-article-1',
  authorId: 'author-1',
  title: 'Test Article for Home',
  content: 'Test article content.',
  image: 'assets/placeholder.png',
  markdownUrl: 'assets/articles/hiv_testing.md',
  category: 'Testing',
  linkToSubpage: const SizedBox(),
);

final testArticleData = {'article': testArticle, 'category': 'Testing'};

// Returns one article so ContinueReading / NewArticles sections render.
class TestArticlesNotifier extends ArticlesNotifier {
  TestArticlesNotifier({required super.ref});

  @override
  Future<void> loadArticlesFromSupabase() async {
    if (mounted) state = [testArticleData];
  }
}

// Provides pre-built HomeData so the home page renders without going through
// the full async provider chain (avoids timing issues with articlesProvider).
class TestHomeDataNotifier extends HomeDataNotifier {
  @override
  Future<HomeData> build() async => HomeData(
    appName: testAppMetadata.appName,
    userContext: UserContext(
      user: testGuestAppUser,
      profile: null,
      notifications: const [],
      settings: testAppSettings,
    ),
    appointments: [
      Appointment(
        id: testAppointmentId,
        name: 'Test Clinic',
        description: 'STI Screening',
        datetime: DateTime.now().add(const Duration(days: 1)),
        clinicId: testClinicId,
        serviceId: testServiceId,
      ),
    ],
    articles: [testArticle],
  );
}

// Mock DAO for RecentlyViewedNotifier — avoids opening real SQLite on Windows.
class MockRecentlyViewedDAO extends Mock implements RecentlyViewedArticlesDAO {}

// Pre-seeds recently viewed with the home test article so ContinueReading renders.
class TestRecentlyViewedNotifier extends RecentlyViewedNotifier {
  TestRecentlyViewedNotifier()
      : super(dao: _stubDao(), localId: 'test-user');

  static MockRecentlyViewedDAO _stubDao() {
    final dao = MockRecentlyViewedDAO();
    when(() => dao.getRecentlyViewed(any()))
        .thenAnswer((_) async => ['home-test-article-1']);
    when(() => dao.upsertViewed(any(), any())).thenAnswer((_) async {});
    return dao;
  }
}

Database makeTestDatabase() => Database(NativeDatabase.memory());

// Mocks
// Misc
class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class MockAndroidFlutterLocalNotificationsPlugin extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

class MockNotificationService extends Mock implements NotificationService {}

class MockImagePicker extends Mock implements ImagePicker {}

class MockBiometricConfirmation extends Mock implements BiometricConfirmation {}

class MockXFile extends Mock implements XFile {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class MockLocalAuthentication extends Mock implements LocalAuthentication {}

// Supabase
class MockUser extends Mock implements User {}

class MockSession extends Mock implements Session {}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseAuth extends Mock implements SupabaseAuth {}

class MockSupabaseDBFetcher extends Mock implements SupabaseDBFetcher {}

class MockSupabaseDBCacher extends Mock implements SupabaseDBCacher {}

class MockSupabaseRTService extends Mock implements SupabaseRealtimeService {}

class MockRealtimeChannel extends Mock implements RealtimeChannel {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockSupabaseStorageClient extends Mock implements SupabaseStorageClient {}

class MockStorageFileApi extends Mock implements StorageFileApi {}

class MockFile extends Mock implements File {}

// Self-defined
class MockUsersRepository extends Mock implements UsersRepository {}

class MockProfilesRepository extends Mock implements ProfilesRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class MockDiscussionServices extends Mock implements DiscussionServices {}

class MockSyncService extends Mock implements SyncService {}

class MockAppointmentSyncService extends Mock
    implements AppointmentSyncService {}


class MockPostgrestBuilder extends Mock implements PostgrestBuilder {}

// Add these mock classes
class MockAppointmentsDAO extends Mock implements AppointmentsDAO {}

