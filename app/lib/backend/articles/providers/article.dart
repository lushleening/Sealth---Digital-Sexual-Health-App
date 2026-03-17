import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/constants/assets.dart';

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