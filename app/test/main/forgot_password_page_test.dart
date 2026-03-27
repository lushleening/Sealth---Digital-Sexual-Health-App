import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../helper/test_helper.dart';

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
  });
}
