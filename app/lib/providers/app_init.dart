// CODEGEN RELATED: "dart run build_runner watch"
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/helper/constants.dart';

part 'app_init.g.dart';

// Reserved for loading
@riverpod
Future<bool> appInitDone(Ref ref) async {
  // Show loading on debug to make sure the page still exists
  // if (kDebugMode)
  await Future.delayed(const Duration(seconds: loadingSecs));
  return true;
}
