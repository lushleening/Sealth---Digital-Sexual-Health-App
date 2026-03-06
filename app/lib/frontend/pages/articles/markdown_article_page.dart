import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';

class MarkdownArticlePage extends StatelessWidget {
  final String markdownPath;

  const MarkdownArticlePage({super.key, required this.markdownPath});

  Future<String> _loadMarkdown() async {
    return await rootBundle.loadString(markdownPath);
  }

  @override
  Widget build(BuildContext context) {
    return SafeContainer(
      child: FutureBuilder<String>(
        future: _loadMarkdown(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingCircleMainColor();
          }

          return Padding(
            padding: const EdgeInsets.all(baseLength),
            child: Markdown(
              data: snapshot.data!,
              styleSheet: MarkdownStyleSheet(
                h1: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
                p: TextStyle(fontSize: 16, color: context.colors.textPrimary),
              ),
            ),
          );
        },
      ),
    );
  }
}
