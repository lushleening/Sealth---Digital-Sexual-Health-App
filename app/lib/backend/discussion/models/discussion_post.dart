import 'comments.dart';

class DiscussionPost {
  final String id;
  final String authorName;
  final String title;
  final String content;

  final int likes;
  final int shares;
  final bool isVerified;

  final List<DiscussionComment> comments;

  const DiscussionPost({
    required this.id,
    required this.authorName,
    required this.title,
    required this.content,
    required this.likes,
    required this.shares,
    required this.isVerified,
    required this.comments,
  });

  int get commentsCount => comments.length;

  DiscussionPost copyWith({
    String? id,
    String? authorName,
    String? title,
    String? content,
    int? likes,
    int? shares,
    bool? isVerified,
    List<DiscussionComment>? comments,
  }) {
    return DiscussionPost(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      title: title ?? this.title,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      shares: shares ?? this.shares,
      isVerified: isVerified ?? this.isVerified,
      comments: comments ?? this.comments,
    );
  }
}
