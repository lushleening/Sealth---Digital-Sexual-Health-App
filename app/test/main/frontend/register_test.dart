import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/register/register.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/register/widgets/register_header.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/register/widgets/register_input.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

void main() {
  group("Sign Up Page", () {
    testWidgets("Navigate to/from login page", (tester) async {
      await testPageBackButtons(
        tester: tester,
        start: AppRoute.login,
        toSubPageBtn: KBtn.navRegister,
        targetPath: AppRoute.register,
      );
    });

    testWidgets("UI Renders Correctly", (tester) async {
      await initWidget(tester: tester, path: AppRoute.register);
      expectObj(RegisterPage);
      expectObj(RegisterHeader);
      expectObj(RegisterInput);
    });

    testWidgets(
      "Filling in valid credentials successfully calls the sign up method",
      (tester) async {
        final mock = MockSupabaseAuth();
        when(() => mock.registerEmailPassword(any(), any())).thenAnswer((
          _,
        ) async {
          return AuthResponse();
        });

        await initWidget(
          tester: tester,
          path: AppRoute.register,
          mockSupabaseAuth: mock,
        );

        await tester.enterText(find.byKey(KBtn.emailRegister.key), mockEmail);
        await tester.enterText(
          find.byKey(KBtn.passwordRegister.key),
          mockPassword,
        );
        await tester.enterText(
          find.byKey(KBtn.confirmPasswordRegister.key),
          mockPassword,
        );
        await tap(tester, find.byKey(KBtn.submitRegister.key));
        verify(
          () => mock.registerEmailPassword(mockEmail, mockPassword),
        ).called(1);
      },
    );
  });
}
