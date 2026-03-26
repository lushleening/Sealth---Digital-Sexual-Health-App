import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../helper/test_helper.dart';

void main() {
  group("Notifications Page", () {
    testWidgets("Navigate to/from home page", (tester) async {
      await testSubPageBackButtons(
        tester: tester,
        start: AppRoute.home,
        toSubPageBtn: KBtn.navNotificationBell,
        target: KPage.notifications,
        backButton: KBtn.backButton,
      );
    });

    // TODO backend noti test
  });
}
