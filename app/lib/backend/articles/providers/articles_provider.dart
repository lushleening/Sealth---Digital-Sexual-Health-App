import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/frontend/pages/articles/markdown_article_page.dart';

class ArticlesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  ArticlesNotifier() : super([]) {
    loadArticlesFromSupabase();
  }

  final supabase = Supabase.instance.client;

  //Load articles from Supabase DB
  Future<void> loadArticlesFromSupabase() async {
    final response = await supabase
        .from('articles')
        .select()
        .order('created_at', ascending: false);

    final List<Map<String, dynamic>> loadedArticles = [];

    for (final row in response) {
      final article = Article(
        title: row["title"],
        content: row["description"] ?? "",
        image: row["thumbnail_url"] ?? "assets/images/placeholder.png",
        linkToSubpage: MarkdownArticlePage(
          markdownPath: row["markdown_url"],
          article: Article(
            title: row["title"],
            content: row["description"] ?? "",
            image: row["thumbnail_url"] ?? "assets/images/placeholder.png",
            linkToSubpage: const SizedBox(),
          ),
          category: row["category"],
        ),
      );

      loadedArticles.add({
        "article": article,
        "category": row["category"],
      });
    }

    state = loadedArticles;
  }

  //Add article locally (after upload)
  void addArticle({
    required Article article,
    required String category,
  }) {
    state = [
      {
        "article": article,
        "category": category,
      },
      ...state
    ];
  }
}

final articlesProvider =
    StateNotifierProvider<ArticlesNotifier, List<Map<String, dynamic>>>(
  (ref) => ArticlesNotifier(),
);