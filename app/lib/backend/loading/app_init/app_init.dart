
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';

part 'app_init.g.dart';

// Reserved for loading
@riverpod
Future<bool> appInit(Ref ref) async {
  // Wait until UserContext finishes loading
  await ref.watch(userContextProvider.future);
  return true;
}
