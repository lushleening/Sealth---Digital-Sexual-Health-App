import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/profile.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../helper/test_helper.dart';

void main() {
  group("Profile Page", () {
    testWidgets("Navigate to/from home page", (tester) async {
      await testPageBackButtons(
        tester: tester,
        start: AppRoute.home,
        toSubPageBtn: KBtn.navProfile,
        targetPath: AppRoute.profile,
        backButton: KBtn.navBackButton,
      );
    });

    group("UI Renders Correctly", () {
      testWidgets("For Guest", (tester) async {
        await initWidget(
          tester: tester,
          path: AppRoute.profile,
          asRegisteredUser: false,
        );
        expectObj(ProfilePage);
        expectObj(KBtn.navPersonalInfo, m: findsNothing);
        expectObj(KBtn.authSignOut, m: findsNothing);
      });
      testWidgets("For Registered Users", (tester) async {
        await initWidget(
          tester: tester,
          path: AppRoute.profile,
          asRegisteredUser: true,
        );
        expectObj(ProfilePage);
        expectObj(KBtn.authRemoveGuestData, m: findsNothing);
      });
    });

    // TODO Guest registered user diff
    // TODO log out test
    //   testWidgets("Sign Out", (tester) async {
    //     final container = await goToSubPageFromStart(
    //       tester: tester,
    //       btnList: [KBtn.homeBottomNav, KBtn.navProfileAvatar],
    //       target: KPage.profile,
    //     );

    //     // Press no
    //     await tap(tester, find.byKey(KBtn.logoutBtn.key));
    //     expectPage(KPage.logoutDialog);
    //     await tap(tester, find.byKey(KBtn.choiceDialogNo.key));
    //     expectPage(KPage.profile);
    //     expect(container.read(appStatusProvider), AppStatus.authenticated);

    //     // Press yes
    //     await tap(tester, find.byKey(KBtn.logoutBtn.key));
    //     expectPage(KPage.logoutDialog);
    //     await tap(tester, find.byKey(KBtn.choiceDialogYes.key));
    //     expect(container.read(appStatusProvider), AppStatus.unauthenticated);
    //   });
  });
}
