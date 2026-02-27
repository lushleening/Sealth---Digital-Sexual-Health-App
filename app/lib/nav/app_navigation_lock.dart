// CODEGEN RELATED: "dart run build_runner watch"
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_navigation_lock.g.dart';

// Locks navigation to prevent async issues
@Riverpod(keepAlive: true)
class AppNavigationLockNotifier extends _$AppNavigationLockNotifier {
  @override
  bool build() => false;
  void lock() => state = true;
  void unlock() => state = false;
}
