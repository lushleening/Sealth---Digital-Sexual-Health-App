import 'package:drift/drift.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/schema.dart';

part 'recently_viewed_articles_dao.g.dart';

@DriftAccessor(tables: [RecentlyViewedArticles])
class RecentlyViewedArticlesDAO extends DatabaseAccessor<Database>
    with _$RecentlyViewedArticlesDAOMixin {
  RecentlyViewedArticlesDAO(super.attachedDatabase);

  static const int _maxItems = 10;

  /// Returns article IDs for [localId], most recently viewed first.
  Future<List<String>> getRecentlyViewed(String localId) async {
    final rows = await (select(recentlyViewedArticles)
          ..where((t) => t.localId.equals(localId))
          ..orderBy([(t) => OrderingTerm.desc(t.viewedAt)])
          ..limit(_maxItems))
        .get();
    return rows.map((r) => r.articleId).toList();
  }

  /// Upserts a viewed article — updates [viewedAt] if already exists.
  Future<void> upsertViewed(String localId, String articleId) async {
    await into(recentlyViewedArticles).insertOnConflictUpdate(
      RecentlyViewedArticlesCompanion(
        localId: Value(localId),
        articleId: Value(articleId),
        viewedAt: Value(DateTime.now()),
      ),
    );
  }
}