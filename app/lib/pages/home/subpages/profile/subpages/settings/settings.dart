import 'package:flutter/material.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/common_widgets/safe_container.dart';
import 'package:sddp_dsh/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/testing/key_enum.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/settings/providers/settings.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/settings/widgets/settings_block.dart';
import 'package:sddp_dsh/user/app_user.dart';

final appSettings = [
  Settings(
    kBtn: KBtn.settingsDarkMode,
    icon: Icons.dark_mode_outlined,
    title: "Dark Mode",
    description: "Toggle between light and dark themes.",
    value: (setting) => setting.darkMode,
    onChanged: (notifier, value) => notifier.setDarkmode(value),
  ),
  Settings(
    kBtn: KBtn.settingsNotification,
    icon: Icons.notifications,
    title: "Notifications",
    description:
        "Receive notifications about the app. Note that late appointment notifications and in-app notifications are NOT affected.",
    value: (setting) => setting.receiveNotifications,
    onChanged: (notifier, value) => notifier.setReceiveNotifications(value),
  ),
  Settings(
    kBtn: KBtn.settingsAutoSync,
    icon: Icons.cloud_upload,
    title: "Auto Sync",
    description:
        "Automatically syncs your preferences (settings, appointments, bookmarks, etc.) to the cloud to prevent data loss.",
    value: (setting) => setting.autoSync,
    displaySetting: (user) => user.isRegistered,
    onChanged: (notifier, value) => notifier.setAutoSync(value),
  ),
  Settings(
    kBtn: KBtn.settingsAutoUpdate,
    icon: Icons.system_update,
    title: "Auto Update",
    description:
        "Automatically updates the app for you. This improves the security and user experience of the app.",
    value: (setting) => setting.autoUpdate,
    onChanged: (notifier, value) => notifier.setAutoUpdate(value),
  ),
  // TODO quiet hours no notification
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
              SettingsBlock(setting: appSettings[idx]),
        ),
      ),
    );
  }
}
