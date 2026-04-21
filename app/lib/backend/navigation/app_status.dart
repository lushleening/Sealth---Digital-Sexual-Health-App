import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

part 'app_status.g.dart';

// Changes pages based on AppStatus (mainly for login / logout)
enum AppStatus { loading, authenticated, error }

@Riverpod(keepAlive: true)
class AppStatusNotifier extends _$AppStatusNotifier {
  @override
  AppStatus build() {
    return ref
        .watch(appUserProvider)
        .when(
          loading: () => AppStatus.loading,
          error: (_, _) => AppStatus.error,
          data: (_) => AppStatus.authenticated,
        );
  }
}
