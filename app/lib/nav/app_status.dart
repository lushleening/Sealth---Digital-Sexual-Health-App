// CODEGEN RELATED: "dart run build_runner watch"
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/providers/app_init.dart';

part 'app_status.g.dart';

// Changes pages based on AppStatus (mainly for login / logout)
enum AppStatus { loading, unauthenticated, authenticated }

@Riverpod(keepAlive: true)
class AppStatusNotifier extends _$AppStatusNotifier {
  @override
  AppStatus build() {
    final initAsync = ref.watch(appInitDoneProvider);
    return initAsync.when(
      loading: () => AppStatus.loading,
      error: (_, _) => AppStatus.unauthenticated,
      data: (_) => AppStatus.authenticated,
    );
  }

  void _setStatus(AppStatus status) => state = status;

  void setLoading() => _setStatus(AppStatus.loading);
  void setAuthenticated() => _setStatus(AppStatus.authenticated);
  void setUnauthenticated() => _setStatus(AppStatus.unauthenticated);
}
