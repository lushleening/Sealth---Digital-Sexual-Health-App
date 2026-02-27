// CODEGEN RELATED: "dart run build_runner watch"
// This provides data for welcome headers
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/helper/app_metadata.dart';
import 'package:sddp_dsh/user/app_user.dart';
import 'package:sddp_dsh/user/registered_profile.dart';
import 'package:sddp_dsh/user/user_profile.dart';

part 'welcome_header_notifier.freezed.dart';
part 'welcome_header_notifier.g.dart';

//   TODO  hasNotifications: notifications.any((n) => !n.read),
@freezed
abstract class WelcomeHeaderData with _$WelcomeHeaderData {
  const factory WelcomeHeaderData({
    required String appName,
    required AppUser user,
    required RegisteredProfile? profile,
    required bool hasNotifications,
  }) = _WelcomeHeaderData;
}

// Since the scope for this provider is only on one page, we can do
// remove keepAlive to save resources and prevent useless listening
@riverpod
class WelcomeHeaderNotifier extends _$WelcomeHeaderNotifier {
  @override
  Future<WelcomeHeaderData> build() async => _load();

  Future<WelcomeHeaderData> _load() async {
    // Read the future and grab the value of user to display
    final userProfile = await ref.watch(userProfileProvider.future);
    final appName = (await ref.watch(appMetadataProvider.future)).appName;

    final hasNotifications = false; // TODO deal with this after handling supa

    // Seperate the user and profile to write less boilerplate in UI
    return WelcomeHeaderData(
      appName: appName,
      user: userProfile.user,
      profile: userProfile.profile,
      hasNotifications: hasNotifications,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}
