import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/forgot_password/forgot_password.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

void main() {
  group("Forgot Password Page", () {
    testWidgets("Navigate to/from login page", (tester) async {
      await testPageBackButtons(
        tester: tester,
        start: AppRoute.login,
        toSubPageBtn: KBtn.navForgotPassword,
        targetPath: AppRoute.forgotPassword,
      );
    });

    testWidgets("UI Renders Correctly", (tester) async {
      await initWidget(tester: tester, path: AppRoute.forgotPassword);
      expectObj(ForgotPasswordPage);
    });

    testWidgets(
      "Filling in email successfully calls the email verification method",
      (tester) async {
        final mock = MockSupabaseAuth();
        when(() => mock.sendResetEmail(any())).thenAnswer((_) async {});
        await initWidget(
          tester: tester,
          path: AppRoute.forgotPassword,
          otherOverrides: [supabaseAuthProvider.overrideWithValue(mock)],
        );

        await tester.enterText(
          find.byKey(KBtn.emailForgotPassword.key),
          email,
        );
        await tap(tester, find.byKey(KBtn.submitForgotPassword.key));
        verify(() => mock.sendResetEmail(email)).called(1);
      },
    );
  });
}
