import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../../helper/test_helper.dart';

void main() {
  testWidgets('Upload Article Page renders correctly', (
    WidgetTester tester,
  ) async {
    await initWidget(tester: tester, path: AppRoute.uploadArticles);

    // Upload components exist
    expectObj(KBtn.uploadPdfBtn);
    expectObj(KBtn.uploadImageBtn);
    expectObj(KBtn.uploadArticleBtn);
  });

  testWidgets('Upload button is tappable', (WidgetTester tester) async {
    await initWidget(tester: tester, path: AppRoute.uploadArticles);
    await tap(tester, find.byKey(KBtn.uploadArticleBtn.key));
  });

  testWidgets('Tapping bookmark icon navigates to BookmarksPage', (
    WidgetTester tester,
  ) async {
    await initWidget(tester: tester, path: AppRoute.articles);
    await tap(tester, find.byKey(KBtn.navBookmarkBtn.key));
    expectObj(KPage.bookmarks);
  });

  testWidgets('Tapping article navigates to ArticleReaderPage', (
    WidgetTester tester,
  ) async {
    await initWidget(tester: tester, path: AppRoute.articles);
    await tap(tester, find.byKey(KBtn.articleCard.key));
    expectObj(KPage.article);
  });
}
