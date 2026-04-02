import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/backend/articles/providers/article_filter_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/article_search_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/bookmarks_provider.dart';
import 'package:test/test.dart';

void main() {
  test("toggleBookmark adds article when not bookmarked", () {
    final container = ProviderContainer();

    final article = Article(
      articleId: "1",
      authorId: "1",
      title: "Test",
      content: "Test content",
      image: "",
      markdownUrl: "",
      category: "General",
      linkToSubpage: const SizedBox(),
    );

    container.read(bookmarksProvider.notifier).toggleBookmark(article);

    final bookmarks = container.read(bookmarksProvider);

    expect(bookmarks.contains(article), true);
  });

  test("toggleBookmark removes article when already bookmarked", () {
    final container = ProviderContainer();

    final article = Article(
      articleId: "1",
      authorId: "1",
      title: "Test",
      content: "Test",
      image: "",
      markdownUrl: "",
      category: "General",
      linkToSubpage: const SizedBox(),
    );

    container.read(bookmarksProvider.notifier).toggleBookmark(article);
    container.read(bookmarksProvider.notifier).toggleBookmark(article);

    final bookmarks = container.read(bookmarksProvider);

    expect(bookmarks.isEmpty, true);
  });

  test("search provider updates query", () {
    final container = ProviderContainer();

    container.read(articleSearchProvider.notifier).setSearch("HIV");

    final query = container.read(articleSearchProvider);

    expect(query, "hiv");
  });

  test("filter provider updates category", () {
    final container = ProviderContainer();

    container.read(articleFilterProvider.notifier).setFilter("Testing");

    final filter = container.read(articleFilterProvider);

    expect(filter, "Testing");
  });
}
