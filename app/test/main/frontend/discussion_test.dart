import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/frontend/pages/discussion/create_post_page.dart';

import '../../helper/test_helper.dart';

void main() {
  group("Discussion Page Tests", () {
    testWidgets("DiscussionPage shows all dummy posts initially", (
      tester,
    ) async {
      await initWidget(tester: tester, path: AppRoute.discussion);

      expectObj("Common Sexual Health Questions");
      expectObj("Understanding Anxiety in Teens");
      expectObj("Healthy Sleep Habits");
    });

    testWidgets("Search filters discussion posts correctly", (tester) async {
      await initWidget(tester: tester, path: AppRoute.discussion);

      // Enter search text
      await tester.enterText(find.byType(TextField), "sleep");
      await tester.pumpAndSettle();

      // Only Sleep post should remain
      expectObj("Healthy Sleep Habits");
      expectObj("Common Sexual Health Questions", m: findsNothing);
      expectObj("Understanding Anxiety in Teens", m: findsNothing);
    });

    testWidgets("Search shows empty list when no match found", (tester) async {
      await initWidget(tester: tester, path: AppRoute.discussion);

      await tester.enterText(find.byType(TextField), "xyz123");
      await tester.pumpAndSettle();

      expectObj("Common Sexual Health Questions", m: findsNothing);
      expectObj("Understanding Anxiety in Teens", m: findsNothing);
      expectObj("Healthy Sleep Habits", m: findsNothing);
    });

    testWidgets("FAB navigates to CreatePostPage", (tester) async {
      await initWidget(tester: tester, path: AppRoute.discussion);
      await tap(tester, find.byType(FloatingActionButton));
      expectObj(CreatePostPage);
    });
  });
}
