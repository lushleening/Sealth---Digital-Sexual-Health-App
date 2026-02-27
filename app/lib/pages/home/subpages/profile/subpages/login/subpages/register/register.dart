import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/common_widgets/safe_container.dart';
import 'package:sddp_dsh/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/helper/safe_nav.dart';
import 'package:sddp_dsh/helper/snackbar_message.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/login/subpages/register/widgets/register_header.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/login/subpages/register/widgets/register_input.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.fine("Register page generated.");
    return SafeContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TopAppBar(
          title: "",
          fg: context.colors.textPrimary,
          bg: context.colors.whiteBackground,
        ),
        body: SafeContainer(
          child: SingleChildScrollView(
            padding: EdgeInsetsGeometry.all(baseLength),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const RegisterHeader(),
                  RegisterInput(
                    successCallback: () async {
                      showSnackbarMessage(
                        "Registration successful. Please log in.",
                      );
                      navPop(context, ref);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
