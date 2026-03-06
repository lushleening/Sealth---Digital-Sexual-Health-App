import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/login.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../helper/test_helper.dart';

void main() {
  group("Forgot Password Page", () {
    testWidgets("Navigate to/from login page", (tester) async {
      await testSubPageBackButtons(
        tester: tester,
        start: const LoginPage(),
        toSubPageBtn: KBtn.navForgotPasswordLink,
        target: KPage.forgotPassword,
      );
    });
  });

  // TODO Reset password logic not implemented and stabilized yet thus don't do that first
  // TODO backend test
}
