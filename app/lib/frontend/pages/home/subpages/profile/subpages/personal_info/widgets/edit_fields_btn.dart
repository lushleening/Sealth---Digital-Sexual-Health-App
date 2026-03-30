import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/personal_info/edit_details/edit_details_form.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/common_widgets/warning_btn.dart';

class EditFieldsBtn extends ConsumerWidget {
  const EditFieldsBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertBtn(
      key: KBtn.piToggleEditable.key,
      icon: Icons.edit,
      text: "Edit Profile Fields",
      color: context.colors.mainColor,
      onPressed: () => ref
          .read(editDetailsFormProvider.notifier)
          .toggleInputEnabled(),
    );
  }
}
