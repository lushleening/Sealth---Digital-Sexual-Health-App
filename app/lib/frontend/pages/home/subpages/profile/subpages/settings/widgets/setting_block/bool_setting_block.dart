import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/settings/widgets/setting_block/setting_block.dart';

class BoolSettingBlock extends SettingBlock<bool> {
  @override
  SettingsBlockType get type => SettingsBlockType.boolean;
  const BoolSettingBlock({
    required super.kBtn,
    super.displayWhen,
    required super.icon,
    required super.title,
    required super.description,
    required super.value,
    required super.onChanged,
  });

  @override
  Widget buildContent(BuildContext context, WidgetRef ref, bool settingValue) {
    final notifier = ref.read(appSettingsProvider.notifier);
    uiLogger.finer("Bool Settings block with setting $title generated.");

    return GestureDetector(
      key: kBtn.key,
      onTap: () => onChanged(notifier, !settingValue),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: baseLength / 2),
        child: Container(
          padding: EdgeInsetsGeometry.all(baseLength),
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.colors.whiteBackground,
            border: BoxBorder.all(color: context.colors.buttonBorder),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: context.colors.boxShadowGray,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: iconSizeMedium),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(4),
                child: Switch(
                  trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
                  value: settingValue,
                  onChanged: (v) => onChanged(notifier, v),
                  activeThumbColor: context.colors.switchThumb,
                  inactiveThumbColor: context.colors.switchThumb,
                  activeTrackColor: context.colors.switchActiveTrack,
                  inactiveTrackColor: context.colors.switchInactiveTrack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class NumberSettingUI extends SettingUI<int> { ... }
// class TextSettingUI extends SettingUI<String> { ... }
// class DateTimeSettingUI extends SettingUI<String> { ... }
// class EnumSettingUI<T extends Enum> extends SettingUI<T> { ... }
