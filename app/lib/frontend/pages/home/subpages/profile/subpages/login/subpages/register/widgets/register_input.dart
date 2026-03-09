import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/frontend/common_widgets/input_box.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/authentication/auth_form/auth_form.dart';

final registerFormProvider = authFormProvider(AuthFormType.register);

class RegisterInput extends ConsumerStatefulWidget {
  final VoidCallback successCallback;
  const RegisterInput({super.key, required this.successCallback});

  @override
  ConsumerState<RegisterInput> createState() => _RegisterInputState();
}

class _RegisterInputState extends ConsumerState<RegisterInput> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerFormProvider);
    final notifier = ref.read(registerFormProvider.notifier);
    uiLogger.finer("Register input generated.");
    return Form(
      key: formKey,
      child: Column(
        spacing: baseLength,
        children: [
          const SizedBox(height: baseLength),

          StandardEmailField(
            controller: _emailController,
            provider: registerFormProvider,
          ),
          StandardPasswordField(
            provider: registerFormProvider,
            controller: _passwordController,
            errorText: state.passwordError,
          ),
          StandardPasswordField(
            provider: registerFormProvider,
            controller: _confirmPasswordController,

            labelText: "Confirm Password",
            obscureText: state.hideConfirmPassword,
            errorText: state.confirmPasswordError,
            toggleVisibility: notifier.toggleHideConfirmPassword,
            onChanged: notifier.onConfirmPasswordChanged,
            validator: (cp) =>
                notifier.confirmPasswordValidator(cp, _passwordController.text),
          ),

          // Register button
          const SizedBox(height: baseLength),
          SizedBox(
            width: longBtnWidth,
            height: longBtnHeight,
            child: ElevatedButton(
              onPressed: () async {
                final email = _emailController.text.trim();
                FocusScope.of(context).unfocus();
                if (!state.submitting && formKey.currentState!.validate()) {
                  final success = await notifier.submit(
                    email: email,
                    password: _passwordController.text.trim(),
                  );
                  if (success) {
                    notifier.clearAllErrors();
                    widget.successCallback();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: context.colors.textWhite,
                backgroundColor: context.colors.mainColor,
              ),
              child: state.submitting
                  ? Padding(
                      padding: EdgeInsetsGeometry.all(2),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        color: context.colors.textWhite,
                      ),
                    )
                  : Text(
                      "Sign Up",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: context.colors.textWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
