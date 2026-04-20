import 'package:flutter_riverpod/legacy.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _bookmarksTable = 'bookmarks';

class BookmarksNotifier extends StateNotifier<List<String>> {
  final String? _remoteId;
  final SupabaseClient? _supabase;

  BookmarksNotifier({String? remoteId, SupabaseClient? supabase})
      : _remoteId = remoteId,
        _supabase = supabase,
        super([]) {
    _load();
  }

  Future<void> _load() async {
    if (_remoteId == null || _supabase == null) return;
    try {
      final rows = await _supabase
          .from(_bookmarksTable)
          .select('article_id')
          .eq('user_id', _remoteId);
      final ids = (rows as List).map((r) => r['article_id'] as String).toList();
      if (mounted) state = ids;
    } catch (_) {}
  }

  Future<void> toggleBookmark(Article article) async {
    final id = article.articleId;
    if (id == null) return;

    final already = state.contains(id);
    if (already) {
      state = state.where((s) => s != id).toList();
      if (_remoteId != null && _supabase != null) {
        try {
          await _supabase
              .from(_bookmarksTable)
              .delete()
              .eq('user_id', _remoteId)
              .eq('article_id', id);
        } catch (_) {}
      }
    } else {
      state = [...state, id];
      if (_remoteId != null && _supabase != null) {
        try {
          await _supabase.from(_bookmarksTable).upsert({
            'user_id': _remoteId,
            'article_id': id,
          });
        } catch (_) {}
      }
    }
  }

  bool isBookmarked(Article article) => state.contains(article.articleId);
}

// Scoped to the current user — resets on user change, syncs to Supabase for
// registered users so bookmarks persist across devices and sessions.
final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, List<String>>((ref) {
  final appUser = ref.watch(appUserProvider).value;
  final remoteId = appUser?.remoteId;
  final supabase = remoteId != null ? ref.read(supabaseServiceProvider) : null;
  return BookmarksNotifier(remoteId: remoteId, supabase: supabase);
});