import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/supabase.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_errors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_db_fetcher.g.dart';

// Provider
@Riverpod(keepAlive: true)
SupabaseDBFetcher supabaseDBFetcher(Ref ref) {
  return SupabaseDBFetcher();
}

// Fetches data from remote -> local db
class SupabaseDBFetcher {
  final _client = Supabase.instance.client;

  Future<T> fetchSingle<T extends Syncable>(
    String remoteId,
    FetchTools<T> f,
  ) async {
    final data = await fetchMaybeSingle(remoteId, f);
    if (data == null) throw Exception("Fetching data by fetchSingle failed");
    return data;
  }

  Future<T?> fetchMaybeSingle<T extends Syncable>(
    String remoteId,
    FetchTools<T> f,
  ) async {
    try {
      final data = await _client
          .from(f.table.effectiveRemoteTableName)
          .select()
          .eq(remoteIdColName, remoteId)
          .maybeSingle();
      if (data != null) return f.fromJson(data);
    } catch (e) {
      handleSupaDBErrors(e);
    }
    return null;
  }

  Future<List<T>> fetchAll<T extends Syncable>(
    String remoteId,
    FetchTools<T> f,
  ) async {
    try {
      final data = await _client
          .from(f.table.effectiveRemoteTableName)
          .select()
          .eq(remoteIdColName, remoteId);
      return (data as List)
          .map((e) => f.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      handleSupaDBErrors(e);
    }
    return [];
  }
}
