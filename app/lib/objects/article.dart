import 'package:flutter/material.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/common_widgets/safe_container.dart';
import 'package:sddp_dsh/pages/articles/markdown_article_page.dart';

class Article {
  final String title;
  final String content;
  final String image;
  final Widget linkToSubpage;

  const Article({
    required this.title,
    required this.content,
    this.image = placeholderImage,
    required this.linkToSubpage,
  });
}

final List<Map<String, dynamic>> mockArticles = [
  {
    "article": Article(
      title: "Understanding HIV Testing Intervals",
      content: "Learn about recommended testing schedules...",
      image: hivTestingImage,
      linkToSubpage: MarkdownArticlePage(
        markdownPath: "assets/articles/hiv_testing.md",
      ),
    ),
    "category": "General",
  },

  {
    "article": Article(
      title: "Sexual Health with Multiple Partners",
      content:
          "Essential information about managing sexual health when having multiple partners.",
      image: multiplePartnersImage,
      linkToSubpage: SafeContainer(
        child: Center(child: Text("Multiple Partners Article")),
      ),
    ),
    "category": "Multiple Partners",
  },
  {
    "article": Article(
      title: "LGBTQ+ Specific Health Considerations",
      content:
          "Tailored sexual health advice and resources for the LGBTQ+ community.",
      image: lgbtqHealthImage,
      linkToSubpage: SafeContainer(
        child: Center(child: Text("LGBTQ+ Health Article")),
      ),
    ),
    "category": "LGBTQ+",
  },
  {
    "article": Article(
      title: "Getting Started with Regular Testing",
      content:
          "A beginner’s guide to understanding when and why regular testing is important.",
      image: regularTestingImage,
      linkToSubpage: SafeContainer(
        child: Center(child: Text("Regular Testing Article")),
      ),
    ),
    "category": "General",
  },
];
