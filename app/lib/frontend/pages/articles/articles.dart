//Articles Page
//Display list of articles with search + filtering + bookmarking

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/constants/assets.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/backend/articles/providers/articles_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/bookmarks_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/article_filter_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/article_search_provider.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeContainer(
        child: Padding(
          padding: const EdgeInsets.all(baseLength),
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

class _ArticlesHeader extends ConsumerWidget {
  const _ArticlesHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userContextProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.directional(start: 16, end: 16, top: 8),
          child: Text(
            "Articles",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: context.colors.textPrimary),
          ),
        ),
        Row(
          children: [
            // Upload button — visible to all, but only verified users can proceed
            userState.when(
              data: (up) {
                final isVerified =
                    up.isRegisteredUser &&
                    up.profile != null &&
                    up.profile!.verified;

                return GestureDetector(
                  key: KBtn.navNewArticles.key, // TODO get a new key
                  onTap: () {
                    if (isVerified) {
                      context.push(AppRoute.articleUpload);
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Verification Required"),
                          content: const Text(
                            "Only verified medical professionals can upload articles.\n\n"
                            "To request verification, please email us and we will review your application.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: context.colors.mainColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final userContext = ref.read(userContextProvider);
                                final remoteId = userContext.whenData((u) => u.user.remoteId).value ?? 'Unknown';
                                final subject = Uri.encodeComponent('Article Upload Verification Request');
                                final body = Uri.encodeComponent(
                                  'Hi,\n\nI would like to request verification to upload articles on Sealth.\n\nName:\nProfession:\nOrganisation:\nUser ID: $remoteId\n',
                                  );
                                  final uri = Uri.parse('mailto:$supportEmail?subject=$subject&body=$body');
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  }
                                    if (ctx.mounted) Navigator.of(ctx).pop();
                              },
                                    child: Text(
                                      "Email Us",
                                      style: TextStyle(
                                        color: context.colors.mainColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Icon(Icons.add, color: context.colors.mainColor),
                );
              },
              loading: () => const SizedBox(),
              error: (error, stackTrace) => const SizedBox(),
            ),

            const SizedBox(width: 12),

            Padding(
              padding: EdgeInsetsGeometry.directional(end: 8),
              child: GestureDetector(
                key: KBtn.navBookmarkBtn.key,
                onTap: () => context.push(AppRoute.articleBookmarks),
                child: Icon(Icons.bookmark, color: context.colors.mainColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SearchSection extends ConsumerWidget {
  const _SearchSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: context.colors.whiteBackground,
          padding: const EdgeInsetsGeometry.symmetric(
            vertical: 4,
            horizontal: 4,
          ),
          child: TextField(
            onChanged: (value) {
              ref.read(articleSearchProvider.notifier).setSearch(value);
            },
            style: TextStyle(color: context.colors.textPrimary),
            decoration: InputDecoration(
              hintText: "Search articles...",
              hintStyle: TextStyle(color: context.colors.textSecondary),
              prefixIcon: Icon(
                Icons.search,
                color: context.colors.textSecondary,
              ),
              filled: true,
              fillColor: context.colors.textBoxFill,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

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
                spacing: 6,
                children: [
                  Icon(
                    Icons.filter_list,
                    size: 18,
                    color: context.colors.textSecondary,
                  ),
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

class _ArticlesList extends ConsumerWidget {
  const _ArticlesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(articleFilterProvider);
    final searchQuery = ref.watch(articleSearchProvider);
    final allArticles = ref.watch(articlesProvider);

    final filteredArticles = allArticles.where((articleData) {
      final Article article = articleData["article"];
      final String category = articleData["category"];

      final matchesCategory =
          selectedCategory == null || category == selectedCategory;

      final matchesSearch = article.title.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      return matchesCategory && matchesSearch;
    }).toList();

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

class _ArticleCard extends ConsumerWidget {
  final Article article;
  final String category;

  const _ArticleCard({required this.article, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarksProvider);
    final isSaved = bookmarks.any((a) => a.title == article.title);

    return GestureDetector(
      key: KBtn.articleCard.key,
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
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey.shade400,
                        ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 6),

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

class _FilterBottomSheet extends ConsumerWidget {
  const _FilterBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(articleFilterProvider);

    final categories = [
      null,
      "General",
      "Multiple Partners",
      "LGBTQ+",
      "Testing",
      "Prevention",
      "Treatment",
    ];

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
                      context.pop();
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
