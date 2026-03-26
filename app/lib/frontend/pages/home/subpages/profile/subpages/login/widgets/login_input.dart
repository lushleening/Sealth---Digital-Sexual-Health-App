import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/frontend/common_widgets/input_box.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
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
    uiLogger.finer("Login input generated.");
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

            if (result && context.mounted) {
              notifier.clearAllErrors();
              context.go('/');
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
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          key: KBtn.navForgotPasswordLink.key,
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: baseLength / 2, vertical: 0),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: WidgetStatePropertyAll(context.colors.mainColor),
            overlayColor: WidgetStatePropertyAll(
              context.colors.mainColor.withValues(alpha: buttonOverlayAlpha),
            ),
          ),
          onPressed: () => context.go(AppRoutes.forgotPasswordP),
          child: const Text("Forgot Password?"),
        ),
      ),
    );
  }
}
