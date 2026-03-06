import 'package:flutter_riverpod/legacy.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';

class BookmarksNotifier extends StateNotifier<List<Article>> {
  BookmarksNotifier() : super([]);

  void toggleBookmark(Article article) {
    if (state.contains(article)) {
      state = state.where((a) => a != article).toList();
    } else {
      state = [...state, article];
    }
  }

  bool isBookmarked(Article article) {
    return state.contains(article);
  }
}

final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, List<Article>>(
      (ref) => BookmarksNotifier(),
    );
