import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/biometric/biometric_confirmation.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/users_repository.dart';
import 'package:sddp_dsh/backend/personal_info/edit_details/edit_details_form.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
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

    testWidgets("Returns nothing on not a registered user", (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.personalInfo,
        asRegisteredUser: false,
      );
      expectObj(UserAvatar, m: findsNothing);
      expectObj(EditUsername, m: findsNothing);
      expectObj(EditFieldsBtn, m: findsNothing);
      expectObj(ChangePasswordBtn, m: findsNothing);
      expectObj(DeleteLocalCacheBtn, m: findsNothing);
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

    testWidgets("Editing fields works as expected", (tester) async {
      final container = await initWidget(
        tester: tester,
        path: AppRoute.personalInfo,
        asRegisteredUser: true,
      );
      await tap(tester, find.byKey(KBtn.piToggleEditable.key));
      expect(container.read(editDetailsFormProvider).inputEnabled, true);

      await tester.enterText(
        find.byKey(KBtn.piChangeUsername.key),
        newUsername,
      );
      await tap(tester, find.byKey(KBtn.piSaveUsername.key));
      expect(container.read(editDetailsFormProvider).inputEnabled, false);
    });
  });

  testWidgets("Changing passwords works as expected", (tester) async {
    final mockBio = MockBiometricConfirmation();
    final mockAuth = MockSupabaseAuth();

    when(
      () => mockBio.tryBiometricConfirmation(),
    ).thenAnswer((_) async => true);

    when(() => mockAuth.email).thenReturn(email);

    final container = await initWidget(
      tester: tester,
      path: AppRoute.personalInfo,
      asRegisteredUser: true,
      otherOverrides: [
        biometricConfirmationProvider.overrideWithValue(mockBio),
        supabaseAuthProvider.overrideWithValue(mockAuth),
      ],
    );

    await tap(tester, find.byKey(KBtn.piChangePassword.key));
    await tap(tester, find.byKey(KBtn.choiceDialogYes.key));
    expectPath(container, AppRoute.changePassword);
  });

  testWidgets("Delete local cache button works as expected", (
    tester,
  ) async {
    final mockUsersRepo = MockUsersRepository();
    final mockAuth = MockSupabaseAuth();
    final mockBio = MockBiometricConfirmation();

    when(
      () => mockBio.tryBiometricConfirmation(),
    ).thenAnswer((_) async => true);

    when(
      () => mockUsersRepo.deleteRegisteredUserLocalCache(any()),
    ).thenAnswer((_) async => true);

    when(() => mockAuth.signOut()).thenAnswer((_) async => true);

    await initWidget(
      tester: tester,
      asRegisteredUser: true,
      path: AppRoute.personalInfo,
      otherOverrides: [
        usersRepositoryProvider.overrideWithValue(mockUsersRepo),
        supabaseAuthProvider.overrideWithValue(mockAuth),
        biometricConfirmationProvider.overrideWithValue(mockBio),
      ],
    );

    await tap(tester, find.byKey(KBtn.piDeleteLocalCache.key));
    await tap(tester, find.byKey(KBtn.choiceDialogYes.key));

    verify(() => mockUsersRepo.deleteRegisteredUserLocalCache(any())).called(1);
    verify(() => mockAuth.signOut()).called(1);
  });
}
