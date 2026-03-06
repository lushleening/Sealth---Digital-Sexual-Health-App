import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/login.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/register/register.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/register/widgets/register_header.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/register/widgets/register_input.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../helper/test_helper.dart';

void main() {
  group("Sign Up Page", () {
    testWidgets("Navigate to/from login page", (tester) async {
      await testSubPageBackButtons(
        tester: tester,
        start: const LoginPage(),
        toSubPageBtn: KBtn.navRegisterLink,
        target: KPage.register,
      );
    });

    testWidgets("UI Renders Correctly", (tester) async {
      await initWidget(tester: tester, home: const RegisterPage());
      expectObj(RegisterHeader);
      expectObj(RegisterInput);
    });

    // TODO wait for backend stabilize
  });
}
