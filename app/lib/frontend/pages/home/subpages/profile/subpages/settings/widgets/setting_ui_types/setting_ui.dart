import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/settings/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

// Used to choose which customization method to display
enum SettingsUIType { boolean } // number, text} // Reserved for future use

abstract class SettingUIBase {
  SettingsUIType get type;
}

// Settings UI of the app
abstract class SettingUI<T> implements SettingUIBase {
  final bool Function(AppUser user) displayWhen;
  final KBtn kBtn;
  final IconData icon;
  final String title;
  final String description;

  final T Function(AppSettings) value;
  final void Function(AppSettingsNotifier, T) onChanged;

  const SettingUI({
    this.displayWhen = _defaultDisplayWhen,
    required this.kBtn,
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  static bool _defaultDisplayWhen(AppUser _) => true;
  Widget build(BuildContext context, WidgetRef ref);
}
