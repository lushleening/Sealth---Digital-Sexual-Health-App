import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';

class ArticlesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final Ref ref;

  ArticlesNotifier({required this.ref}) : super([]) {
    loadArticlesFromSupabase();
  }

  // Replace to facilitate testing, but u better of using notifier provider
  SupabaseClient get supabase => ref.read(supabaseServiceProvider);

  Future<void> refreshArticles() async {
    await loadArticlesFromSupabase();
  }

  // Load articles from Supabase DB
  Future<void> loadArticlesFromSupabase() async {
    final response = await supabase
        .from('articles')
        .select()
        .order('created_at', ascending: false);

    final List<Map<String, dynamic>> loadedArticles = [];

    for (final row in response) {
      final article = Article(
        articleId: row["id"].toString(),
        authorId: row["author_id"],
        title: row["title"],
        content: row["description"] ?? "",
        image: row["thumbnail_url"] ?? "assets/images/placeholder.png",
        linkToSubpage: 'TODO'
        // MarkdownArticlePage(
        //   markdownPath: row["markdown_url"],
        //   article: Article(
        //     articleId: row["id"].toString(),
        //     authorId: row["author_id"],
        //     title: row["title"],
        //     content: row["description"] ?? "",
        //     image: row["thumbnail_url"] ?? "assets/images/placeholder.png",
        //     linkToSubpage: const SizedBox(),
        //   ),
        //   category: row["category"],
        //   markdownUrl: row["markdown_url"],
        //   thumbnailUrl: row["thumbnail_url"] ?? "assets/images/placeholder.png",
        // ),
      );

      loadedArticles.add({
        "article": article,
        "category": row["category"],
      });
    }

    state = loadedArticles;
  }

  // Add article locally (after upload)
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

  // Remove article locally (after delete)
  void removeArticle(String articleId) {
    state = state.where((articleData) {
      final Article article = articleData["article"];
      return article.articleId != articleId;
    }).toList();
  }

  // Update article locally (after edit)
  void updateArticle({
    required String articleId,
    required Article updatedArticle,
    required String category,
  }) {
    state = state.map((articleData) {
      final Article article = articleData["article"];
      if (article.articleId == articleId) {
        return {
          "article": updatedArticle,
          "category": category,
        };
      }
      return articleData;
    }).toList();
  }
}

final articlesProvider =
    StateNotifierProvider<ArticlesNotifier, List<Map<String, dynamic>>>(
  (ref) => ArticlesNotifier(ref: ref),
);