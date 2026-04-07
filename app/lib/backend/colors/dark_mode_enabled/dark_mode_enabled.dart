import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';

part 'dark_mode_enabled.g.dart';

@riverpod
bool darkModeEnabled(Ref ref) {
  final userContextAsync = ref.watch(userContextProvider);
  return userContextAsync.maybeWhen(
    data: (context) => context.settings.darkMode,
    loading: () => userContextAsync.value?.settings.darkMode ?? false,
    error: (err, stack) => userContextAsync.value?.settings.darkMode ?? false,
    orElse: () => false,
  );
}