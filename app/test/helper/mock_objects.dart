import 'package:sddp_dsh/helper/app_metadata.dart';
import 'package:sddp_dsh/objects/article.dart';
import 'package:sddp_dsh/pages/articles/article_reader_page.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/settings/providers/app_settings.dart';
import 'package:sddp_dsh/providers/articles_provider.dart';
import 'package:sddp_dsh/user/app_user.dart';
import 'package:sddp_dsh/user/registered_profile.dart';

// Place your mocked providers here

const localId = 'local-test-id';
const supabaseId = 'supabase-test-id';

class TestAppGuestNotifier extends AppUserNotifier {
  @override
  Future<AppUser> build() async {
    return AppUser(
      localId: localId,
      isGuest: true,
      lastLoggedIn: DateTime.now(),
    );
  }
}

class TestAppRegisteredNotifier extends AppUserNotifier {
  @override
  Future<AppUser> build() async {
    return AppUser(
      localId: localId,
      supabaseId: supabaseId,
      isGuest: false,
      lastLoggedIn: DateTime.now(),
    );
  }
}

class TestRegisteredProfileNotifier extends RegisteredProfileNotifier {
  @override
  Future<RegisteredProfile> build(String _) async {
    return RegisteredProfile(
      supabaseId: supabaseId,
      username: 'test',
      email: null,
      avatarUrl: null,
      verified: false,
    );
  }
}

class TestAppSettingsNotifier extends AppSettingsNotifier {
  @override
  Future<AppSettings> build() async {
    return AppSettings(
      localId: 'local-test-id',
      darkMode: false,
      receiveNotifications: false,
      autoSync: false,
      autoUpdate: false,
    );
  }
}

class TestAppMetadataNotifier extends AppMetadataNotifier {
  @override
  Future<AppMetadata> build() async {
    return AppMetadata(appName: 'test', version: 'x.x.x', buildNumber: 'x');
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
