import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/home_section_header.dart';

// Newly released articles
class NewArticles extends StatelessWidget {
  final List<Article> newArticles;

  const NewArticles({super.key, required this.newArticles});

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("New Articles Section generated.");
    return Container(
      padding: EdgeInsetsGeometry.all(baseLength),
      color: context.colors.grayBackground,
      child: Column(
        children: [
          HomeSectionHeader(
            title: 'New Articles',
            seeMorelinkedPage: AppRoute.articles,
            btnKey: KBtn.navNewArticles,
          ),
          NewArticleCards(articles: newArticles),
        ],
      ),
    );
  }
}

class NewArticleCards extends StatelessWidget {
  final List<Article> articles;

  const NewArticleCards({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("New Article Cards generated.");
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: articles.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: baseLength / 2),
        itemBuilder: (context, index) {
          return NewArticleCard(article: articles[index]);
        },
      ),
    );
  }
}

class NewArticleCard extends ConsumerWidget {
  final Article article;

  const NewArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        child: SizedBox(
          width: 150,
          child: Card(
            color: context.colors.whiteBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(6),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: _ArticleImage(imageUrl: article.image),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsetsGeometry.all(baseLength / 4),
                    child: Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: context.colors.textPrimary,
                      ),
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
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.shade200,
          child: Icon(Icons.broken_image, color: Colors.grey.shade400),
        ),
      );
    } else if (imageUrl.startsWith("assets/")) {
      return Image.asset(imageUrl, fit: BoxFit.cover, width: double.infinity);
    } else {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
  }
}
