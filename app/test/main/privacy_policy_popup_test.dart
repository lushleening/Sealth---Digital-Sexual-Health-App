import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/privacy_policy/privacy_policy_popup.dart';

import '../helper/test_helper.dart';

void main() {
  group("Privacy Policy Popup", () {
    testWidgets("Navigate to/from profile page", (tester) async {
      await testPageBackButtons(
        tester: tester,
        start: AppRoute.profile,
        toSubPageBtn: KBtn.navPrivacyPolicy,
        targetObj: PrivacyPolicyPopup,
        backButton: KBtn.navClosePopup,
      );
    });

    testWidgets("UI Renders Correctly", (tester) async {
      await initWidget(tester: tester, path: AppRoute.profile);
      await tap(tester, find.byKey(KBtn.navPrivacyPolicy.key));
      expectObj(PrivacyPolicyPopup);
      expectObj(KBtn.navClosePopup);
    });
  });
}
