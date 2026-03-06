import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/settings/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

// Used to choose which customization method to display
enum SettingsUIType {
  boolean,
} // number, text} // Reserved for future use

// Settings UI of the app
class SettingUI<T> {
  final bool Function(AppUser user) displayWhen;
  final SettingsUIType type;
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
    required this.type,
    required this.value,
    required this.onChanged,
  });

  // Always display unless condition is false
  static bool _defaultDisplayWhen(AppUser _) => true;
}

class BoolSettingUI extends SettingUI<bool> {
  const BoolSettingUI({
    required super.kBtn,
    required super.icon,
    required super.title,
    required super.description,
    required super.value,
    required super.onChanged,
  }) : super(type: SettingsUIType.boolean);
}