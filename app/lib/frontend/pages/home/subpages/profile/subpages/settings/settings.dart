import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/textbox_hints.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/settings/widgets/settings_ui.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/settings/widgets/settings_block.dart';

final appSettings = [
  BoolSettingUI(
    kBtn: KBtn.settingsDarkMode,
    icon: Icons.dark_mode_outlined,
    title: "Dark Mode",
    description: "Toggle between light and dark themes.",
    value: (setting) => setting.darkMode,
    onChanged: (notifier, value) {
      settingsLogger.info("Notifying change of darkmode value: $value");
      notifier.setDarkMode(value);
    },
  ),
  BoolSettingUI(
    kBtn: KBtn.settingsReceiveNotifications,
    icon: Icons.notifications,
    title: "Notifications",
    description: "Receive notifications about the app. $alertsNotAffected",
    value: (setting) => setting.receiveNotifications,
    onChanged: (notifier, value) => notifier.setReceiveNotifications(value),
  ),
  BoolSettingUI(
    kBtn: KBtn.settingsAutoUpdate,
    icon: Icons.system_update,
    title: "Auto Update",
    description:
        "Automatically updates the app for you. This improves the security and user experience of the app.",
    value: (setting) => setting.autoUpdate,
    onChanged: (notifier, value) => notifier.setAutoUpdate(value),
  ),
];

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          itemCount: appSettings.length,
          itemBuilder: (context, idx) =>
              SettingBlock(setting: appSettings[idx]),
        ),
      ),
    );
  }
}
