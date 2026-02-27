import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/nav/app_navigation_lock.dart';
import 'package:sddp_dsh/nav/main_page_route.dart';
import 'package:sddp_dsh/testing/key_enum.dart';

import '../helper/test_helper.dart';

void main() {
  group("Main Pages Set Page Navigation Lock", () {
    const src = MainPageRoute.home;
    const dest = MainPageRoute.discussion;

    testWidgets("Allows normal navigation", (tester) async {
      final container = await startFromMainScaffold(tester, src);
      container.read(mainPageRouteProvider.notifier).setPage(dest);
      await tester.pumpAndSettle();
      expectMainPage(container, dest);
    });

    testWidgets("Blocks navigation on lock", (tester) async {
      final container = await startFromMainScaffold(tester, src);
      container.read(appNavigationLockProvider.notifier).lock(); // Manual lock
      container.read(mainPageRouteProvider.notifier).setPage(dest);
      expectMainPage(container, src);
    });
  });

  group("Subpages Navigation Push / Pop Lock", () {
    const src = MainPageRoute.home;
    const btn = KBtn.navNotificationBell;
    const dest = KPage.notification;

    testWidgets("Allows normal navigation", (tester) async {
      await startFromMainScaffold(tester, src);
      await tap(tester, find.byKey(btn.key));
      expectObj(dest);
    });

    testWidgets("Blocks navigation on lock", (tester) async {
      final container = await startFromMainScaffold(tester, src);
      container.read(appNavigationLockProvider.notifier).lock(); // Manual lock
      await tap(tester, find.byKey(btn.key));
      expectObj(src.to);
    });
  });
}
