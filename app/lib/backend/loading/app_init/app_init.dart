
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_init.g.dart';

// Reserved for loading
@riverpod
Future<bool> appInit(Ref ref) async {
  // Show loading to make sure the page still exists
  // await Future.delayed(const Duration(seconds: loadingSecs));
  return true;
}
