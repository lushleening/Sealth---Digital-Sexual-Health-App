import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/profiles_repository.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

part 'app_registered_profile.freezed.dart';
part 'app_registered_profile.g.dart';

// The registered user's profile
@freezed
abstract class AppRegisteredProfile
    with _$AppRegisteredProfile
    implements Syncable {
  const AppRegisteredProfile._();

  // For json_serializable to sync to/from database
  const factory AppRegisteredProfile({
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'avatar_url') required String? avatarUrl,
    @JsonKey(name: 'verified') required bool verified,
  }) = _AppRegisteredProfile;

  factory AppRegisteredProfile.fromJson(Map<String, dynamic> json) =>
      _$AppRegisteredProfileFromJson(json);
}

// Provider watches appUserProvider.remoteId
@Riverpod(keepAlive: true)
class AppRegisteredProfileNotifier extends _$AppRegisteredProfileNotifier {
  @override
  Stream<AppRegisteredProfile?> build() async* {
    // If remoteId changes, this rebuilds
    final remoteId = (await ref.watch(appUserProvider.future)).remoteId;
    if (remoteId == null) {
      yield null;
      return;
    } else {
      yield* ref.read(profilesRepositoryProvider).watchProfile(remoteId);
    }
  }

  Future<void> updateProfile(
    AppRegisteredProfile newProfile,
  ) async {
    final remoteId = await ref.read(appUserProvider.selectAsync((u) => u.remoteId));
    if (remoteId == null) return;

    profileLogger.info("Updating profile of '$remoteId' to $newProfile");
    await ref
        .read(profilesRepositoryProvider)
        .upsertProfileRemote(remoteId, newProfile);
  }
}

class MockAppRegisteredProfileNotifier extends _$AppRegisteredProfileNotifier
    with Mock
    implements AppRegisteredProfileNotifier {}
