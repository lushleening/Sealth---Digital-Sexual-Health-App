import 'package:sddp_dsh/backend/discussion/discussion_services.dart';

class PostLikeManager {
  static final PostLikeManager _instance = PostLikeManager._internal();
  factory PostLikeManager() => _instance;
  PostLikeManager._internal();
  
  final DiscussionServices _service = DiscussionServices();
  final Map<String, PostLikeInfo> _likes = {};
  
  // List of listeners to notify when likes change
  final List<void Function()> _listeners = [];
  
  void addListener(void Function() listener) {
    _listeners.add(listener);
  }
  
  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }
  
  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }
  
  Future<void> initializeLike(String postId, int currentLikeCount) async {
    final isLiked = await _service.isLiked(postId);
    _likes[postId] = PostLikeInfo(
      isLiked: isLiked,
      likeCount: currentLikeCount,
    );
    _notifyListeners();
  }
  
  Future<void> toggleLike(String postId) async {
    final currentInfo = _likes[postId];
    if (currentInfo == null) return;
    
    final result = await _service.toggleLike(postId);
    final newLikeCount = result ? currentInfo.likeCount + 1 : currentInfo.likeCount - 1;
    
    _likes[postId] = PostLikeInfo(
      isLiked: result,
      likeCount: newLikeCount,
    );
    _notifyListeners();
  }
  
  PostLikeInfo? getLikeInfo(String postId) {
    return _likes[postId];
  }
}

class PostLikeInfo {
  final bool isLiked;
  final int likeCount;
  
  PostLikeInfo({
    required this.isLiked,
    required this.likeCount,
  });
}