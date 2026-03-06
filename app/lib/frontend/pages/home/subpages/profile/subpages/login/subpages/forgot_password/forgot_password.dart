import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/constants/textbox_hints.dart';
import 'package:sddp_dsh/frontend/common_widgets/input_box.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/authentication/auth_form/auth_form.dart';

final forgotFormProvider = authFormProvider(AuthFormType.forgotPassword);

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotFormProvider);
    final notifier = ref.read(forgotFormProvider.notifier);
    uiLogger.fine("Forgot Password Page generated.");

    return SafeContainer(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: TopAppBar(
          title: "Forgot Password?",
          fg: context.colors.textPrimary,
          bg: context.colors.whiteBackground,
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsetsGeometry.all(baseLength),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: baseLength,
                children: [
                  InputLabel(
                    text: "Enter your email and click to verify your identity:",
                  ),
                  InputBox(
                    controller: _controller,
                    onChanged: notifier.onEmailChanged,
                    hint: emailHint,
                    keyboardType: TextInputType.emailAddress,
                    rightIcon: IconButton(
                      style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(
                          context.colors.whiteBackground,
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          context.colors.mainColor,
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(4),
                          ),
                        ),
                      ),
                      icon: Icon(Icons.link),
                      onPressed: () {
                        final email = _controller.text.trim();
                        notifier.submit(email: email);
                      },
                    ),
                  ),
                  InputError(text: state.emailError),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// TODO Notes
// Forgotpassword + register + supabaseauth
// Loading init
// Notification
// Supabase storage
