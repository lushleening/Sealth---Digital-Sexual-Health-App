import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_service.g.dart';

@riverpod
SupabaseClient supabaseService(Ref _) {
  return Supabase.instance.client;
}
