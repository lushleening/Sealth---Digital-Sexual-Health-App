import 'package:flutter_riverpod/legacy.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';

class BookmarksNotifier extends StateNotifier<List<Article>> {
  BookmarksNotifier() : super([]);

  void toggleBookmark(Article article) {
    final exists = state.any((a) => a.title == article.title);

    if (exists) {
      state = state.where((a) => a.title != article.title).toList();
    } else {
      state = [...state, article];
    }
  }

  bool isBookmarked(Article article) {
    return state.any((a) => a.title == article.title);
  }
}

final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, List<Article>>(
      (ref) => BookmarksNotifier(),
    );
