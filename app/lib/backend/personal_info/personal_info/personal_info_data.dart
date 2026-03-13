import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';

part 'personal_info_data.freezed.dart';
part 'personal_info_data.g.dart';

@freezed
abstract class PersonalInfoData with _$PersonalInfoData {
  const factory PersonalInfoData({
    required AppUser user,
    required AppRegisteredProfile profile,
  }) = _PersonalInfoData;
}

// Since the scope for this provider is only on one page, we can do
// remove keepAlive to save resources and prevent useless listening
@riverpod
class PersonalInfoNotifier extends _$PersonalInfoNotifier {
  @override
  Future<PersonalInfoData> build() async {
    final (user, profile) = await ref.watch(
      userContextProvider.selectAsync((uc) => (uc.user, uc.profile)),
    );
    if (profile == null) {
      throw Exception("Profile info fetch error: No profile found");
    }
    return PersonalInfoData(user: user, profile: profile);
  }
}
