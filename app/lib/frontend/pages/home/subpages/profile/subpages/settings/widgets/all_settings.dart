import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/constants/textbox_hints.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/settings/widgets/setting_ui_types/bool_setting_block.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/settings/widgets/setting_ui_types/setting_ui.dart';

final List<SettingUI> allSettings = [
  BoolSettingBlock(
    kBtn: KBtn.settingsDarkMode,
    icon: Icons.dark_mode_outlined,
    title: "Dark Mode",
    description: "Toggle between light and dark themes.",
    value: (setting) => setting.darkMode,
    onChanged: (notifier, value) => notifier.setDarkMode(value),
  ),
  BoolSettingBlock(
    kBtn: KBtn.settingsReceiveNotifications,
    icon: Icons.notifications,
    title: "Notifications",
    description: "Receive notifications about the app. $alertsNotAffected",
    value: (setting) => setting.receiveNotifications,
    onChanged: (notifier, value) => notifier.setReceiveNotifications(value),
  ),
  BoolSettingBlock(
    kBtn: KBtn.settingsAutoUpdate,
    icon: Icons.system_update,
    title: "Auto Update",
    description:
        "Automatically updates the app for you. This improves the security and user experience of the app.",
    value: (setting) => setting.autoUpdate,
    onChanged: (notifier, value) => notifier.setAutoUpdate(value),
  ),
];