import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/navigation/main_page_route/main_page_route.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/navigation/safer_navigation/safer_navigation.dart';
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
            seeMorelinkedPage: MainPageRoute.article,
            btnKey: KBtn.newArticle,
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
        separatorBuilder: (_, _) => const SizedBox(width: baseLength / 2),
        itemBuilder: (context, index) {
          return NewArticleCard(article: articles[index]);
        },
      ),
    );
  }
}

class NewArticleCard extends StatelessWidget {
  final Article article;

  const NewArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return GestureDetector(
          onTap: () => dualNavPush(
            context,
            ref,
            toMainPage: MainPageRoute.article,
            toSubPage: article.linkToSubpage,
          ),
          child: SizedBox(
            width: 150,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(6),
              ),
              clipBehavior: Clip.antiAlias,
              elevation: 2,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      article.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: context.colors.whiteBackground,
                      padding: EdgeInsetsGeometry.all(baseLength / 4),
                      child: Text(
                        article.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(color: context.colors.textPrimary),
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
