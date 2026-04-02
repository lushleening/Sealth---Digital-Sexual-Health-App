import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/discussion_post.dart';
import 'models/comments.dart';

class DiscussionServices {
  final SupabaseClient supabase;

  // Constructor with dependency injection
  DiscussionServices({required this.supabase});

  // --- ORIGINAL fetchPosts (unchanged) ---
  Future<List<DiscussionPost>> fetchPosts() async {
    final data = await supabase
        .from('posts')
        .select('*, comments(count)')
        .order('created_at', ascending: false);

    uiLogger.info('RAW POSTS WITH COUNT: $data');

    return (data as List).map((item) => DiscussionPost.fromMap(item)).toList();
  }

  // --- Fetch posts with avatars (works for logged-out users) ---
  Future<List<DiscussionPost>> fetchPostsWithAvatars() async {
    final data = await supabase
        .from('posts')
        .select('''
          *,
          comments(count),
          profiles!posts_user_id_fkey (username, avatar_url, verified)
        ''')
        .order('created_at', ascending: false);

    discussionLogger.info('RAW POSTS WITH AVATARS: $data');

    return (data as List).map((item) {
      final profile = item['profiles'] as Map<String, dynamic>?;

      // Check if this is an anonymous post from the author_name field
      final authorName = item['author_name'] ?? 'Unknown User';
      final isAnonymous = authorName == 'Anonymous';

      // For anonymous posts, always show person outline
      if (isAnonymous) {
        return DiscussionPost.fromMap({
          ...item,
          'author_name': 'Anonymous',
          'avatar_url': null,
          'is_verified': false,
        });
      }

      // For regular posts, try to get profile data
      // If profile exists, use its data; otherwise fall back to stored author_name
      return DiscussionPost.fromMap({
        ...item,
        'author_name': profile?['username'] ?? authorName,
        'avatar_url':
            profile?['avatar_url'], // This will be null if profile doesn't exist
        'is_verified': profile?['verified'] ?? false,
      });
    }).toList();
  }

  // --- ORIGINAL fetchComments (unchanged) ---
  Future<List<DiscussionComment>> fetchComments(String postId) async {
    final userId = supabase.auth.currentUser!.id;

    final data = await supabase
        .from('comments')
        .select('*, comment_likes(user_id)')
        .eq('post_id', postId)
        .order('created_at', ascending: true);

    discussionLogger.info('RAW COMMENTS: $data');

    final Map<String, int> replyCounts = {};
    for (var item in data as List) {
      final parentId = item['parent_comment_id'];
      if (parentId != null) {
        replyCounts[parentId] = (replyCounts[parentId] ?? 0) + 1;
      }
    }

    discussionLogger.info('REPLY COUNTS: $replyCounts');

    return (data as List).map((item) {
      final likesList = item['comment_likes'] as List<dynamic>? ?? [];
      final isLiked = likesList.any((like) => like['user_id'] == userId);
      final commentId = item['id'];
      final replyCount = replyCounts[commentId] ?? 0;

      return DiscussionComment.fromMap({
        ...item,
        'is_liked': isLiked,
        'reply_count': replyCount,
      });
    }).toList();
  }

  // --- NEW: Fetch comments with avatars ---
  Future<List<DiscussionComment>> fetchCommentsWithAvatars(
    String postId,
  ) async {
    final user = supabase.auth.currentUser;
    final userId = user?.id;

    final data = await supabase
        .from('comments')
        .select('''
          *,
          comment_likes(user_id),
          profiles!comments_user_id_fkey (username, avatar_url, verified)
        ''')
        .eq('post_id', postId)
        .order('created_at', ascending: true);

    discussionLogger.info('RAW COMMENTS WITH AVATARS: $data');

    final Map<String, int> replyCounts = {};
    for (var item in data as List) {
      final parentId = item['parent_comment_id'];
      if (parentId != null) {
        replyCounts[parentId] = (replyCounts[parentId] ?? 0) + 1;
      }
    }

    return (data as List).map((item) {
      final profile = item['profiles'] as Map<String, dynamic>?;
      final likesList = item['comment_likes'] as List<dynamic>? ?? [];
      final isLiked = userId != null
          ? likesList.any((like) => like['user_id'] == userId)
          : false;
      final commentId = item['id'];
      final replyCount = replyCounts[commentId] ?? 0;

      return DiscussionComment.fromMap({
        ...item,
        'author_name': profile?['username'] ?? 'Unknown',
        'avatar_url': profile?['avatar_url'],
        'is_verified': profile?['verified'] ?? false,
        'is_liked': isLiked,
        'reply_count': replyCount,
      });
    }).toList();
  }

  // --- Toggle post like ---
  Future<bool> toggleLike(String postId) async {
    final userId = supabase.auth.currentUser!.id;

    final existing = await supabase
        .from('post_likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', userId)
        .maybeSingle();

    if (existing != null) {
      await supabase
          .from('post_likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', userId);

      await supabase.rpc('decrement_likes', params: {'post_id': postId});
      return false;
    } else {
      await supabase.from('post_likes').insert({
        'post_id': postId,
        'user_id': userId,
      });

      await supabase.rpc('increment_likes', params: {'post_id': postId});
      return true;
    }
  }

  Future<bool> toggleCommentLike(String commentId) async {
    final userId = supabase.auth.currentUser!.id;

    discussionLogger.info('=== TOGGLE COMMENT LIKE ===');
    discussionLogger.info('Comment ID: $commentId');
    discussionLogger.info('User ID: $userId');

    final existing = await supabase
        .from('comment_likes')
        .select()
        .eq('comment_id', commentId)
        .eq('user_id', userId)
        .maybeSingle();

    discussionLogger.info('Existing like record: $existing');

    if (existing != null) {
      discussionLogger.info('UNLIKING comment...');

      final deleteResult = await supabase
          .from('comment_likes')
          .delete()
          .eq('comment_id', commentId)
          .eq('user_id', userId);

      discussionLogger.info('Delete result: $deleteResult');

      try {
        await supabase.rpc(
          'decrement_comment_likes',
          params: {'comment_id': commentId},
        );
        discussionLogger.info('Successfully decremented likes count');
      } catch (e) {
        discussionLogger.info('ERROR decrementing likes: $e');
      }

      return false;
    } else {
      discussionLogger.info('LIKING comment...');

      final insertResult = await supabase.from('comment_likes').insert({
        'comment_id': commentId,
        'user_id': userId,
      });

      discussionLogger.info('Insert result: $insertResult');

      try {
        await supabase.rpc(
          'increment_comment_likes',
          params: {'comment_id': commentId},
        );
        discussionLogger.info('Successfully incremented likes count');
      } catch (e) {
        discussionLogger.info('ERROR incrementing likes: $e');
      }

      return true;
    }
  }

  // --- Check if the current user liked a post ---
  Future<bool> isLiked(String postId) async {
    final userId = supabase.auth.currentUser!.id;

    final existing = await supabase
        .from('post_likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', userId)
        .maybeSingle();

    return existing != null;
  }

  // --- Check if the current user liked a comment ---
  Future<bool> isCommentLiked(String commentId) async {
    final userId = supabase.auth.currentUser!.id;

    final existing = await supabase
        .from('comment_likes')
        .select()
        .eq('comment_id', commentId)
        .eq('user_id', userId)
        .maybeSingle();

    return existing != null;
  }

  // --- ORIGINAL addComment (unchanged) ---
  Future<DiscussionComment> addComment({
    required String postId,
    required String content,
    String? parentCommentId,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final userId = user.id;

    final userData = await supabase
        .from('profiles')
        .select('username, verified')
        .eq('supabase_id', userId)
        .single();

    final authorName = userData['username'] ?? 'User';
    final isVerified = userData['verified'] ?? false;

    final newComment = {
      'post_id': postId,
      'user_id': userId,
      'author_name': authorName,
      'content': content,
      'is_verified': isVerified,
      'likes': 0,
      'parent_comment_id': parentCommentId,
      'created_at': DateTime.now().toIso8601String(),
    };

    final response = await supabase
        .from('comments')
        .insert(newComment)
        .select()
        .single();

    if (parentCommentId != null) {
      try {
        await supabase.rpc(
          'increment_comment_reply_count',
          params: {'comment_id': parentCommentId},
        );
      } catch (e) {
        discussionLogger.info("ERROR incrementing reply count: $e");
      }
    }

    return DiscussionComment.fromMap({
      ...response,
      'is_liked': false,
      'reply_count': 0,
    });
  }

  // --- NEW: Add comment with avatar ---
  Future<DiscussionComment> addCommentWithAvatar({
    required String postId,
    required String content,
    String? parentCommentId,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final userId = user.id;

    final userData = await supabase
        .from('profiles')
        .select('username, avatar_url, verified')
        .eq('supabase_id', userId)
        .single();

    final authorName = userData['username'] ?? 'User';
    final avatarUrl = userData['avatar_url'];
    final isVerified = userData['verified'] ?? false;

    final newComment = {
      'post_id': postId,
      'user_id': userId,
      'author_name': authorName,
      'avatar_url': avatarUrl,
      'content': content,
      'is_verified': isVerified,
      'likes': 0,
      'parent_comment_id': parentCommentId,
      'created_at': DateTime.now().toIso8601String(),
    };

    final response = await supabase
        .from('comments')
        .insert(newComment)
        .select()
        .single();

    if (parentCommentId != null) {
      try {
        await supabase.rpc(
          'increment_comment_reply_count',
          params: {'comment_id': parentCommentId},
        );
      } catch (e) {
        discussionLogger.info("ERROR incrementing reply count: $e");
      }
    }

    return DiscussionComment.fromMap({
      ...response,
      'is_liked': false,
      'reply_count': 0,
    });
  }

  // --- Create new post ---
  Future<DiscussionPost> createPost({
    required String title,
    required String content,
    required bool isAnonymous,
    List<String>? tags,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final userId = user.id;
    String authorName;
    bool isVerified = false;

    if (isAnonymous) {
      authorName = 'Anonymous';
      isVerified = false;
    } else {
      final userData = await supabase
          .from('profiles')
          .select('username, verified')
          .eq('supabase_id', userId)
          .single();

      authorName = userData['username'] ?? 'User';
      isVerified = userData['verified'] ?? false;
    }

    final newPost = {
      'user_id': userId,
      'title': title,
      'content': content,
      'author_name': authorName,
      'is_verified': isVerified,
      'likes': 0,
      'shares': 0,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (tags != null && tags.isNotEmpty) {
      newPost['tags'] = tags;
    }

    final response = await supabase
        .from('posts')
        .insert(newPost)
        .select()
        .single();

    return DiscussionPost.fromMap(response);
  }

  // --- Delete a post ---
  Future<void> deletePost(String postId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await supabase.from('comments').delete().eq('post_id', postId);

    await supabase.from('post_likes').delete().eq('post_id', postId);

    await supabase
        .from('posts')
        .delete()
        .eq('id', postId)
        .eq('user_id', user.id);
  }

  // --- Delete multiple posts ---
  Future<void> deletePosts(List<String> postIds) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    for (final postId in postIds) {
      await deletePost(postId);
    }
  }

  // --- Update a post ---
  Future<DiscussionPost> updatePost({
    required String postId,
    required String title,
    required String content,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final updatedPost = {
      'title': title,
      'content': content,
      'updated_at': DateTime.now().toIso8601String(),
    };

    final response = await supabase
        .from('posts')
        .update(updatedPost)
        .eq('id', postId)
        .eq('user_id', user.id)
        .select()
        .single();

    return DiscussionPost.fromMap(response);
  }
}

// --- Build comment tree (nested replies) ---
List<DiscussionComment> buildCommentTree(List<DiscussionComment> comments) {
  final Map<String, DiscussionComment> map = {};
  final List<DiscussionComment> roots = [];

  for (var c in comments) {
    map[c.id] = c.copyWith(replies: []);
  }

  for (var comment in map.values) {
    if (comment.parentCommentId == null) {
      roots.add(comment);
    } else {
      final parent = map[comment.parentCommentId];
      if (parent != null) {
        parent.replies.add(comment);
      }
    }
  }

  return roots;
}
