import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/personal_info/edit_details/edit_details_form.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/frontend/common_widgets/user_avatar.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/personal_info/personal_info.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/personal_info/widgets/change_password_btn.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/personal_info/widgets/delete_local_cache_btn.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/personal_info/widgets/edit_fields_btn.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/personal_info/widgets/username_edit_field.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

void main() {
  group("Personal Info Page", () {
    testWidgets("Navigate to/from profile page as registered user", (
      tester,
    ) async {
      await testPageBackButtons(
        tester: tester,
        start: AppRoute.profile,
        toSubPageBtn: KBtn.navPersonalInfo,
        targetPath: AppRoute.personalInfo,
        backButton: KBtn.navBackButton,
        asRegisteredUser: true,
      );
    });

    testWidgets("UI Renders Correctly", (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.personalInfo,
        asRegisteredUser: true,
      );
      expectObj(PersonalInfoPage);
      expectObj(UserAvatar);
      expectObj(EditUsername);
      expectObj(EditFieldsBtn);
      expectObj(ChangePasswordBtn);
      expectObj(DeleteLocalCacheBtn);
    });

    testWidgets("Fields are uneditable without pressing EditFieldsBtn first", (
      tester,
    ) async {
      final container = await initWidget(
        tester: tester,
        path: AppRoute.personalInfo,
        asRegisteredUser: true,
      );

      // Before tapping edit button
      final before = container.read(editDetailsFormProvider).inputEnabled;

      // Blocks writing of text field
      final TextFormField picu = tester.widget(
        find.byKey(KBtn.piChangeUsername.key),
      );
      expect(picu.enabled, isFalse);

      // After tapping edit button
      await tap(tester, find.byKey(KBtn.piToggleEditable.key));
      await tester.pumpAndSettle();

      final after = container.read(editDetailsFormProvider).inputEnabled;
      // Allows writing to the field
      final TextFormField picu2 = tester.widget(
        find.byKey(KBtn.piChangeUsername.key),
      );
      expect(picu2.enabled, isTrue);

      expect(before, isNot(after));
    });

    testWidgets("Editing fields", (tester) async {
      final container = await initWidget(
        tester: tester,
        path: AppRoute.personalInfo,
        asRegisteredUser: true,
      );
      await tap(tester, find.byKey(KBtn.piToggleEditable.key));

      await tester.enterText(
        find.byKey(KBtn.piChangeUsername.key),
        newUsername,
      );
      await tap(tester, find.byKey(KBtn.piSaveUsername.key));

      // TODO test
      print(await container.read(appRegisteredProfileProvider.future));

    });
  });
  // Clipboard copy is provided by in-built functionality thus not testing it
}
