// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_viewed_articles_dao.dart';

// ignore_for_file: type=lint
mixin _$RecentlyViewedArticlesDAOMixin on DatabaseAccessor<Database> {
  $UsersTable get users => attachedDatabase.users;
  $RecentlyViewedArticlesTable get recentlyViewedArticles =>
      attachedDatabase.recentlyViewedArticles;
  RecentlyViewedArticlesDAOManager get managers =>
      RecentlyViewedArticlesDAOManager(this);
}

class RecentlyViewedArticlesDAOManager {
  final _$RecentlyViewedArticlesDAOMixin _db;
  RecentlyViewedArticlesDAOManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$RecentlyViewedArticlesTableTableManager get recentlyViewedArticles =>
      $$RecentlyViewedArticlesTableTableManager(
        _db.attachedDatabase,
        _db.recentlyViewedArticles,
      );
}
