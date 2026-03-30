import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/about/about_popup.dart';

import '../../helper/test_helper.dart';

void main() {
  group("About Popup", () {
    testWidgets("Test popup shows/hides on button press in profile page", (
      tester,
    ) async {
      await testPageBackButtons(
        tester: tester,
        start: AppRoute.profile,
        toSubPageBtn: KBtn.navAbout,
        targetObj: AboutPopup, // As popups do not have a path
        backButton: KBtn.navClosePopup,
      );
    });

    testWidgets("UI Renders Correctly", (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.profile,
      );
      await tap(tester, find.byKey(KBtn.navAbout.key));
      expectObj(AboutPopup);
    });
  });
}
