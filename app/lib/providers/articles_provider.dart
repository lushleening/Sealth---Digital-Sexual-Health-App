import 'package:flutter_riverpod/legacy.dart';
import 'package:sddp_dsh/objects/article.dart';

class ArticlesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  ArticlesNotifier() : super(mockArticles);

  void addArticle({required Article article, required String category}) {
    state = [
      {"article": article, "category": category},
      ...state,
    ];
  }
}

final articlesProvider =
    StateNotifierProvider<ArticlesNotifier, List<Map<String, dynamic>>>(
      (ref) => ArticlesNotifier(),
    );
