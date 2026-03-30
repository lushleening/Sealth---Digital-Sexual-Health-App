import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/discussion_post.dart';
import 'models/comments.dart';

class DiscussionServices {
  final supabase = Supabase.instance.client;

  // --- Fetch posts ---
  Future<List<DiscussionPost>> fetchPosts() async {
    final data = await supabase
        .from('posts')
        .select('*, comments(count)')
        .order('created_at', ascending: false);

    print('RAW POSTS WITH COUNT: $data');

    return (data as List)
        .map((item) => DiscussionPost.fromMap(item))
        .toList();
  }

  // --- Fetch comments for a post ---
  Future<List<DiscussionComment>> fetchComments(String postId) async {
    final userId = supabase.auth.currentUser!.id;

    // First, get all comments
    final data = await supabase
        .from('comments')
        .select('*, comment_likes(user_id)')
        .eq('post_id', postId)
        .order('created_at', ascending: true);

    print('RAW COMMENTS: $data');

    // Calculate reply counts for each comment
    final Map<String, int> replyCounts = {};
    for (var item in data as List) {
      final parentId = item['parent_comment_id'];
      if (parentId != null) {
        replyCounts[parentId] = (replyCounts[parentId] ?? 0) + 1;
      }
    }

    print('REPLY COUNTS: $replyCounts');

    return (data as List).map((item) {
      final likesList = item['comment_likes'] as List<dynamic>? ?? [];
      final isLiked = likesList.any((like) => like['user_id'] == userId);
      final commentId = item['id'];
      final replyCount = replyCounts[commentId] ?? 0;

      return DiscussionComment.fromMap({
        ...item,
        'is_liked': isLiked,
        'reply_count': replyCount, // ADD THIS
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
      // UNLIKE
      await supabase
          .from('post_likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', userId);

      await supabase.rpc('decrement_likes', params: {'post_id': postId});
      return false;
    } else {
      // LIKE
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

    print('=== TOGGLE COMMENT LIKE ===');
    print('Comment ID: $commentId');
    print('User ID: $userId');

    final existing = await supabase
        .from('comment_likes')
        .select()
        .eq('comment_id', commentId)
        .eq('user_id', userId)
        .maybeSingle();

    print('Existing like record: $existing');

    if (existing != null) {
      // UNLIKE
      print('UNLIKING comment...');
      
      final deleteResult = await supabase
          .from('comment_likes')
          .delete()
          .eq('comment_id', commentId)
          .eq('user_id', userId);
      
      print('Delete result: $deleteResult');
      
      try {
        await supabase.rpc('decrement_comment_likes', params: {'comment_id': commentId});
        print('Successfully decremented likes count');
      } catch (e) {
        print('ERROR decrementing likes: $e');
      }
      
      return false;
    } else {
      // LIKE
      print('LIKING comment...');
      
      final insertResult = await supabase.from('comment_likes').insert({
        'comment_id': commentId,
        'user_id': userId,
      });
      
      print('Insert result: $insertResult');
      
      try {
        await supabase.rpc('increment_comment_likes', params: {'comment_id': commentId});
        print('Successfully incremented likes count');
      } catch (e) {
        print('ERROR incrementing likes: $e');
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

  // ---Add a new comment or reply ---
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
        await supabase.rpc('increment_comment_reply_count', params: {
          'comment_id': parentCommentId,
        });
      } catch (e) {
        print("ERROR incrementing reply count: $e");
      }
    }

    // 👇 ADD THIS RETURN STATEMENT
    return DiscussionComment.fromMap({
      ...response,
      'is_liked': false,
      'reply_count': 0,
    });
  }

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

    // Remove 'id' from the insert - let Supabase generate it
    final newPost = {
      'user_id': userId,  // Add user_id for foreign key reference
      'title': title,
      'content': content,
      'author_name': authorName,
      'is_verified': isVerified,
      'likes': 0,
      'shares': 0,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    // Add tags if provided (if you have a tags field)
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