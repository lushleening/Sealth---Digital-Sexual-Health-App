import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArticleFilterNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null; // default = no filter
  }

  void setFilter(String? category) {
    state = category;
  }
}

final articleFilterProvider = NotifierProvider<ArticleFilterNotifier, String?>(
  ArticleFilterNotifier.new,
);
