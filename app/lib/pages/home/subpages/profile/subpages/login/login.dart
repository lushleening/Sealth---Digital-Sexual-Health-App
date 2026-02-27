import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/common_widgets/safe_container.dart';
import 'package:sddp_dsh/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/login/widgets/login_header.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/login/widgets/login_input.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/login/widgets/login_register_footer.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.fine("Login Page Generated");

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
            child: Column(
              spacing: baseLength / 2,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LoginHeader(),
                const LoginInput(),
                const LoginRegisterFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
