import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/common_widgets/main_scaffold.dart';
import 'package:sddp_dsh/nav/main_page_route.dart';
import 'package:sddp_dsh/testing/key_enum.dart';

import '../helper/test_helper.dart';

void main() {
  group("Bottom Navigation Bar", () {
    testWidgets("Navigates user to all app's main pages", (tester) async {
      final container = await initWidget(tester: tester, home: MainScaffold());
      expectMainPage(container, MainPageRoute.home);
      for (final k in MainPageRoute.values) {
        await tap(tester, find.byKey(k.from.key));
        expectMainPage(container, k);
      }
    });

    group("Using system (phone) back button", () {
      const home = MainPageRoute.home;

      group("From other pages returns to home page", () {
        for (final idx in MainPageRoute.values) {
          if (idx == home) continue;
          testWidgets("From $idx returns to home page", (tester) async {
            final container = await startFromMainScaffold(tester, idx);
            await systemBack(tester);
            expectMainPage(container, home);
          });
        }
      });

      testWidgets("From home page does not change page", (tester) async {
        final container = await startFromMainScaffold(tester, home);
        await systemBack(tester);
        expectMainPage(container, home);
      });
    });
  });
}
