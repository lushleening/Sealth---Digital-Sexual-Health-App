import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

part 'user_context.freezed.dart';
part 'user_context.g.dart';

// Contains all the context the app needs to understand about the user
@freezed
abstract class UserContext with _$UserContext {
  const factory UserContext({
    required AppUser user,
    required AppRegisteredProfile? profile,
    required List<AppNotifications> notifications,
    required AppSettings settings,
  }) = _UserContext;

  const UserContext._();
  bool get isRegisteredUser => user.remoteId != null && profile != null;
}

// Provider depends on all other providers
@Riverpod(keepAlive: true)
class UserContextNotifier extends _$UserContextNotifier {
  @override
  Future<UserContext> build() async {
    return UserContext(
      user: await ref.watch(appUserProvider.future),
      profile: await ref.watch(appRegisteredProfileProvider.future),
      notifications: await ref.watch(appNotificationProvider.future),
      settings: await ref.watch(appSettingsProvider.future),
    );
  }
}
