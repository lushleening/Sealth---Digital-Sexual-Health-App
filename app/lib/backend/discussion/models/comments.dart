class DiscussionComment {
  final String id;
  final String postId;
  final String userId;
  final String authorName;
  final String? avatarUrl;
  final String content;
  final bool isVerified;
  final int likes;
  final String? parentCommentId;
  final DateTime createdAt;

  final bool isLiked;
  final int replyCount;

  // for UI nesting
  final List<DiscussionComment> replies;

  DiscussionComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.authorName,
    this.avatarUrl,
    required this.content,
    required this.isVerified,
    required this.likes,
    required this.parentCommentId,
    required this.createdAt,
    this.isLiked = false,
    this.replyCount = 0,
    this.replies = const [],
  });

  factory DiscussionComment.fromMap(Map<String, dynamic> map) {
    return DiscussionComment(
      id: map['id'],
      postId: map['post_id'],
      userId: map['user_id'],
      authorName: map['author_name'] ?? 'Unknown',
      avatarUrl: map['avatar_url'],
      content: map['content'] ?? '',
      isVerified: map['is_verified'] ?? false,
      likes: map['likes'] ?? 0,
      parentCommentId: map['parent_comment_id'],
      createdAt: DateTime.parse(map['created_at']),
      isLiked: map['is_liked'] ?? false,
      replyCount: map['reply_count'] ?? 0,
    );
  }

  DiscussionComment copyWith({
    List<DiscussionComment>? replies,
    int? likes,
    bool? isLiked,
    int? replyCount,
    String? avatarUrl,
  }) {
    return DiscussionComment(
      id: id,
      postId: postId,
      userId: userId,
      authorName: authorName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      content: content,
      isVerified: isVerified,
      likes: likes ?? this.likes,
      parentCommentId: parentCommentId,
      createdAt: createdAt,
      isLiked: isLiked ?? this.isLiked,
      replyCount: replyCount ?? this.replyCount,
      replies: replies ?? this.replies,
    );
  }
}