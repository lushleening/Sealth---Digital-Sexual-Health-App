
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';

part 'app_status.g.dart';

// Changes pages based on AppStatus (mainly for login / logout)
enum AppStatus { loading, authenticated, error }

@Riverpod(keepAlive: true)
class AppStatusNotifier extends _$AppStatusNotifier {
  @override
  AppStatus build() {
    return ref.watch(userContextProvider).when(
      loading: () => AppStatus.loading,
      error: (_, _) => AppStatus.error,
      data: (_) => AppStatus.authenticated,
    );
  }
}
