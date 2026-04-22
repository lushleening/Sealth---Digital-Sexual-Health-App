import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';

class ArticlesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final Ref ref;

  static const int _batchSize = 10;
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoading = false;

  ArticlesNotifier({required this.ref}) : super([]) {
    loadArticlesFromSupabase();
  }

  // Replace to facilitate testing, but u better of using notifier provider
  SupabaseClient get supabase => ref.read(supabaseServiceProvider);

  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;

  Future<void> refreshArticles() async {
    await loadArticlesFromSupabase();
  }

  // Load initial batch from Supabase DB
  Future<void> loadArticlesFromSupabase() async {
    _isLoading = true;
    _offset = 0;
    _hasMore = true;

    final response = await supabase
        .from('articles')
        .select()
        .order('created_at', ascending: false)
        .range(0, _batchSize - 1);

    final loaded = _parseArticles(response);

    if (!mounted) return;
    _offset = loaded.length;
    _hasMore = loaded.length == _batchSize;
    state = loaded;
    _isLoading = false;
  }

  // Append the next batch (called when user scrolls near bottom)
  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;

    final response = await supabase
        .from('articles')
        .select()
        .order('created_at', ascending: false)
        .range(_offset, _offset + _batchSize - 1);

    if (!mounted) return;
    final loaded = _parseArticles(response);
    _offset += loaded.length;
    _hasMore = loaded.length == _batchSize;
    state = [...state, ...loaded];
    _isLoading = false;
  }

  List<Map<String, dynamic>> _parseArticles(List<dynamic> response) {
    return response.map((row) {
      final category = row["category"] ?? '';
      final article = Article(
        articleId: row["id"].toString(),
        authorId: row["author_id"],
        title: row["title"],
        content: row["description"] ?? "",
        image: row["thumbnail_url"] ?? "assets/images/placeholder.png",
        markdownUrl: row["markdown_url"],
        category: category,
        linkToSubpage: const SizedBox(),
      );
      return {"article": article, "category": category};
    }).toList();
  }

  // Add article locally (after upload)
  void addArticle({required Article article, required String category}) {
    state = [
      {"article": article, "category": category},
      ...state,
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
        return {"article": updatedArticle, "category": category};
      }
      return articleData;
    }).toList();
  }
}

final articlesProvider =
    StateNotifierProvider<ArticlesNotifier, List<Map<String, dynamic>>>(
      (ref) => ArticlesNotifier(ref: ref),
    );