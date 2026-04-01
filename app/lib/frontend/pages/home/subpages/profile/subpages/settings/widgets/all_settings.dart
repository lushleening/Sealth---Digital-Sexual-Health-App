import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/constants/text_hints.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/settings/widgets/setting_block/bool_setting_block.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/settings/widgets/setting_block/setting_block.dart';

final List<SettingBlock> allSettings = [
  BoolSettingBlock(
    kBtn: KBtn.settingsDarkMode,
    icon: Icons.dark_mode_outlined,
    title: "Dark Mode",
    description: "Toggle between light and dark themes.",
    value: (s) => s.darkMode,
    onChanged: (notifier, value) => notifier.setDarkMode(value),
  ),
  BoolSettingBlock(
    kBtn: KBtn.settingsReceiveNotifications,
    icon: Icons.notifications,
    title: "Enable Notifications",
    description: "Receive notifications about the app. $alertsNotAffected",
    value: (s) => s.receiveNotifications,
    onChanged: (notifier, value) => notifier.setReceiveNotifications(value),
  ),
  BoolSettingBlock(
    kBtn: KBtn.settingsBiometricConfirmation,
    icon: Icons.fingerprint,
    title: "Enable Biometric Confirmation",
    description: "Confirm your actions when performing sensitive operations (Biometrics for device must be enabled for it to take effect)",
    value: (s) => s.biometricConfirmation,
    onChanged: (notifier, value) => notifier.setBiometricConfirmation(value),
    displayWhen: (user) => user.remoteId != null,
  )
];
