import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/login.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/widgets/login_header.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/widgets/login_input.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/widgets/login_register_footer.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/widgets/login_choice_popup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

void main() {
  group("Login Page", () {
    testWidgets("Navigate to/from profile page", (tester) async {
      // Only guest mode can login
      final container = await initWidget(
        tester: tester,
        path: AppRoute.profile,
      );

      await tap(tester, find.byKey(KBtn.navSignIn.key));
      expectObj(LoginChoicePopup);

      await tap(tester, find.byKey(KBtn.navSignInEmail.key));
      expectPath(container, AppRoute.login);

      await tap(tester, find.byKey(KBtn.navBackButton.key));
      expectPath(container, AppRoute.profile);
    });

    testWidgets("UI Renders Correctly", (tester) async {
      await initWidget(tester: tester, path: AppRoute.login);
      expectObj(LoginPage);
      expectObj(LoginHeader);
      expectObj(LoginInput);
      expectObj(LoginRegisterFooter);
    });
  });

  testWidgets(
    "Filling in valid credentials successfully calls the sign in method",
    (tester) async {
      final mock = MockSupabaseAuth();
      when(() => mock.loginWithEmailPassword(any(), any())).thenAnswer((
        _,
      ) async {
        return AuthResponse();
      });

      await initWidget(
        tester: tester,
        path: AppRoute.login,
          otherOverrides: [supabaseAuthProvider.overrideWithValue(mock)],
      );

      await tester.enterText(find.byKey(KBtn.emailSignIn.key), email);
      await tester.enterText(find.byKey(KBtn.passwordSignIn.key), newPassword);
      await tap(tester, find.byKey(KBtn.submitSignIn.key));
      verify(
        () => mock.loginWithEmailPassword(email, newPassword),
      ).called(1);
    },
  );
}
