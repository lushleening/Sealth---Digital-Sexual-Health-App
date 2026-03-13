import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/frontend/pages/articles/article_reader_page.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/articles/providers/articles_provider.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

// Place your mocked providers here

const localId = 'local-test-id';
const remoteId = 'supabase-test-id';

class TestAppGuestNotifier extends AppUserNotifier {
  @override
  Future<AppUser> build() async {
    return AppUser(
      localId: localId,
      lastLoggedIn: DateTime.now(),
    );
  }
}

class TestAppRegisteredNotifier extends AppUserNotifier {
  @override
  Future<AppUser> build() async {
    return AppUser(
      localId: localId,
      remoteId: remoteId,
      lastLoggedIn: DateTime.now(),
    );
  }
}

class TestAppRegisteredProfileNotifier extends AppRegisteredProfileNotifier {
  @override
  Future<AppRegisteredProfile> build() async {
    return AppRegisteredProfile(
      username: 'test',
      avatarUrl: null,
      verified: false,
    );
  }
}

class TestAppSettingsNotifier extends AppSettingsNotifier {
  @override
  Future<AppSettings> build() async {
    return AppSettings(
      darkMode: false,
      receiveNotifications: false,
      autoUpdate: false,
    );
  }
}

class TestAppMetadataNotifier extends AppMetadataNotifier {
  @override
  Future<AppMetadata> build() async {
    return AppMetadata(appName: 'test', version: 'x.x.x');
  }
}

// TODO change to notiferprovider instead as i think u will face issues during backend
class TestArticlesNotifier extends ArticlesNotifier {
  TestArticlesNotifier() : super() {
    state = [
      {
        "article": Article(
          title: "Test Article",
          content: "Test Content",
          linkToSubpage: const ArticleReaderPage(
            title: "Test Article",
            content: "Test Content",
          ),
        ),
        "category": "General",
      },
    ];
  }
}
