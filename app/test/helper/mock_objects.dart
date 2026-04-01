import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/biometric/biometric_confirmation.dart';
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

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

const testAppMetadata = AppMetadata(appName: 'test', version: 'x.x.x');

class MockSupabaseAuth extends Mock implements SupabaseAuth {}

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
