import 'package:flutter_test/flutter_test.dart';


void main() {
  group("Forgot Password Page", () {
    // testWidgets("Navigate from personal info page", (tester) async {
    //   final container = await initWidget(
    //     tester: tester,
    //     path: AppRoute.personalInfo,
    //     asRegisteredUser: true,
    //   );
    //   await tap(tester, find.byKey(KBtn.piChangePassword.key));
    //   await tap(tester, find.byKey(KBtn.choiceDialogYes.key));
    //   expectPath(container, AppRoute.changePassword);
    // });

    // testWidgets("UI Renders Correctly", (tester) async {
    //   await initWidget(tester: tester, path: AppRoute.resetPassword);
    //   expectObj(ResetPasswordPage);
    //   expectObj(ResetPasswordHeader);
    //   expectObj(ResetPasswordInput);
    // });
  });

  // TODO After I figure out how to bypass the google sign in, supabase auth and directly nav to forgot password
  // TODO also pushing paths with params
}

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
