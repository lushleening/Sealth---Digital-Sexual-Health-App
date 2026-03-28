import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/constants/assets.dart';

class Article {
  final String? articleId;
  final String title;
  final String content;
  final String image;
  final String? authorId;
  final String? markdownUrl;
  final String category;

  // linkToSubpage kept for backwards compatibility, navigation handled by go_router
  final Widget linkToSubpage;

  const Article({
    this.articleId,
    required this.title,
    required this.content,
    this.image = placeholderImage,
    this.authorId,
    this.markdownUrl,
    this.category = '',
    required this.linkToSubpage,
  });
}