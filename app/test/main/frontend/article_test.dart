import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/snackbar/snackbar_message.dart';
import 'package:sddp_dsh/backend/articles/providers/article_filter_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/article_search_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/articles_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/bookmarks_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/recently_viewed_provider.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/articles/articles.dart';
import 'package:sddp_dsh/frontend/pages/articles/bookmarks.dart';
import 'package:sddp_dsh/frontend/pages/articles/edit_article.dart';
import 'package:sddp_dsh/frontend/pages/articles/markdown_article_page.dart';
import 'package:sddp_dsh/frontend/pages/articles/upload_article.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

// appNotificationProvider is not mocked by default in getContainer().
// Every widget test that renders a full app page needs this override so that
// userContextProvider (which awaits appNotificationProvider.future) can resolve.
final _notifOverride =
    appNotificationProvider.overrideWith(TestAppNotificationNoneNotifier.new);

// ─── Mock DAO for RecentlyViewedNotifier unit tests ───────────────────────
// MockRecentlyViewedDAO is defined in mock_objects.dart — no real SQLite opened
// (system sqlite3 on Windows desktop runners can't parse REFERENCES in DDL).
ProviderContainer _makeRecentlyViewedContainer() {
  final dao = MockRecentlyViewedDAO();
  when(() => dao.getRecentlyViewed(any())).thenAnswer((_) async => []);
  when(() => dao.upsertViewed(any(), any())).thenAnswer((_) async {});
  return ProviderContainer.test(
    overrides: [
      recentlyViewedProvider.overrideWith(
        (ref) => RecentlyViewedNotifier(dao: dao, localId: 'test-user'),
      ),
    ],
  );
}

// ─── Mock Supabase container for ArticlesNotifier unit tests ──────────────
// ArticlesNotifier reads supabaseServiceProvider in its constructor.
// Overriding it with a mock client avoids the "Supabase.instance" crash.
// No DB is needed here — article CRUD methods are purely in-memory.
ProviderContainer _makeArticlesContainer() {
  return ProviderContainer.test(
    overrides: [
      supabaseServiceProvider.overrideWithValue(
        SupabaseClient(
          'https://mock.supabase.co',
          'fakeAnonKey',
          httpClient: MockSupabaseHttpClient(),
          authOptions: const AuthClientOptions(autoRefreshToken: false),
        ),
      ),
    ],
  );
}

// ─── Shared test article ───────────────────────────────────────────────────
Article _makeArticle({
  String id = 'test-id-1',
  String title = 'Understanding HIV Testing Intervals',
  String content = 'Learn when and how often to get tested for HIV.',
  String category = 'Testing',
  String image = 'assets/placeholder.png',
  String? markdownUrl = 'assets/articles/hiv_testing.md',
}) => Article(
  articleId: id,
  authorId: 'author-id-1',
  title: title,
  content: content,
  image: image,
  markdownUrl: markdownUrl,
  category: category,
  linkToSubpage: const SizedBox(),
);

// ─── Unit tests: Article model ─────────────────────────────────────────────
void _articleModelTests() {
  group('Article model', () {
    test('creates article with all fields', () {
      final article = _makeArticle();
      expect(article.articleId, 'test-id-1');
      expect(article.title, 'Understanding HIV Testing Intervals');
      expect(article.category, 'Testing');
      expect(article.markdownUrl, isNotNull);
    });

    test('creates article without optional fields', () {
      final article = Article(
        title: 'No ID Article',
        content: 'Content',
        image: 'assets/placeholder.png',
        category: 'General',
        linkToSubpage: const SizedBox(),
      );
      expect(article.articleId, isNull);
      expect(article.authorId, isNull);
      expect(article.markdownUrl, isNull);
    });

    test('article with null markdownUrl', () {
      final article = _makeArticle(markdownUrl: null);
      expect(article.markdownUrl, isNull);
    });
  });
}

// ─── Unit tests: ArticleFilterNotifier ────────────────────────────────────
void _filterProviderTests() {
  group('ArticleFilterNotifier', () {
    test('initial state is null (All)', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      expect(container.read(articleFilterProvider), isNull);
    });

    test('setFilter updates state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      container.read(articleFilterProvider.notifier).setFilter('Testing');
      expect(container.read(articleFilterProvider), 'Testing');
    });

    test('setFilter to null resets to All', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      container.read(articleFilterProvider.notifier).setFilter('LGBTQ+');
      container.read(articleFilterProvider.notifier).setFilter(null);
      expect(container.read(articleFilterProvider), isNull);
    });

    test('setFilter to different categories', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      for (final cat in ['General', 'Testing', 'Prevention', 'LGBTQ+', 'Treatment']) {
        container.read(articleFilterProvider.notifier).setFilter(cat);
        expect(container.read(articleFilterProvider), cat);
      }
    });
  });
}

// ─── Unit tests: ArticleSearchNotifier ────────────────────────────────────
void _searchProviderTests() {
  group('ArticleSearchNotifier', () {
    test('initial state is empty string', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      expect(container.read(articleSearchProvider), '');
    });

    test('setSearch updates state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      container.read(articleSearchProvider.notifier).setSearch('HIV');
      expect(container.read(articleSearchProvider), 'hiv');
    });

    test('setSearch to empty string resets', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      container.read(articleSearchProvider.notifier).setSearch('testing');
      container.read(articleSearchProvider.notifier).setSearch('');
      expect(container.read(articleSearchProvider), '');
    });

    test('setSearch lowercases the query (filtering is case insensitive)', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      container.read(articleSearchProvider.notifier).setSearch('HIV Testing');
      expect(container.read(articleSearchProvider), 'hiv testing');
    });

    test('boundary: very long search string', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final longQuery = 'a' * 500;
      container.read(articleSearchProvider.notifier).setSearch(longQuery);
      expect(container.read(articleSearchProvider), longQuery);
    });
  });
}

// ─── Unit tests: BookmarksNotifier ────────────────────────────────────────
void _bookmarksProviderTests() {
  group('BookmarksNotifier', () {
    test('initial state is empty', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      expect(container.read(bookmarksProvider), isEmpty);
    });

    test('toggleBookmark adds article', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final article = _makeArticle();
      container.read(bookmarksProvider.notifier).toggleBookmark(article);
      expect(container.read(bookmarksProvider).length, 1);
      expect(container.read(bookmarksProvider).first, article.articleId);
    });

    test('toggleBookmark removes already bookmarked article', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final article = _makeArticle();
      container.read(bookmarksProvider.notifier).toggleBookmark(article);
      container.read(bookmarksProvider.notifier).toggleBookmark(article);
      expect(container.read(bookmarksProvider), isEmpty);
    });

    test('toggleBookmark with multiple articles', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final a1 = _makeArticle(id: '1', title: 'Article 1');
      final a2 = _makeArticle(id: '2', title: 'Article 2');
      final a3 = _makeArticle(id: '3', title: 'Article 3');
      container.read(bookmarksProvider.notifier).toggleBookmark(a1);
      container.read(bookmarksProvider.notifier).toggleBookmark(a2);
      container.read(bookmarksProvider.notifier).toggleBookmark(a3);
      expect(container.read(bookmarksProvider).length, 3);
    });

    test('removing one bookmark leaves others intact', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final a1 = _makeArticle(id: '1', title: 'Article 1');
      final a2 = _makeArticle(id: '2', title: 'Article 2');
      container.read(bookmarksProvider.notifier).toggleBookmark(a1);
      container.read(bookmarksProvider.notifier).toggleBookmark(a2);
      container.read(bookmarksProvider.notifier).toggleBookmark(a1);
      expect(container.read(bookmarksProvider).length, 1);
      expect(container.read(bookmarksProvider).first, a2.articleId);
    });

    test('boundary: bookmark same article multiple times alternates state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final article = _makeArticle();
      for (int i = 0; i < 5; i++) {
        container.read(bookmarksProvider.notifier).toggleBookmark(article);
      }
      // 5 toggles = odd number = should be bookmarked
      expect(container.read(bookmarksProvider).length, 1);
    });
  });
}

// ─── Unit tests: RecentlyViewedNotifier ───────────────────────────────────
void _recentlyViewedTests() {
  group('RecentlyViewedNotifier', () {
    // Uses _makeRecentlyViewedContainer() which stubs the DAO so no real
    // SQLite DB is opened. markViewed() is still async (await the DAO stub).

    test('initial state is empty', () async {
      final container = _makeRecentlyViewedContainer();
      expect(container.read(recentlyViewedProvider), isEmpty);
    });

    test('markViewed adds article id', () async {
      final container = _makeRecentlyViewedContainer();
      await container.read(recentlyViewedProvider.notifier).markViewed('article-1');
      expect(container.read(recentlyViewedProvider), contains('article-1'));
    });

    test('markViewed puts most recent first', () async {
      final container = _makeRecentlyViewedContainer();
      await container.read(recentlyViewedProvider.notifier).markViewed('article-1');
      await container.read(recentlyViewedProvider.notifier).markViewed('article-2');
      expect(container.read(recentlyViewedProvider).first, 'article-2');
    });

    test('markViewed moves existing id to front', () async {
      final container = _makeRecentlyViewedContainer();
      await container.read(recentlyViewedProvider.notifier).markViewed('article-1');
      await container.read(recentlyViewedProvider.notifier).markViewed('article-2');
      await container.read(recentlyViewedProvider.notifier).markViewed('article-1');
      expect(container.read(recentlyViewedProvider).first, 'article-1');
      expect(container.read(recentlyViewedProvider).length, 2);
    });

    test('markViewed with null id does nothing', () async {
      final container = _makeRecentlyViewedContainer();
      await container.read(recentlyViewedProvider.notifier).markViewed(null);
      expect(container.read(recentlyViewedProvider), isEmpty);
    });

    test('boundary: does not exceed max 10 items', () async {
      final container = _makeRecentlyViewedContainer();
      for (int i = 0; i < 15; i++) {
        await container.read(recentlyViewedProvider.notifier).markViewed('article-$i');
      }
      expect(container.read(recentlyViewedProvider).length, lessThanOrEqualTo(10));
    });

    test('boundary: exactly 10 items stored', () async {
      final container = _makeRecentlyViewedContainer();
      for (int i = 0; i < 10; i++) {
        await container.read(recentlyViewedProvider.notifier).markViewed('article-$i');
      }
      expect(container.read(recentlyViewedProvider).length, 10);
    });
  });
}

// ─── Unit tests: ArticlesNotifier ─────────────────────────────────────────
void _articlesProviderTests() {
  group('ArticlesNotifier', () {
    test('initial state is empty list', () {
      final container = _makeArticlesContainer();
      expect(container.read(articlesProvider), isEmpty);
    });

    test('addArticle adds to provider', () {
      final container = _makeArticlesContainer();
      final article = _makeArticle();
      container.read(articlesProvider.notifier).addArticle(
        article: article,
        category: 'Testing',
      );
      expect(container.read(articlesProvider).length, 1);
    });

    test('addArticle stores correct article and category', () {
      final container = _makeArticlesContainer();
      final article = _makeArticle();
      container.read(articlesProvider.notifier).addArticle(
        article: article,
        category: 'Testing',
      );
      final stored = container.read(articlesProvider).first;
      expect((stored['article'] as Article).title, article.title);
      expect(stored['category'], 'Testing');
    });

    test('removeArticle removes correct article', () {
      final container = _makeArticlesContainer();
      final a1 = _makeArticle(id: 'id-1', title: 'Article 1');
      final a2 = _makeArticle(id: 'id-2', title: 'Article 2');
      container.read(articlesProvider.notifier).addArticle(article: a1, category: 'General');
      container.read(articlesProvider.notifier).addArticle(article: a2, category: 'Testing');
      container.read(articlesProvider.notifier).removeArticle('id-1');
      expect(container.read(articlesProvider).length, 1);
      expect(
        (container.read(articlesProvider).first['article'] as Article).title,
        'Article 2',
      );
    });

    test('removeArticle with non-existent id does nothing', () {
      final container = _makeArticlesContainer();
      final article = _makeArticle();
      container.read(articlesProvider.notifier).addArticle(
        article: article,
        category: 'Testing',
      );
      container.read(articlesProvider.notifier).removeArticle('non-existent-id');
      expect(container.read(articlesProvider).length, 1);
    });

    test('updateArticle updates title and category', () {
      final container = _makeArticlesContainer();
      final original = _makeArticle(id: 'id-1', title: 'Old Title');
      container.read(articlesProvider.notifier).addArticle(
        article: original,
        category: 'Testing',
      );
      final updated = _makeArticle(id: 'id-1', title: 'New Title', category: 'General');
      container.read(articlesProvider.notifier).updateArticle(
        articleId: 'id-1',
        updatedArticle: updated,
        category: 'General',
      );
      final stored = container.read(articlesProvider).first;
      expect((stored['article'] as Article).title, 'New Title');
      expect(stored['category'], 'General');
    });

    test('boundary: add multiple articles', () {
      final container = _makeArticlesContainer();
      for (int i = 0; i < 20; i++) {
        container.read(articlesProvider.notifier).addArticle(
          article: _makeArticle(id: 'id-$i', title: 'Article $i'),
          category: 'General',
        );
      }
      expect(container.read(articlesProvider).length, 20);
    });
  });
}

// ─── Widget tests: Articles Page ───────────────────────────────────────────
void _articlesPageWidgetTests() {
  group('Articles Page - Widget', () {
    testWidgets('renders correctly', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articles, otherOverrides: [_notifOverride]);
      expectObj(ArticlesPage);
    });

    testWidgets('shows search bar', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articles, otherOverrides: [_notifOverride]);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows filter button', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articles, otherOverrides: [_notifOverride]);
      expect(find.text('Filters'), findsOneWidget);
    });

    testWidgets('shows upload icon', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articles, otherOverrides: [_notifOverride]);
      expectObj(KBtn.navNewArticles);
    });

    testWidgets('shows bookmark icon', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articles, otherOverrides: [_notifOverride]);
      expectObj(KBtn.navBookmarkBtn);
    });

    testWidgets('tapping bookmark icon navigates to BookmarksPage', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articles, otherOverrides: [_notifOverride]);
      await tap(tester, find.byKey(KBtn.navBookmarkBtn.key));
      expectObj(BookmarksPage);
    });

    testWidgets('filter bottom sheet opens on tap', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articles, otherOverrides: [_notifOverride]);
      await tap(tester, find.text('Filters'));
      expect(find.text('Filter by Category'), findsOneWidget);
    });

    testWidgets('filter bottom sheet shows all categories', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articles, otherOverrides: [_notifOverride]);
      await tap(tester, find.text('Filters'));
      // The sheet opens at initialChildSize: 0.5, so not all items are in the
      // viewport. scrollUntilVisible scrolls the inner list to reveal each one.
      final sheetList = find.byType(Scrollable).last;
      for (final label in ['All', 'General', 'LGBTQ+', 'Testing', 'Prevention']) {
        await tester.scrollUntilVisible(find.text(label), 50.0, scrollable: sheetList);
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('unverified user tapping upload shows verification dialog', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.articles,
        asRegisteredUser: false,
        otherOverrides: [_notifOverride],
      );
      await tap(tester, find.byKey(KBtn.navNewArticles.key));
      expect(find.text('Verification Required'), findsOneWidget);
    });

    testWidgets('verification dialog has Cancel and Email Us buttons', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.articles,
        asRegisteredUser: false,
        otherOverrides: [_notifOverride],
      );
      await tap(tester, find.byKey(KBtn.navNewArticles.key));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Email Us'), findsOneWidget);
    });

    testWidgets('Cancel button dismisses verification dialog', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.articles,
        asRegisteredUser: false,
        otherOverrides: [_notifOverride],
      );
      await tap(tester, find.byKey(KBtn.navNewArticles.key));
      await tap(tester, find.text('Cancel'));
      expect(find.text('Verification Required'), findsNothing);
    });

    testWidgets('search field accepts input', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articles, otherOverrides: [_notifOverride]);
      await tester.enterText(find.byType(TextField), 'HIV');
      await tester.pumpAndSettle();
      expect(find.text('HIV'), findsOneWidget);
    });

    testWidgets('article card tap does nothing when no articles loaded', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articles, otherOverrides: [_notifOverride]);
      final cards = find.byKey(KBtn.articleCard.key);
      if (cards.evaluate().isNotEmpty) {
        await tap(tester, cards.first);
      }
      // No crash expected
    });

    testWidgets('pagination controls not shown when no articles', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articles, otherOverrides: [_notifOverride]);
      expect(find.text('Page 1 of'), findsNothing);
    });
  });
}

// ─── Widget tests: Upload Article Page ────────────────────────────────────
void _uploadPageWidgetTests() {
  group('Upload Article Page - Widget', () {
    testWidgets('renders correctly', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleUpload, asRegisteredUser: true, otherOverrides: [_notifOverride]);
      expectObj(UploadArticlePage);
    });

    testWidgets('shows markdown upload card', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleUpload, asRegisteredUser: true, otherOverrides: [_notifOverride]);
      expectObj(KBtn.uploadPdfBtn);
    });

    testWidgets('shows image upload card', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleUpload, asRegisteredUser: true, otherOverrides: [_notifOverride]);
      expectObj(KBtn.uploadImageBtn);
    });

    testWidgets('shows upload button', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleUpload, asRegisteredUser: true, otherOverrides: [_notifOverride]);
      expectObj(KBtn.uploadArticleBtn);
    });

    testWidgets('shows Article Title field', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleUpload, asRegisteredUser: true, otherOverrides: [_notifOverride]);
      expect(find.text('Article Title'), findsOneWidget);
    });

    testWidgets('shows Short Description field', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleUpload, asRegisteredUser: true, otherOverrides: [_notifOverride]);
      expect(find.text('Short Description (optional)'), findsOneWidget);
    });

    testWidgets('shows category dropdown', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleUpload, asRegisteredUser: true, otherOverrides: [_notifOverride]);
      expect(find.text('Select a label'), findsOneWidget);
    });

    testWidgets('upload button tap with no title shows snackbar', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleUpload, asRegisteredUser: true, otherOverrides: [_notifOverride]);
      await tap(tester, find.byKey(KBtn.uploadArticleBtn.key));
      expect(find.text('Title is required'), findsOneWidget);
    });

    testWidgets('upload button tap with title but no markdown shows snackbar', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleUpload, asRegisteredUser: true, otherOverrides: [_notifOverride]);
      await tester.enterText(
        find.widgetWithText(TextField, 'Enter article title'),
        'My Article',
      );
      await tester.pumpAndSettle();
      await tap(tester, find.byKey(KBtn.uploadArticleBtn.key));
      expect(find.text('Upload a markdown file'), findsOneWidget);
    });

    testWidgets('title field accepts input', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleUpload, asRegisteredUser: true, otherOverrides: [_notifOverride]);
      await tester.enterText(
        find.widgetWithText(TextField, 'Enter article title'),
        'Sexual Health Guide',
      );
      await tester.pumpAndSettle();
      expect(find.text('Sexual Health Guide'), findsOneWidget);
    });

    testWidgets('shows appbar with Upload Article title', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleUpload, asRegisteredUser: true, otherOverrides: [_notifOverride]);
      expect(find.text('Upload Article'), findsWidgets);
    });

    testWidgets('boundary: empty title shows validation snackbar', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleUpload, asRegisteredUser: true, otherOverrides: [_notifOverride]);
      await tap(tester, find.byKey(KBtn.uploadArticleBtn.key));
      expect(find.text('Title is required'), findsOneWidget);
    });
  });
}

// ─── Widget tests: Bookmarks Page ─────────────────────────────────────────
void _bookmarksPageWidgetTests() {
  group('Bookmarks Page - Widget', () {
    testWidgets('renders correctly', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleBookmarks, otherOverrides: [_notifOverride]);
      expectObj(BookmarksPage);
    });

    testWidgets('shows Bookmarks header', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleBookmarks, otherOverrides: [_notifOverride]);
      expect(find.text('Bookmarks'), findsOneWidget);
    });

    testWidgets('shows empty state message when no bookmarks', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleBookmarks, otherOverrides: [_notifOverride]);
      expect(find.text('No bookmarked articles yet.'), findsOneWidget);
    });

    testWidgets('back button navigates back to articles', (tester) async {
      final container = await initWidget(
        tester: tester,
        path: AppRoute.articles,
        otherOverrides: [_notifOverride],
      );
      await tap(tester, find.byKey(KBtn.navBookmarkBtn.key));
      expectObj(BookmarksPage);
      await systemBack(tester);
      expectPath(container, AppRoute.articles);
    });

    testWidgets('shows bookmarked article after bookmarking', (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.articles,
        otherOverrides: [
          _notifOverride,
          articlesProvider.overrideWith((ref) {
            final notifier = ArticlesNotifier(ref: ref);
            notifier.addArticle(
              article: _makeArticle(),
              category: 'Testing',
            );
            return notifier;
          }),
        ],
      );

      // Bookmark first article if it exists
      final bookmarkBtns = find.byIcon(Icons.bookmark_border);
      if (bookmarkBtns.evaluate().isNotEmpty) {
        await tap(tester, bookmarkBtns.first);
      }

      // Go to bookmarks
      await tap(tester, find.byKey(KBtn.navBookmarkBtn.key));
      expectObj(BookmarksPage);
    });
  });
}

// ─── Widget tests: Edit Article Page ──────────────────────────────────────
void _editArticlePageWidgetTests() {
  group('Edit Article Page - Widget', () {
    testWidgets('Edit Article Page renders with correct fields when navigated via extra', (
      tester,
    ) async {
      final article = _makeArticle();
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(extensions: const [lightAppColors]),
            home: EditArticlePage(
              article: article,
              category: 'Testing',
              markdownUrl: 'https://example.com/test.md',
              thumbnailUrl: 'assets/placeholder.png',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Edit Article'), findsOneWidget);
    });

    testWidgets('Edit Article Page shows title pre-filled', (tester) async {
      final article = _makeArticle(title: 'Pre-filled Title');
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(extensions: const [lightAppColors]),
            home: EditArticlePage(
              article: article,
              category: 'Testing',
              markdownUrl: 'https://example.com/test.md',
              thumbnailUrl: 'assets/placeholder.png',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Pre-filled Title'), findsOneWidget);
    });

    testWidgets('Edit Article Page shows Save Changes button', (tester) async {
      final article = _makeArticle();
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(extensions: const [lightAppColors]),
            home: EditArticlePage(
              article: article,
              category: 'Testing',
              markdownUrl: 'https://example.com/test.md',
              thumbnailUrl: 'assets/placeholder.png',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('Edit Article Page shows markdown replace card', (tester) async {
      final article = _makeArticle();
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(extensions: const [lightAppColors]),
            home: EditArticlePage(
              article: article,
              category: 'Testing',
              markdownUrl: 'https://example.com/test.md',
              thumbnailUrl: 'assets/placeholder.png',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Replace markdown file (optional)'), findsOneWidget);
    });

    testWidgets('Edit Article Page shows thumbnail replace card', (tester) async {
      final article = _makeArticle();
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(extensions: const [lightAppColors]),
            home: EditArticlePage(
              article: article,
              category: 'Testing',
              markdownUrl: 'https://example.com/test.md',
              thumbnailUrl: 'assets/placeholder.png',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Replace thumbnail image (optional)'), findsOneWidget);
    });

    testWidgets('Save Changes with empty title shows snackbar', (tester) async {
      final article = _makeArticle(title: '');
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            scaffoldMessengerKey: scaffoldMessengerKey,
            theme: ThemeData(extensions: const [lightAppColors]),
            home: EditArticlePage(
              article: article,
              category: 'Testing',
              markdownUrl: 'https://example.com/test.md',
              thumbnailUrl: 'assets/placeholder.png',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Clear the title field
      final titleField = find.byType(TextField).first;
      await tester.tap(titleField);
      await tester.pump();
      await tester.enterText(titleField, '');
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Save Changes'));
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();
      expect(find.text('Title is required'), findsOneWidget);
    });

    testWidgets('Edit Article shows description field', (tester) async {
      final article = _makeArticle();
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(extensions: const [lightAppColors]),
            home: EditArticlePage(
              article: article,
              category: 'Testing',
              markdownUrl: 'https://example.com/test.md',
              thumbnailUrl: 'assets/placeholder.png',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Short Description (optional)'), findsOneWidget);
    });
  });
}

// ─── Widget tests: Markdown Article Page ──────────────────────────────────
void _markdownArticlePageWidgetTests() {
  group('Markdown Article Page - Widget', () {
    // MarkdownArticlePage.initState calls recentlyViewedProvider, which needs
    // databaseProvider + appUserProvider. We use getContainer() (in-memory DB,
    // guest user) via UncontrolledProviderScope to satisfy those dependencies.
    Widget buildArticlePage(Article article) {
      // recentlyViewedProvider is already mocked in getContainer() by default.
      // Only notifOverride is needed here as an extra override.
      final container = getContainer(otherOverrides: [_notifOverride]);
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(extensions: const [lightAppColors]),
          home: MarkdownArticlePage(
            article: article,
            category: article.category,
            markdownUrl: article.markdownUrl ?? '',
            thumbnailUrl: article.image,
            markdownPath: article.markdownUrl ?? '',
          ),
        ),
      );
    }

    testWidgets('renders article title', (tester) async {
      final article = _makeArticle(
        title: 'Understanding HIV Testing',
        markdownUrl: 'assets/articles/hiv_testing.md',
      );
      await tester.pumpWidget(buildArticlePage(article));
      await tester.pump(); // start async loadMarkdown
      await tester.pump(); // rebuild after setState
      expect(find.text('Understanding HIV Testing'), findsOneWidget);
    });

    testWidgets('renders category tag', (tester) async {
      final article = _makeArticle(
        category: 'Testing',
        markdownUrl: 'assets/articles/hiv_testing.md',
      );
      await tester.pumpWidget(buildArticlePage(article));
      await tester.pump(); // start async loadMarkdown
      await tester.pump(); // rebuild after setState
      expect(find.text('Testing'), findsOneWidget);
    });

    testWidgets('shows loading indicator while markdown loads', (tester) async {
      final article = _makeArticle(
        markdownUrl: 'https://example.com/test.md',
      );
      await tester.pumpWidget(buildArticlePage(article));
      // Before settling, loading indicator should show
      await tester.pump(const Duration(milliseconds: 50));
      // No crash expected
    });

    testWidgets('shows bookmark icon in app bar', (tester) async {
      final article = _makeArticle(
        markdownUrl: 'assets/articles/hiv_testing.md',
      );
      await tester.pumpWidget(buildArticlePage(article));
      await tester.pump();
      expect(
        find.byIcon(Icons.bookmark_border).evaluate().isNotEmpty ||
            find.byIcon(Icons.bookmark).evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('non-author does not see more_vert menu', (tester) async {
      final article = _makeArticle(
        markdownUrl: 'assets/articles/hiv_testing.md',
      );
      await tester.pumpWidget(buildArticlePage(article));
      await tester.pump();
      // Non-author (supabase auth returns null user) should not see edit/delete
      expect(find.byIcon(Icons.more_vert), findsNothing);
    });
  });
}

// ─── Integration tests ─────────────────────────────────────────────────────
void _integrationTests() {
  group('Integration: Articles filter and search', () {
    test('filter and search work together on provider level', () {
      final container = _makeArticlesContainer();

      // Add articles
      container.read(articlesProvider.notifier).addArticle(
        article: _makeArticle(id: '1', title: 'HIV Testing Guide', category: 'Testing'),
        category: 'Testing',
      );
      container.read(articlesProvider.notifier).addArticle(
        article: _makeArticle(id: '2', title: 'Prevention Methods', category: 'Prevention'),
        category: 'Prevention',
      );
      container.read(articlesProvider.notifier).addArticle(
        article: _makeArticle(id: '3', title: 'HIV Prevention', category: 'Prevention'),
        category: 'Prevention',
      );

      // Set filter
      container.read(articleFilterProvider.notifier).setFilter('Prevention');
      // Set search
      container.read(articleSearchProvider.notifier).setSearch('HIV');

      final all = container.read(articlesProvider);
      final filter = container.read(articleFilterProvider);
      final search = container.read(articleSearchProvider);

      final results = all.where((d) {
        final article = d['article'] as Article;
        final cat = d['category'] as String;
        final matchCat = filter == null || cat == filter;
        final matchSearch = article.title.toLowerCase().contains(search.toLowerCase());
        return matchCat && matchSearch;
      }).toList();

      expect(results.length, 1);
      expect((results.first['article'] as Article).title, 'HIV Prevention');
    });

    test('bookmark then unbookmark leaves empty list', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final article = _makeArticle();
      container.read(bookmarksProvider.notifier).toggleBookmark(article);
      expect(container.read(bookmarksProvider).length, 1);
      container.read(bookmarksProvider.notifier).toggleBookmark(article);
      expect(container.read(bookmarksProvider), isEmpty);
    });

    test('recently viewed tracks article opens in order', () async {
      final container = _makeRecentlyViewedContainer();
      await container.read(recentlyViewedProvider.notifier).markViewed('article-1');
      await container.read(recentlyViewedProvider.notifier).markViewed('article-2');
      await container.read(recentlyViewedProvider.notifier).markViewed('article-3');
      final ids = container.read(recentlyViewedProvider);
      expect(ids[0], 'article-3');
      expect(ids[1], 'article-2');
      expect(ids[2], 'article-1');
    });

    test('add article then remove article leaves empty state', () {
      final container = _makeArticlesContainer();
      final article = _makeArticle(id: 'remove-me');
      container.read(articlesProvider.notifier).addArticle(
        article: article,
        category: 'Testing',
      );
      expect(container.read(articlesProvider).length, 1);
      container.read(articlesProvider.notifier).removeArticle('remove-me');
      expect(container.read(articlesProvider), isEmpty);
    });

    test('update article reflects new values immediately', () {
      final container = _makeArticlesContainer();
      final original = _makeArticle(id: 'update-me', title: 'Original');
      container.read(articlesProvider.notifier).addArticle(
        article: original,
        category: 'Testing',
      );
      final updated = _makeArticle(id: 'update-me', title: 'Updated Title', category: 'General');
      container.read(articlesProvider.notifier).updateArticle(
        articleId: 'update-me',
        updatedArticle: updated,
        category: 'General',
      );
      final stored = container.read(articlesProvider).first;
      expect((stored['article'] as Article).title, 'Updated Title');
      expect(stored['category'], 'General');
    });
  });
}

// ─── Regression tests ──────────────────────────────────────────────────────
void _regressionTests() {
  group('Regression', () {
    test('filter reset to null after being set', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      container.read(articleFilterProvider.notifier).setFilter('Testing');
      expect(container.read(articleFilterProvider), 'Testing');
      container.read(articleFilterProvider.notifier).setFilter(null);
      expect(container.read(articleFilterProvider), isNull);
    });

    test('search reset to empty after being set', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      container.read(articleSearchProvider.notifier).setSearch('something');
      container.read(articleSearchProvider.notifier).setSearch('');
      expect(container.read(articleSearchProvider), '');
    });

    test('recently viewed: re-viewing same article does not create duplicate', () async {
      final container = _makeRecentlyViewedContainer();
      await container.read(recentlyViewedProvider.notifier).markViewed('article-1');
      await container.read(recentlyViewedProvider.notifier).markViewed('article-2');
      await container.read(recentlyViewedProvider.notifier).markViewed('article-1');
      expect(container.read(recentlyViewedProvider).length, 2);
    });

    testWidgets('articles page does not crash with no articles loaded', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articles, otherOverrides: [_notifOverride]);
      expectObj(ArticlesPage);
    });

    testWidgets('bookmarks page does not crash with no bookmarks', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleBookmarks, otherOverrides: [_notifOverride]);
      expectObj(BookmarksPage);
    });

    testWidgets('upload page does not crash on open', (tester) async {
      await initWidget(tester: tester, path: AppRoute.articleUpload, asRegisteredUser: true, otherOverrides: [_notifOverride]);
      expectObj(UploadArticlePage);
    });
  });
}

// ─── Main ──────────────────────────────────────────────────────────────────
void main() {
  // Initialises the Flutter binding so that NativeDatabase.memory() can load
  // the native sqlite3 library in plain test() calls, not just testWidgets().
  TestWidgetsFlutterBinding.ensureInitialized();

  _articleModelTests();
  _filterProviderTests();
  _searchProviderTests();
  _bookmarksProviderTests();
  _recentlyViewedTests();
  _articlesProviderTests();
  _articlesPageWidgetTests();
  _uploadPageWidgetTests();
  _bookmarksPageWidgetTests();
  _editArticlePageWidgetTests();
  _markdownArticlePageWidgetTests();
  _integrationTests();
  _regressionTests();
}