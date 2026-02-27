class DiscussionComment {
  final String id;
  final String postId;
  final String authorName;
  final String content;
  final bool isVerified;
  final int likes;
  final int repliesCount;

  /// Optional — null means top-level comment
  final String? parentCommentId;

  final List<DiscussionComment> replies;

  const DiscussionComment({
    required this.id,
    required this.postId,
    required this.authorName,
    required this.content,
    required this.isVerified,
    required this.likes,
    required this.repliesCount,
    this.parentCommentId, // 👈 no longer required
    required this.replies,
  });

  bool get isReply => parentCommentId != null;

  DiscussionComment copyWith({
    String? id,
    String? postId,
    String? authorName,
    String? content,
    bool? isVerified,
    int? likes,
    int? repliesCount,
    String? parentCommentId,
    List<DiscussionComment>? replies,
  }) {
    return DiscussionComment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorName: authorName ?? this.authorName,
      content: content ?? this.content,
      isVerified: isVerified ?? this.isVerified,
      likes: likes ?? this.likes,
      repliesCount: repliesCount ?? this.repliesCount,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      replies: replies ?? this.replies,
    );
  }
}
