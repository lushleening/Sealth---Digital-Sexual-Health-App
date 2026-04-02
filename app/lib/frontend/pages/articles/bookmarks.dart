import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/articles/providers/bookmarks_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';

class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedArticles = ref.watch(bookmarksProvider);

    return Scaffold(
      body: SafeContainer(
        child: Padding(
          padding: const EdgeInsets.all(baseLength),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BookmarksHeader(),
              const SizedBox(height: 20),

              if (bookmarkedArticles.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      "No bookmarked articles yet.",
                      style: TextStyle(color: context.colors.textSecondary),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: bookmarkedArticles.length,
                    itemBuilder: (context, index) {
                      final article = bookmarkedArticles[index];
                      return _BookmarkCard(article: article);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookmarksHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.textPrimary),
          onPressed: () => context.pop(),
        ),
        const SizedBox(width: 8),
        Text(
          "Bookmarks",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: context.colors.textPrimary),
        ),
      ],
    );
  }
}

class _BookmarkCard extends ConsumerWidget {
  final Article article;

  const _BookmarkCard({required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (article.markdownUrl != null) {
          context.push(AppRoute.articleView, extra: {
            'article': article,
            'category': article.category,
            'markdownUrl': article.markdownUrl!,
            'thumbnailUrl': article.image,
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.whiteBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.colors.boxShadowGray.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: article.image.startsWith("http")
                  ? Image.network(
                      article.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade200,
                        child: Icon(Icons.broken_image,
                            color: Colors.grey.shade400),
                      ),
                    )
                  : article.image.startsWith("assets/")
                      ? Image.asset(
                          article.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(article.image),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                article.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.colors.textPrimary,
                    ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.bookmark, color: context.colors.mainColor),
              onPressed: () {
                ref.read(bookmarksProvider.notifier).toggleBookmark(article);
              },
            ),
          ],
        ),
      ),
    );
  }
}