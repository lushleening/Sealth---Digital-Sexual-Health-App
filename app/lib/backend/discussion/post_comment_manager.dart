import 'package:sddp_dsh/backend/discussion/discussion_services.dart';

class PostCommentManager {
  static final PostCommentManager _instance = PostCommentManager._internal();
  factory PostCommentManager() => _instance;
  PostCommentManager._internal();
  
  late DiscussionServices _service;
  
  // Add this method to initialize the service
  void initialize(DiscussionServices service) {
    _service = service;
  }
  
  final Map<String, int> _commentCounts = {};
  
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
  
  Future<void> initializeCommentCount(String postId, int currentCount) async {
    _commentCounts[postId] = currentCount;
    _notifyListeners();
  }
  
  Future<void> refreshCommentCount(String postId) async {
    final comments = await _service.fetchComments(postId);
    final newCount = comments.length;
    
    if (_commentCounts[postId] != newCount) {
      _commentCounts[postId] = newCount;
      _notifyListeners();
    }
  }
  
  int? getCommentCount(String postId) {
    return _commentCounts[postId];
  }
}