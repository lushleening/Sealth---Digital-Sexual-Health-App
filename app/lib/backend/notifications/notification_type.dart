import 'package:flutter/material.dart';

// For icons in notification page
enum NotificationType {
  home(Icons.home_outlined),
  discussion(Icons.chat_bubble_outline),
  appointment(Icons.calendar_month_outlined),
  articles(Icons.article_outlined);

  final IconData icon;
  const NotificationType(this.icon);

  factory NotificationType.fromString(String value) {
    return NotificationType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Invalid NotificationType: $value'),
    );
  }
}