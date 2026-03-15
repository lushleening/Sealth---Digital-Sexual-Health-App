import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/frontend/common_widgets/warning_btn.dart';

class EditFieldsBtn extends StatelessWidget {
  final VoidCallback toggleEditState;
  const EditFieldsBtn({super.key, required this.toggleEditState});

  @override
  Widget build(BuildContext context) {
    return AlertBtn(
      icon: Icons.edit,
      text: "Edit Profile Fields",
      color: context.colors.mainColor,
      onPressed: toggleEditState,
    );
  }
}
