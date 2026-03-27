import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/supabase.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_errors.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_db_fetcher.g.dart';

// Provider
@Riverpod(keepAlive: true)
SupabaseDBFetcher supabaseDBFetcher(Ref ref) {
  return SupabaseDBFetcher(client: ref.watch(supabaseServiceProvider));
}

// Fetches data from remote -> local db
class SupabaseDBFetcher {
  final SupabaseClient client;
  SupabaseDBFetcher({required this.client});

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
      final data = await client
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

  Future<List<T>> fetchAllWithRemoteId<T extends Syncable>(
    String remoteId,
    FetchTools<T> f,
  ) async => fetchAllWithColumn(remoteIdColName, remoteId, f);

  Future<List<T>> fetchAllWithColumn<T extends Syncable>(
    String columnName,
    String value,
    FetchTools<T> f,
  ) async {
    try {
      final data = await client
          .from(f.table.effectiveRemoteTableName)
          .select()
          .eq(columnName, value);
      return (data as List)
          .map((e) => f.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      handleSupaDBErrors(e);
    }
    return [];
  }
}
