import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/profile.dart';
import 'package:sddp_dsh/testing/key_enum.dart';

import '../helper/test_helper.dart';

void main() {
  // TODO This test requires profile backend to be completed
  group("Personal Info Page", () {
    testWidgets("Navigate to/from profile page as registered user", (
      tester,
    ) async {
      await testSubPageBackButtons(
        tester: tester,
        start: const ProfilePage(),
        toSubPageBtn: KBtn.navPersonalInfoBtn,
        target: KPage.personalInfo,
        backButton: KBtn.backButton,
        asRegisteredUser: true,
      );
    });

    // TODO after implementing personal info page backend and stabalize profile tables
    // testWidgets("UI Renders Correctly", (tester) async {
    //   await initWidget(tester: tester, home: const PersonalInfoPage());
    // });
  });
}
