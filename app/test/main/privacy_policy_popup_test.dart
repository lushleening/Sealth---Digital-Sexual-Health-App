import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/privacy_policy/privacy_policy_popup.dart';
import 'package:sddp_dsh/testing/key_enum.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/profile.dart';

import '../helper/test_helper.dart';

void main() {
  group("Privacy Policy Popup", () {
    testWidgets("Navigate to/from profile page", (tester) async {
      await testSubPageBackButtons(
        tester: tester,
        start: const ProfilePage(),
        toSubPageBtn: KBtn.navPrivacyPolicyBtn,
        target: KPage.privacyPolicy,
        backButton: KBtn.closePopup,
      );
    });

    testWidgets("UI Renders Correctly", (tester) async {
      await initWidget(tester: tester, home: const PrivacyPolicyPopup());
      expect(find.text(privacyPolicyText), findsOneWidget);
      expectObj(KBtn.closePopup);
    });
  });
}
