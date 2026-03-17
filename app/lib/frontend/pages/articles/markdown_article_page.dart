import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/articles/providers/bookmarks_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class MarkdownArticlePage extends ConsumerStatefulWidget {
  final String markdownPath;
  final Article article;
  final String category;

  const MarkdownArticlePage({
    super.key,
    required this.markdownPath,
    required this.article,
    required this.category,
  });

  @override
  ConsumerState<MarkdownArticlePage> createState() =>
      _MarkdownArticlePageState();
}

class _MarkdownArticlePageState extends ConsumerState<MarkdownArticlePage> {

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

    //Supabase
    if (widget.markdownPath.startsWith("http")) {

      final response = await http.get(Uri.parse(widget.markdownPath));

      if (response.statusCode != 200) {
        throw Exception("Failed to load markdown from Supabase");
      }

      data = response.body;

    }

    //Local asset (assets/articles)
    else if (widget.markdownPath.startsWith("assets/")) {

      data = await rootBundle.loadString(widget.markdownPath);

    }

    //Local file (desktop testing)
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
      } 
      else {
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
              ref.read(bookmarksProvider.notifier)
                  .toggleBookmark(widget.article);
            },
          )
        ],
      ),

      body: markdownData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //Category tag
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

                  //Title
                  Text(
                    widget.article.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  //Key Takeaways Box
                  if (takeaways.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCEAF7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Key Takeaways",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 10),

                          ...takeaways.map(
                            (t) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("• "),
                                  Expanded(child: Text(t)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  //Markdown content
                  MarkdownBody(
                    data: remainingMarkdown,
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