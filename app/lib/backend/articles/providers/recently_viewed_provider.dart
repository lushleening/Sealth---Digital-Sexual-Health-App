import 'package:flutter_riverpod/legacy.dart';

class RecentlyViewedNotifier extends StateNotifier<List<String>> {
  static const int _maxItems = 10;

  RecentlyViewedNotifier() : super([]);

  void markViewed(String? articleId) {
    if (articleId == null) return;
    final updated = [articleId, ...state.where((id) => id != articleId)];
    state = updated.take(_maxItems).toList();
  }
}

final recentlyViewedProvider =
    StateNotifierProvider<RecentlyViewedNotifier, List<String>>(
      (ref) => RecentlyViewedNotifier(),
    );