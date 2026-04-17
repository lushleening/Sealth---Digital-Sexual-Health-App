import 'package:flutter_riverpod/legacy.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/recently_viewed_articles_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

class RecentlyViewedNotifier extends StateNotifier<List<String>> {
  final RecentlyViewedArticlesDAO _dao;
  final String _localId;

  RecentlyViewedNotifier({
    required RecentlyViewedArticlesDAO dao,
    required String localId,
  })  : _dao = dao,
        _localId = localId,
        super([]) {
    _load();
  }

  Future<void> _load() async {
    final ids = await _dao.getRecentlyViewed(_localId);
    if (mounted) state = ids;
  }

  Future<void> markViewed(String? articleId) async {
    if (articleId == null) return;
    await _dao.upsertViewed(_localId, articleId);
    final updated = [articleId, ...state.where((id) => id != articleId)];
    if (mounted) state = updated.take(10).toList();
  }
}

/// Rebuilds whenever the current user changes (sign in / sign out),
/// loading that user's history from the local DB.
final recentlyViewedProvider =
    StateNotifierProvider<RecentlyViewedNotifier, List<String>>((ref) {
  final localId = ref.watch(appUserProvider).value?.localId ?? '';
  final dao = RecentlyViewedArticlesDAO(ref.read(databaseProvider));
  return RecentlyViewedNotifier(dao: dao, localId: localId);
});