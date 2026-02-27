// CODEGEN RELATED: "dart run build_runner watch"
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/database/db_sync/repositories/profile_repository.dart';
import 'package:sddp_dsh/user/supabase_auth.dart';

part 'registered_profile.freezed.dart';
part 'registered_profile.g.dart';

// No default params since only source is generation by database

@freezed
abstract class RegisteredProfile with _$RegisteredProfile {
  const factory RegisteredProfile({
    @JsonKey(name: 'supabase_id') required String supabaseId,
    required String username,
    @JsonKey(includeFromJson: false, includeToJson: false) String? email,
    @JsonKey(name: 'avatar_url') required String? avatarUrl,
    required bool verified,
  }) = _RegisteredProfile;

  factory RegisteredProfile.fromJson(Map<String, dynamic> json) =>
      _$RegisteredProfileFromJson(json);
}

@Riverpod(keepAlive: true)
class RegisteredProfileNotifier extends _$RegisteredProfileNotifier {
  @override
  Future<RegisteredProfile?> build(String supabaseId) async {
    final repo = ref.read(profileRepositoryProvider);
    return repo.getProfile(supabaseId, ref.read(currentUserProvider)?.email);
  }

  Future<void> reload(String supabaseId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(supabaseId));
  }
}

// TODO You are currently offline, logging out or just cache data
