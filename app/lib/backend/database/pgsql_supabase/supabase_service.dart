import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_service.g.dart';

@riverpod
SupabaseClient supabaseService(Ref _) {
  return Supabase.instance.client;
}

// Checks if supabase is reachable or not before attempting operations
@riverpod
Future<bool> supabaseHealthCheck(Ref ref) async {
  final client = ref.watch(supabaseServiceProvider);
  try {
    await client.auth.getUser();
    return true;
  } catch (e) {
    return false;
  }
}