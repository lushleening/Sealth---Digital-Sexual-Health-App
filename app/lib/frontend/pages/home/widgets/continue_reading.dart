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

// Articles that haven't been finished
class ContinueReading extends StatelessWidget {
  final List<Article> continueReadingArticles;
  const ContinueReading({super.key, required this.continueReadingArticles});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.grayBackground,
      child: Padding(
        padding: EdgeInsetsGeometry.all(baseLength),
        child: Column(
          children: [
            HomeSectionHeader(
              title: 'Continue Reading',
              seeMorelinkedPage: '/articles',
              btnKey: KBtn.continueReadingArticle,
            ),
            ContinueReadingCards(articles: continueReadingArticles),
          ],
        ),
      ),
    );
  }
}

class ContinueReadingCards extends StatelessWidget {
  final List<Article> articles;

  const ContinueReadingCards({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: articles
          .map((article) => ContinueReadingCard(article: article))
          .toList(),
    );
  }
}

class ContinueReadingCard extends StatelessWidget {
  final Article article;

  const ContinueReadingCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("Continue Reading Card generated.");
    return Consumer(
      builder: (context, ref, _) {
        return GestureDetector(
          onTap: () {
            if (article.markdownUrl != null) {
              context.push(AppRoutes.articleViewP, extra: {
                'article': article,
                'category': article.category,
                'markdownUrl': article.markdownUrl!,
                'thumbnailUrl': article.image,
              });
            }
          },
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: baseLength / 4),
            child: Container(
              padding: const EdgeInsetsGeometry.all(baseLength),
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
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: context.colors.textPrimary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          article.content,
                          style:
                              TextStyle(color: context.colors.textSecondary),
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
      },
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