import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/frontend/common_widgets/warning_btn.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/widgets/profile_footer.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/widgets/profile_user_card.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../helper/test_helper.dart';

void main() {
  group("Profile Page", () {
    testWidgets("Navigate to/from home page", (tester) async {
      await testSubPageBackButtons(
        tester: tester,
        start: AppRoute.home,
        toSubPageBtn: KBtn.navProfileAvatar,
        target: KPage.profile,
        backButton: KBtn.backButton,
      );
    });

    group("UI Renders Correctly", () {
      testWidgets("For Guest", (tester) async {
        await initWidget(
          tester: tester,
          path: AppRoute.profile,
          asRegisteredUser: false,
        );
        expectObj("Profile");
        expectObj(ProfileUserCard);
        expectObj(KBtn.navSettingsBtn);
        expectObj(KBtn.navAboutBtn);
        expectObj(KBtn.navPrivacyPolicyBtn);
        expectObj(KBtn.removeGuestData);
        expectObj(ProfileFooter);
      });
      testWidgets("For Registered Users", (tester) async {
        await initWidget(
          tester: tester,
          path: AppRoute.profile,
          asRegisteredUser: true,
        );
        expectObj("Profile");
        expectObj(ProfileUserCard);
        expectObj(KBtn.navPersonalInfoBtn);
        expectObj(KBtn.navSettingsBtn);
        expectObj(KBtn.navAboutBtn);
        expectObj(KBtn.navPrivacyPolicyBtn);
        expectObj(AlertBtn);
        expectObj(ProfileFooter);
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
