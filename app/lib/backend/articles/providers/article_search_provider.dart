import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArticleSearchNotifier extends Notifier<String> {
  @override
  String build() => "";

  void setSearch(String query) {
    state = query.toLowerCase();
  }
}

final articleSearchProvider = NotifierProvider<ArticleSearchNotifier, String>(
  ArticleSearchNotifier.new,
);
