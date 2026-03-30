import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/articles/providers/bookmarks_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/articles_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MarkdownArticlePage extends ConsumerStatefulWidget {
  final String markdownPath;
  final Article article;
  final String category;
  final String markdownUrl;
  final String thumbnailUrl;

  const MarkdownArticlePage({
    super.key,
    required this.markdownPath,
    required this.article,
    required this.category,
    required this.markdownUrl,
    required this.thumbnailUrl,
  });

  @override
  ConsumerState<MarkdownArticlePage> createState() =>
      _MarkdownArticlePageState();
}

class _MarkdownArticlePageState extends ConsumerState<MarkdownArticlePage> {
  late final supabase = ref.watch(supabaseServiceProvider);

  String markdownData = "";
  List<String> takeaways = [];
  String remainingMarkdown = "";

  @override
  void initState() {
    super.initState();
    loadMarkdown();
  }

  Future<void> loadMarkdown() async {
    String data;

    // Supabase
    if (widget.markdownPath.startsWith("http")) {
      final response = await http.get(Uri.parse(widget.markdownPath));
      if (response.statusCode != 200) {
        throw Exception("Failed to load markdown from Supabase");
      }
      data = response.body;
    }

    // Local asset (assets/articles)
    else if (widget.markdownPath.startsWith("assets/")) {
      data = await rootBundle.loadString(widget.markdownPath);
    }

    // Local file (desktop testing)
    else {
      data = await File(widget.markdownPath).readAsString();
    }

    final lines = data.split("\n");

    bool inTakeaways = false;
    List<String> takeawaysTemp = [];
    List<String> remaining = [];

    for (final line in lines) {
      if (line.contains("Key Takeaways")) {
        inTakeaways = true;
        continue;
      }

      if (inTakeaways && line.startsWith("-")) {
        takeawaysTemp.add(line.replaceFirst("-", "").trim());
      } else {
        inTakeaways = false;
        remaining.add(line);
      }
    }

    setState(() {
      takeaways = takeawaysTemp;
      remainingMarkdown = remaining.join("\n");
      markdownData = data;
    });
  }

  bool get _isAuthor {
    final currentUserId = supabase.auth.currentUser?.id;
    return currentUserId != null &&
        widget.article.authorId != null &&
        currentUserId == widget.article.authorId;
  }

  Future<void> _deleteArticle() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Article"),
        content: const Text(
          "Are you sure you want to delete this article? This cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await supabase
          .from('articles')
          .delete()
          .eq('id', widget.article.articleId!);

      ref
          .read(articlesProvider.notifier)
          .removeArticle(widget.article.articleId!);

      showSnackbarMessage("Article deleted");

      if (!mounted) return;
      context.pop();
    } catch (e) {
      showSnackbarMessage("Failed to delete article");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = ref.watch(bookmarksProvider);
    final isSaved = bookmarks.any((a) => a.title == widget.article.title);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: () {
              ref
                  .read(bookmarksProvider.notifier)
                  .toggleBookmark(widget.article);
            },
          ),

          // Show edit/delete only for the author
          if (_isAuthor)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                if (value == 'edit') {
                  context.push(AppRoute.articleEdit, extra: {
                    'article': widget.article,
                    'category': widget.category,
                    'markdownUrl': widget.markdownUrl,
                    'thumbnailUrl': widget.thumbnailUrl,
                  });
                } else if (value == 'delete') {
                  _deleteArticle();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),

      body: markdownData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.colors.articlehashtagBlueBorder,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.category,
                      style: TextStyle(
                        color: context.colors.articlehashtagBlueText,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    widget.article.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Key Takeaways Box
                  if (takeaways.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.colors.articlehashtagBlueBorder,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Key Takeaways",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: context.colors.articlehashtagBlueText,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...takeaways.map(
                            (t) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("• ", style: TextStyle(color: context.colors.articlehashtagBlueText)),
                                  Expanded(child: Text(
                                    t,
                                    style: TextStyle(color: context.colors.articlehashtagBlueText),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Markdown content
                  MarkdownBody(
                    data: remainingMarkdown,
                    onTapLink: (text, href, title) async {
                      if (href != null) {
                        final uri = Uri.parse(href);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      }
                    },
                    styleSheet: MarkdownStyleSheet(
                      h2: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      p: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}