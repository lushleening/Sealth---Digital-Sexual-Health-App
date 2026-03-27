import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../helper/test_helper.dart';

void main() {
  group("Personal Info Page", () {
    testWidgets("Navigate to/from profile page as registered user", (
      tester,
    ) async {
      await testSubPageBackButtons(
        tester: tester,
        start: AppRoute.profile,
        toSubPageBtn: KBtn.navPersonalInfo,
        targetPath: AppRoute.personalInfo,
        backButton: KBtn.navBackButton,
        asRegisteredUser: true,
      );
    });

    // TODO after implementing personal info page backend and stabalize profile tables
    // testWidgets("UI Renders Correctly", (tester) async {
    //   await initWidget(tester: tester, path: const PersonalInfoPage());
    // });
  });
}
