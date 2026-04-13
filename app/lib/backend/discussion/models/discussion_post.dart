class DiscussionPost {
  final String id;
  final String userId;
  final String authorName;
  final String? avatarUrl;
  final String title;
  final String content;
  final int likes;
  final int shares;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  // temporary count until comments fetch is wired
  final int comments;

  DiscussionPost({
    required this.id,
    required this.userId,
    required this.authorName,
    this.avatarUrl,
    required this.title,
    required this.content,
    required this.likes,
    required this.shares,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    this.comments = 0,
  });

  DiscussionPost copyWith({
    int? likes,
    int? shares,
    int? comments,
    String? avatarUrl,
    DateTime? updatedAt,
  }) {
    return DiscussionPost(
      id: id,
      userId: userId,
      authorName: authorName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      title: title,
      content: content,
      likes: likes ?? this.likes,
      shares: shares ?? this.shares,
      isVerified: isVerified,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      comments: comments ?? this.comments,
    );
  }

  factory DiscussionPost.fromMap(Map<String, dynamic> map) {
    final commentsData = map['comments'];

    int commentCount = 0;

    if (commentsData != null &&
        commentsData is List &&
        commentsData.isNotEmpty) {
      commentCount = commentsData[0]['count'] ?? 0;
    }

    return DiscussionPost(
      id: map['id'],
      userId: map['user_id'],
      authorName: map['author_name'] ?? 'Unknown User',
      avatarUrl: map['avatar_url'],
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      likes: map['likes'] ?? 0,
      shares: map['shares'] ?? 0,
      isVerified: map['is_verified'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      comments: commentCount,
    );
  }
}