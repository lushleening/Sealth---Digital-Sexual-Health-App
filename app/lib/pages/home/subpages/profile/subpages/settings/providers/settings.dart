// CODEGEN RELATED: "dart run build_runner watch"
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sddp_dsh/testing/key_enum.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/settings/providers/app_settings.dart';
import 'package:sddp_dsh/user/app_user.dart';

part 'settings.freezed.dart';

bool _defaultDisplaySetting(AppUser _) => true;

// Settings of the app
@freezed
abstract class Settings with _$Settings {
  const factory Settings({
    required KBtn kBtn,
    required IconData icon,
    required String title,
    required String description,
    required bool Function(AppSettings) value,
    required void Function(AppSettingsNotifier, bool) onChanged,
    @Default(_defaultDisplaySetting) bool Function(AppUser) displaySetting,
  }) = _Settings;
}
