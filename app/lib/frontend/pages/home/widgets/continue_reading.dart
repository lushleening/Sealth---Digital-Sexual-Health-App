import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/navigation/main_page_route/main_page_route.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/navigation/safer_navigation/safer_navigation.dart';
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
              seeMorelinkedPage: MainPageRoute.article,
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
          onTap: () => dualNavPush(
            context,
            ref,
            toMainPage: MainPageRoute.article,
            toSubPage: article.linkToSubpage,
          ),
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
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(color: context.colors.textPrimary),
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
                        child: Image.asset(article.image, fit: BoxFit.cover),
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
