import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/user/auth_form.dart';

// Input box's title
class InputLabel extends StatelessWidget {
  final String text;

  const InputLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    uiLogger.fine("Input label '$text' generated");
    return Align(
      alignment: AlignmentGeometry.centerLeft,
      child: Padding(
        padding: EdgeInsetsGeometry.directional(start: 4),
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.titleSmall!.copyWith(color: context.colors.textPrimary),
        ),
      ),
    );
  }
}

// Input box itself
class InputBox extends StatelessWidget {
  final String hint;
  final TextInputType keyboardType;
  final Widget? rightIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const InputBox({
    super.key,
    required this.hint,
    required this.keyboardType,
    this.rightIcon,
    this.obscureText = false,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    uiLogger.fine("Input box with hint '$hint' generated");
    return Column(
      children: [
        TextField(
          enableSuggestions: false,
          autocorrect: false,
          controller: controller,
          onChanged: onChanged,
          textAlignVertical: rightIcon != null
              ? TextAlignVertical.center
              : null,
          cursorColor: context.colors.mainColor,
          cursorErrorColor: context.colors.warning,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: rightIcon,
            filled: true,
            fillColor: context.colors.textBoxFill,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: context.colors.textBoxUnderline),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: context.colors.mainColor),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: context.colors.warning),
            ),
          ),
        ),
      ],
    );
  }
}

class InputError extends StatelessWidget {
  final String? text;
  const InputError({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    if (text == null || text!.isEmpty) {
      return const SizedBox.shrink(); // hide when no error
    }
    uiLogger.fine("Input error with text '$text' shown");
    return Container(
      padding: EdgeInsetsGeometry.symmetric(vertical: baseLength / 2),
      alignment: AlignmentGeometry.centerLeft,
      child: Text(
        text!,
        style: Theme.of(
          context,
        ).textTheme.labelMedium!.copyWith(color: context.colors.warning),
      ),
    );
  }
}

class StandardEmailField extends ConsumerWidget {
  final AuthFormNotifierProvider provider;
  final TextEditingController controller;
  const StandardEmailField({
    super.key,
    required this.provider,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      cursorColor: context.colors.mainColor,
      cursorErrorColor: context.colors.warning,
      decoration: standardFormDeco(
        context,
        hintText: emailHint,
        labelText: 'Email Address',
        errorText: state.emailError,
      ),
      onChanged: notifier.onEmailChanged,
      validator: (e) => notifier.emailValidator(e),
    );
  }
}

class StandardPasswordField extends ConsumerWidget {
  final TextEditingController controller;
  final AuthFormNotifierProvider provider;
  final String? Function(String?)? validator;

  final String? labelText;
  final String? errorText;
  final bool? obscureText;
  final VoidCallback? toggleVisibility;
  final void Function(String)? onChanged;

  const StandardPasswordField({
    super.key,
    required this.controller,
    this.validator,
    this.labelText,
    this.errorText,
    this.obscureText,
    required this.provider,
    this.toggleVisibility,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: obscureText ?? state.hidePassword,
      enableSuggestions: false,
      autocorrect: false,
      decoration: standardFormDeco(
        context,
        hintText: passwordHint,
        labelText: labelText ?? "Password",
        errorText: errorText ?? state.passwordError,
        suffixIcon: IconButton(
          tooltip: obscureText ?? state.hidePassword
              ? 'Show password'
              : 'Hide password',
          icon: Icon(
            obscureText ?? state.hidePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: toggleVisibility ?? notifier.toggleHidePassword,
          color: context.colors.textBoxIcon,
        ),
      ),
      onChanged: onChanged ?? notifier.onPasswordChanged,
      validator: validator ?? (p) => notifier.passwordValidator(p),
    );
  }
}

InputDecoration standardFormDeco(
  BuildContext context, {
  String? hintText,
  String? labelText,
  String? errorText,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    labelText: labelText,
    errorText: errorText,
    prefixStyle: TextStyle(color: context.colors.textPrimary),
    floatingLabelStyle: TextStyle(color: context.colors.mainColor),
    errorStyle: TextStyle(color: context.colors.warning),
    suffixIcon: suffixIcon,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: context.colors.textBoxUnderline),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: context.colors.mainColor),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: context.colors.warning),
    ),
  );
}
