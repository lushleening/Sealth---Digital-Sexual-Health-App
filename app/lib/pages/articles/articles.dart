//Articles Page
//displays list of articles with filtering + bookmarking

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/common_widgets/safe_container.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/helper/safe_nav.dart';
import 'package:sddp_dsh/objects/article.dart';
import 'package:sddp_dsh/pages/articles/upload_article.dart';
import 'package:sddp_dsh/providers/articles_provider.dart';
import 'package:sddp_dsh/providers/bookmarks_provider.dart';
import 'package:sddp_dsh/providers/article_filter_provider.dart';
import 'package:sddp_dsh/testing/key_enum.dart';
import 'bookmarks.dart';

//Main Articles Page
class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeContainer(
        child: Padding(
          padding: const EdgeInsets.all(basePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ArticlesHeader(),
              SizedBox(height: 20),
              _SearchSection(),
              SizedBox(height: 20),
              Expanded(child: _ArticlesList()),
            ],
          ),
        ),
      ),
    );
  }
}

//Header Section
//Contains page title + upload + bookmark navigation
class _ArticlesHeader extends ConsumerWidget {
  const _ArticlesHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Articles",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: context.colors.textPrimary),
        ),
        Row(
          children: [
            // Upload button
            GestureDetector(
              key: KBtn.newArticle.key,
              onTap: () {
                navPush(
                  context,
                  ref,
                  UploadArticlePage(key: KPage.uploadArticle.key),
                );
              },
              child: Icon(Icons.add, color: context.colors.mainColor),
            ),

            const SizedBox(width: 12),

            // Bookmark button
            GestureDetector(
              key: KBtn.navBookmarkBtn.key,
              onTap: () {
                navPush(context, ref, const BookmarksPage());
              },
              child: Icon(
                Icons.bookmark_border,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

//Search + Filter Section
class _SearchSection extends StatelessWidget {
  const _SearchSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Search Bar UI (search logic not implemented yet)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: context.colors.textBoxFill,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: context.colors.textBoxIcon),
              hintText: "Search articles...",
              hintStyle: TextStyle(color: context.colors.textSecondary),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 12),

        //opens bottom sheet filter
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => const _FilterBottomSheet(),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: context.colors.grayBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: context.colors.buttonBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_list,
                    size: 18,
                    color: context.colors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Filters",
                    style: TextStyle(color: context.colors.textPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//Articles List Section
//Uses Riverpod providers for state
class _ArticlesList extends ConsumerWidget {
  const _ArticlesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(articleFilterProvider);

    final allArticles = ref.watch(articlesProvider);

    //apply filter logic
    final filteredArticles = selectedCategory == null
        ? allArticles
        : allArticles
              .where(
                (articleData) => articleData["category"] == selectedCategory,
              )
              .toList();

    return ListView.builder(
      itemCount: filteredArticles.length,
      itemBuilder: (context, index) {
        final articleData = filteredArticles[index];
        final Article article = articleData["article"];
        final String category = articleData["category"];

        return _ArticleCard(article: article, category: category);
      },
    );
  }
}

//Individual Article Card
//handles navigation to article reader
class _ArticleCard extends ConsumerWidget {
  final Article article;
  final String category;

  const _ArticleCard({required this.article, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(bookmarksProvider).contains(article);

    return GestureDetector(
      key: KBtn.articleCard.key,
      onTap: () {
        //safe navigation to article reader page
        navPush(context, ref, article.linkToSubpage);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.whiteBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                article.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            //Article Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),

                  //category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.articlehashtagBlueBorder,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: context.colors.articlehashtagBlueText,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    article.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.colors.textSecondary),
                  ),
                ],
              ),
            ),

            //bookmark toggle button
            IconButton(
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: isSaved
                    ? context.colors.mainColor
                    : context.colors.textSecondary,
              ),
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

//Filter Bottom Sheet
//Allows selecting article category
class _FilterBottomSheet extends ConsumerWidget {
  const _FilterBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(articleFilterProvider);

    final categories = [null, "General", "Multiple Partners", "LGBTQ+"];

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.colors.whiteBackground,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                const Text(
                  "Filter by Category",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                ...categories.map((category) {
                  final isSelected = selectedCategory == category;

                  return ListTile(
                    title: Text(category ?? "All"),
                    trailing: isSelected
                        ? Icon(Icons.check, color: context.colors.mainColor)
                        : null,
                    onTap: () {
                      ref
                          .read(articleFilterProvider.notifier)
                          .setFilter(category);
                      navPop(context, ref);
                    },
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
