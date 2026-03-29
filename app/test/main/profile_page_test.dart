import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:sddp_dsh/frontend/common_widgets/choice_dialog.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/profile.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../helper/mock_objects.dart';
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
        expectObj(KBtn.authRemoveGuestData);
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
        expectObj(KBtn.navPersonalInfo);
        expectObj(KBtn.authSignOut);
      });
    });

    testWidgets("Guest: Remove Guest Data", (tester) async {
      final container = await initWidget(
        tester: tester,
        path: AppRoute.profile,
        asRegisteredUser: false,
      );

      final before = (await container.read(appUserProvider.future)).localId;

      // Press no closes dialog
      await tap(tester, find.byKey(KBtn.authRemoveGuestData.key));
      expectObj(ChoiceDialog);
      await tap(tester, find.byKey(KBtn.choiceDialogNo.key));
      expectObj(ChoiceDialog, m: findsNothing);

      // Press yes runs function
      await tap(tester, find.byKey(KBtn.authRemoveGuestData.key));
      expectObj(ChoiceDialog);
      await tap(tester, find.byKey(KBtn.choiceDialogYes.key));
      expectObj(ChoiceDialog, m: findsNothing);

      final after = (await container.read(appUserProvider.future)).localId;

      // LocalId will change on remove guest data
      expect(before, isNot(after));
    });

    testWidgets("Registered User: Sign Out", (tester) async {
      // Just mock supabase auth and check if function is called
      final mockSupabaseAuth = MockSupabaseAuth();
      when(() => mockSupabaseAuth.signOut()).thenAnswer((_) async {});

      await initWidget(
        tester: tester,
        path: AppRoute.profile,
        asRegisteredUser: true,
        mockSupabaseAuth: mockSupabaseAuth,
      );

      // Press no closes dialog
      await tap(tester, find.byKey(KBtn.authSignOut.key));
      expectObj(ChoiceDialog);
      await tap(tester, find.byKey(KBtn.choiceDialogNo.key));
      expectObj(ChoiceDialog, m: findsNothing);

      // Press yes runs function
      await tap(tester, find.byKey(KBtn.authSignOut.key));
      expectObj(ChoiceDialog);
      await tap(tester, find.byKey(KBtn.choiceDialogYes.key));
      expectObj(ChoiceDialog, m: findsNothing);

      verify(() => mockSupabaseAuth.signOut()).called(1);
    });
  });
}
