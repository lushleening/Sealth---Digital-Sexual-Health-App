import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/safe_nav.dart';
import 'package:sddp_dsh/testing/key_enum.dart';

// Article Reader Page
// Displays full article content
class ArticleReaderPage extends ConsumerWidget {
  final String title;
  final String content;

  const ArticleReaderPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: KPage.article.key,

      // AppBar with safe back navigation
      appBar: AppBar(
        backgroundColor: context.colors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),

        // Back button using safe navigation
        leading: IconButton(
          key: KBtn.backButton.key, // testable back button
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navPop(context, ref);
          },
        ),
      ),

      //Scrollable article content
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(content, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
