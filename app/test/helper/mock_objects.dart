import 'package:drift/native.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/biometric/biometric_confirmation.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/appointments/appointment_sync.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/discussion/models/comments.dart';




const localId = 'local-test-id';
const remoteId = 'supabase-test-id';
const mockEmail = 'test@gmail.com';
const mockPassword = '111111'; // At least 6 characters

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

const testAppRegisteredProfile = AppRegisteredProfile(
  username: username,
  avatarUrl: null,
  verified: false,
);

const testAppSettings = AppSettings(
  darkMode: false,
  receiveNotifications: false,
  biometricConfirmation: false,
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

const testAppMetadata = AppMetadata(appName: 'test', version: 'x.x.x');

class MockSupabaseAuth extends Mock implements SupabaseAuth {}

class MockDiscussionServices extends Mock implements DiscussionServices {}

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
  Future<AppRegisteredProfile> build() async => testAppRegisteredProfile;
}

class TestAppSettingsNotifier extends AppSettingsNotifier {
  @override
  Future<AppSettings> build() async => testAppSettings;
}

class TestAppMetadataNotifier extends AppMetadataNotifier {
  @override
  Future<AppMetadata> build() async => testAppMetadata;
}

class MockBiometricConfirmation extends Mock implements BiometricConfirmation {}

class MockAppointmentSyncService extends Mock implements AppointmentSyncService {}

Database makeTestDatabase() => Database(NativeDatabase.memory());


// TODO change to notiferprovider instead as i think u will face issues during backend
// TODO id told you so, ref is required to fetch supabaseService provider
// class TestArticlesNotifier extends ArticlesNotifier {
//   TestArticlesNotifier() : super(ref: ) {
//     state = [
//       {
//         "article": Article(
//           title: "Test Article",
//           content: "Test Content",
//           linkToSubpage: 'TODO',
//           // const ArticleReaderPage(
//           //   title: "Test Article",
//           //   content: "Test Content",
//           // ),
//         ),
//         "category": "General",
//       },
//     ];
//   }
// }
