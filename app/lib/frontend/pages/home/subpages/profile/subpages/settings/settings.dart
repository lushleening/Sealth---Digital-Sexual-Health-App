import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/settings/widgets/all_settings.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.fine("Settings Page generated.");
    return SafeContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TopAppBar(
          title: "Settings",
          fg: context.colors.textPrimary,
          bg: context.colors.whiteBackground,
        ),
        body: ListView.builder(
          padding: EdgeInsetsGeometry.all(baseLength),
          itemCount: allSettings.length,
          itemBuilder: (context, idx) => allSettings[idx].build(context, ref),
        ),
      ),
    );
  }
}
