import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/common_widgets/choice_dialog.dart';

import '../../helper/test_helper.dart';

void main() {
  group("Bottom Navigation Bar", () {
    const home = AppRoute.home;

    testWidgets("Navigates user to all app's main pages", (tester) async {
      final container = await initWidget(tester: tester, path: home);
      expectPath(container, home);
      for (final p in AppRoute.mainPages.entries) {
        await tap(tester, find.byKey(p.value.key));
        expectPath(container, p.key);
      }
    });

    group("Using system (phone) back button", () {
      group("From other pages returns to home page", () {
        for (final path in AppRoute.mainPages.keys) {
          if (path == AppRoute.home) continue;
          testWidgets("From $path returns to home page", (tester) async {
            final container = await initWidget(tester: tester, path: path);
            await systemBack(tester);
            expectPath(container, home);
          });
        }
      });

      testWidgets("From home page does not change page, and shows quit popup", (
        tester,
      ) async {
        final container = await initWidget(tester: tester, path: AppRoute.home);
        await systemBack(tester);
        expectPath(container, home);
        expectObj(ChoiceDialog); // Quit dialog exists
        // Quit function is provided from external packages thus not testing it
      });
    });
  });
}
