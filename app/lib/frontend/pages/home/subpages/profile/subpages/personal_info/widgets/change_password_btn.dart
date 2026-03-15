import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/frontend/common_widgets/warning_btn.dart';

class ChangePasswordBtn extends ConsumerWidget {
  final VoidCallback changePassword;
  const ChangePasswordBtn({super.key, required this.changePassword});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertBtn(
      icon: Icons.password,
      text: "Change Password",
      color: context.colors.textPrimary,
      onPressed: changePassword,
    );
  }
}
