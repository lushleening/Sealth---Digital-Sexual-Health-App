import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/constants/assets.dart';

class Article {
  final String? articleId;
  final String title;
  final String content;
  final String image;
  final String? authorId;
  final Widget linkToSubpage;

  const Article({
    this.articleId,
    required this.title,
    required this.content,
    this.image = placeholderImage,
    this.authorId,
    required this.linkToSubpage,
  });
}