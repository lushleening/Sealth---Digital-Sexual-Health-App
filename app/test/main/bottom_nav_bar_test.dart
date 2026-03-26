import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/navigation/main_page_route.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../helper/test_helper.dart';

void main() {
  group("Bottom Navigation Bar", () {
    const home = KPage.home;

    testWidgets("Navigates user to all app's main pages", (tester) async {
      await initWidget(tester: tester, path: AppRoute.home);
      expectObj(home);
      for (final k in MainPageRoute.values) {
        await tap(tester, find.byKey(k.from.key));
        expectObj(k.to.key);
      }
    });

    group("Using system (phone) back button", () {
      group("From other pages returns to home page", () {
        for (final path in AppRoute.mainPages) {
          if (path == AppRoute.home) continue;
          testWidgets("From $path returns to home page", (tester) async {
            await initWidget(tester: tester, path: path);
            await systemBack(tester);
            expectObj(home);
          });
        }
      });

      // TODO test popups
      testWidgets("From home page does not change page", (tester) async {
        await initWidget(tester: tester, path: AppRoute.home);
        await systemBack(tester);
        expectObj(home);
      });
    });
  });
}
