import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/frontend/common_widgets/blank_pages.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

// Able to edit user's personal information
class PersonalInfoPage extends ConsumerWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.finer("Personal info Page generated.");
    return blankPageWithAppBar(context, "Personal Information");
  }
}
