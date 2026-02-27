import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/login/login.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/login/widgets/login_header.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/login/widgets/login_input.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/login/widgets/login_register_footer.dart';

import '../helper/test_helper.dart';

void main() {
  group("Login Page", () {
    testWidgets("UI Renders Correctly", (tester) async {
      await initWidget(tester: tester, home: const LoginPage());
      expectObj(LoginHeader);
      expectObj(LoginInput);
      expectObj(LoginRegisterFooter);
    });
    // TODO auth test
  });
}
