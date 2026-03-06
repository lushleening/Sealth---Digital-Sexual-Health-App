import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';

part 'dark_mode_enabled.g.dart';

@riverpod
bool darkModeEnabled(Ref ref) => ref.watch(
  userContextProvider.select(
    (a) => a.maybeWhen(data: (c) => c.settings.darkMode, orElse: () => false),
  ),
);
