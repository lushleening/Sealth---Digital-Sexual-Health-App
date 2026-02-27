// CODEGEN RELATED: "dart run build_runner watch"
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/user/app_user.dart';
import 'package:sddp_dsh/user/registered_profile.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

// A combination of registered user + profile? provider
// since it is used extensively together
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required AppUser user,
    required RegisteredProfile? profile,
  }) = _UserProfile;
}

@Riverpod(keepAlive: true)
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Future<UserProfile> build() async => _load();

  Future<UserProfile> _load() async {
    final user = await ref.watch(appUserProvider.future);
    RegisteredProfile? profile;
    if (user.isRegistered) {
      profile = await ref.watch(
        registeredProfileProvider(user.supabaseId!).future,
      );
    }
    // TODO smells fishy.   showErrorSnackbar('Could not load profile. Check your connection.');
    return UserProfile(user: user, profile: profile);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}
