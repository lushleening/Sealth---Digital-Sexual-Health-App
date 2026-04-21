import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/home_section_header.dart';

// Newly released articles
class NewArticles extends StatelessWidget {
  final List<Article> articles;
  const NewArticles({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("New Articles Section generated.");
    return Container(
      color: context.colors.grayBackground,
      child: Padding(
        padding: EdgeInsetsGeometry.all(baseLength),
        child: Column(
          children: [
            HomeSectionHeader(
              title: 'New Articles',
              seeMorelinkedPage: AppRoute.articles,
              btnKey: KBtn.navContinueReadingArticle,
            ),
            _NewArticleCards(articles: articles),
          ],
        ),
      ),
    );
  }
}

class _NewArticleCards extends StatelessWidget {
  final List<Article> articles;

  const _NewArticleCards({required this.articles});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: articles
          .map((article) => _NewArticleCard(article: article))
          .toList(),
    );
  }
}

class _NewArticleCard extends ConsumerWidget {
  final Article article;

  const _NewArticleCard({required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.finer("Continue Reading Card generated.");
    return GestureDetector(
      onTap: () {
        if (article.markdownUrl != null) {
          context.push(
            AppRoute.articleView,
            extra: {
              'article': article,
              'category': article.category,
              'markdownUrl': article.markdownUrl!,
              'thumbnailUrl': article.image,
            },
          );
        }
      },
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: baseLength / 4),
        child: Container(
          padding: const EdgeInsetsGeometry.symmetric(
            vertical: baseLength / 2,
            horizontal: baseLength,
          ),
          decoration: BoxDecoration(
            color: context.colors.whiteBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            spacing: baseLength / 2,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: context.colors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      article.content,
                      style: TextStyle(color: context.colors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 15 / 16,
                    child: _ArticleImage(imageUrl: article.image),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleImage extends StatelessWidget {
  final String imageUrl;

  const _ArticleImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith("http")) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.shade200,
          child: Icon(Icons.broken_image, color: Colors.grey.shade400),
        ),
      );
    } else if (imageUrl.startsWith("assets/")) {
      return Image.asset(imageUrl, fit: BoxFit.cover);
    } else {
      return Image.file(File(imageUrl), fit: BoxFit.cover);
    }
  }
}
