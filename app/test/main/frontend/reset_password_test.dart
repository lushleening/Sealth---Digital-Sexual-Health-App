import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
          mockSupabaseAuth: mock,
        );

        await tester.enterText(
          find.byKey(KBtn.emailForgotPassword.key),
          mockEmail,
        );
        await tap(tester, find.byKey(KBtn.submitForgotPassword.key));
        verify(() => mock.sendResetEmail(mockEmail)).called(1);
      },
    );
  });
}


// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:sddp_dsh/backend/constants/routes.dart';
// import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
// import 'package:sddp_dsh/frontend/common_widgets/top_appbar.dart';
// import 'package:sddp_dsh/backend/colors/colors/colors.dart';
// import 'package:sddp_dsh/backend/constants/ui_design.dart';
// import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
// import 'package:sddp_dsh/backend/logging/app_loggers.dart';
// import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/forgot_password/subpages/widgets/reset_password_header.dart';
// import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/forgot_password/subpages/widgets/reset_password_input.dart';

// class ResetPasswordPage extends StatelessWidget {
//   final bool loggedIn;
//   final String email;
//   const ResetPasswordPage({
//     super.key,
//     required this.email,
//     required this.loggedIn,
//   });

//   @override
//   Widget build(BuildContext context) {
//     uiLogger.finer("Reset Password page generated.");
//     return SafeContainer(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: TopAppBar(
//           title: "Reset Password",
//           fg: context.colors.textPrimary,
//           bg: context.colors.whiteBackground,
//         ),
//         body: SafeContainer(
//           child: SingleChildScrollView(
//             padding: EdgeInsetsGeometry.all(baseLength),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const ResetPasswordHeader(),
//                 ResetPasswordInput(
//                   email: email,
//                 successCallback: () {
//                     if (loggedIn) {
//                       showSnackbarMessage(
//                         "Your password has been changed successfully.",
//                       );
//                     } else {
//                       showSnackbarMessage(
//                         "Password reset successful. Please log in.",
//                       );
//                       context.go(AppRoute.resetLogin);
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
