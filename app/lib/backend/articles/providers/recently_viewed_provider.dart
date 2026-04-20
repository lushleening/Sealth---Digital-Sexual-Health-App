import 'package:flutter_riverpod/legacy.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/recently_viewed_articles_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _maxItems = 10;
const _supabaseTable = 'recently_viewed_articles';

class RecentlyViewedNotifier extends StateNotifier<List<String>> {
  final RecentlyViewedArticlesDAO _dao;
  final String _localId;
  final String? _remoteId;
  final SupabaseClient? _supabase;

  RecentlyViewedNotifier({
    required RecentlyViewedArticlesDAO dao,
    required String localId,
    String? remoteId,
    SupabaseClient? supabase,
  })  : _dao = dao,
        _localId = localId,
        _remoteId = remoteId,
        _supabase = supabase,
        super([]) {
    _load();
  }

  Future<void> _load() async {
    final localIds = await _dao.getRecentlyViewed(_localId);

    // For registered users, merge local with Supabase (remote wins for ordering)
    if (_remoteId != null && _supabase != null) {
      try {
        final rows = await _supabase
            .from(_supabaseTable)
            .select('article_id, viewed_at')
            .eq('user_id', _remoteId)
            .order('viewed_at', ascending: false)
            .limit(_maxItems);

        final remoteIds =
            (rows as List).map((r) => r['article_id'] as String).toList();

        // Write any remote entries missing from local DB
        for (final id in remoteIds) {
          if (!localIds.contains(id)) {
            await _dao.upsertViewed(_localId, id);
          }
        }

        // Merge: remote order first, then any local-only entries
        final merged = [
          ...remoteIds,
          ...localIds.where((id) => !remoteIds.contains(id)),
        ].take(_maxItems).toList();

        if (mounted) state = merged;
        return;
      } catch (_) {
        // Fall through to local-only on network error
      }
    }

    if (mounted) state = localIds;
  }

  Future<void> markViewed(String? articleId) async {
    if (articleId == null) return;
    await _dao.upsertViewed(_localId, articleId);

    if (_remoteId != null && _supabase != null) {
      try {
        await _supabase.from(_supabaseTable).upsert({
          'user_id': _remoteId,
          'article_id': articleId,
          'viewed_at': DateTime.now().toIso8601String(),
        });
      } catch (_) {
        // Local write succeeded; remote failure is non-critical
      }
    }

    final updated = [articleId, ...state.where((id) => id != articleId)];
    if (mounted) state = updated.take(_maxItems).toList();
  }
}

/// Rebuilds whenever the current user changes (sign in / sign out),
/// loading that user's history from the local DB (and Supabase if registered).
final recentlyViewedProvider =
    StateNotifierProvider<RecentlyViewedNotifier, List<String>>((ref) {
  final appUser = ref.watch(appUserProvider).value;
  final localId = appUser?.localId ?? '';
  final remoteId = appUser?.remoteId;
  final dao = RecentlyViewedArticlesDAO(ref.read(databaseProvider));
  final supabase = remoteId != null ? ref.read(supabaseServiceProvider) : null;
  return RecentlyViewedNotifier(
    dao: dao,
    localId: localId,
    remoteId: remoteId,
    supabase: supabase,
  );
});