import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/frontend/common_widgets/input_box.dart';
import 'package:sddp_dsh/frontend/common_widgets/main_scaffold.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/navigation/safer_navigation/safer_navigation.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/login/subpages/forgot_password/forgot_password.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/authentication/auth_form/auth_form.dart';

final loginFormProvider = authFormProvider(AuthFormType.login);

class LoginInput extends ConsumerStatefulWidget {
  const LoginInput({super.key});

  @override
  ConsumerState<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends ConsumerState<LoginInput> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    uiLogger.fine("Login input generated.");
    return Padding(
      padding: EdgeInsetsGeometry.all(baseLength / 4),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: baseLength,
          children: [
            const SizedBox(),
            StandardEmailField(
              controller: _emailController,
              provider: loginFormProvider,
            ),
            Column(
              children: [
                StandardPasswordField(
                  controller: _passwordController,
                  provider: loginFormProvider,
                ),
                const LoginForgotPasswordBtn(),
              ],
            ),
            LoginBtn(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginBtn extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const LoginBtn({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginFormProvider);
    return SizedBox(
      width: longBtnWidth,
      height: longBtnHeight,
      child: ElevatedButton(
        onPressed: () async {
          FocusScope.of(context).unfocus();
          if (!state.submitting && formKey.currentState!.validate()) {
            final notifier = ref.read(loginFormProvider.notifier);
            final result = await notifier.submit(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

            // TODO find a better way to do this
            if (result && context.mounted) {
              notifier.clearAllErrors();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainScaffold()),
                (route) => false,
              );
              showSnackbarMessage("You have successfully logged in.");
            }
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: context.colors.textWhite,
          backgroundColor: context.colors.mainColor,
        ),
        child: state.submitting
            ? Padding(
                padding: EdgeInsetsGeometry.all(4),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: context.colors.textWhite,
                ),
              )
            : Text(
                "Log In",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: context.colors.textWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

class LoginForgotPasswordBtn extends ConsumerWidget {
  const LoginForgotPasswordBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        key: KBtn.navForgotPasswordLink.key,
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () => navPush(
          context,
          ref,
          ForgotPasswordPage(key: KPage.forgotPassword.key),
        ),
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: context.colors.mainColor),
        ),
      ),
    );
  }
}
