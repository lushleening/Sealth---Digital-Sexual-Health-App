// This provides data for welcome headers
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';

part 'welcome_header_notifier.freezed.dart';
part 'welcome_header_notifier.g.dart';

@freezed
abstract class WelcomeHeaderData with _$WelcomeHeaderData {
  const factory WelcomeHeaderData({
    required String appName,
    required UserContext userContext,
  }) = _WelcomeHeaderData;
}

// Since the scope for this provider is only on one page, we can do
// remove keepAlive to save resources and prevent useless listening
@riverpod
class WelcomeHeaderNotifier extends _$WelcomeHeaderNotifier {
  @override
  Future<WelcomeHeaderData> build() async => WelcomeHeaderData(
    // Only uses appName so just selectAsync
    appName: await ref.watch(appMetadataProvider.selectAsync((m) => m.appName)),

    // May use other userContext variables in the future thus get the full context instead
    userContext: await ref.watch(userContextProvider.future),
  );
}
