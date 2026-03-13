import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';

// Settings UI of the app
abstract class SettingBlock<T> implements SettingBlockBase {
  final bool Function(AppUser user) displayWhen;
  final KBtn kBtn;
  final IconData icon;
  final String title;
  final String description;
  final T Function(AppSettings) value;
  final void Function(AppSettingsNotifier, T) onChanged;

  const SettingBlock({
    this.displayWhen = _defaultDisplayWhen,
    required this.kBtn,
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  Widget buildContent(BuildContext context, WidgetRef ref, T settingValue);

  Widget build(BuildContext context, WidgetRef ref, AppUser user) {
    final state = ref.watch(
      appSettingsProvider.select((s) => s.whenData((cb) => value(cb))),
    );

    return AsyncPage(
      state: state,
      pageContent: (settingValue) {
        if (!displayWhen(user)) return SizedBox.shrink();
        return buildContent(context, ref, settingValue);
      },
      logTextOnError: (e, st) => "Error in $title: $e",
    );
  }

  static bool _defaultDisplayWhen(AppUser _) => true;
}

// Used to choose which customization method to display
enum SettingsBlockType { boolean } // number, text} // Reserved for future use

abstract class SettingBlockBase {
  SettingsBlockType get type;
}
