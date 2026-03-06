import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/settings/widgets/settings_ui.dart';
import 'package:sddp_dsh/backend/settings/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

// A UI display for Settings object
class SettingBlock extends ConsumerWidget {
  final SettingUI setting;

  const SettingBlock({super.key, required this.setting});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fair confidence that user and settings exists, thus not using async
    final appUser = ref.watch(appUserProvider).unwrapPrevious().value;
    final appSettings = ref.watch(appSettingsProvider).unwrapPrevious().value;
    final notifier = ref.read(appSettingsProvider.notifier);

    // Determine if renders this block
    if (appSettings == null || appUser == null) {
      return const LoadingCircleMainColor();
    }
    if (!setting.displayWhen(appUser)) return SizedBox.shrink();
    uiLogger.fine("Settings block with setting ${setting.title} generated.");

    return GestureDetector(
      key: setting.kBtn.key,
      onTap: () => setting.onChanged(notifier, !setting.value(appSettings)),
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
              Icon(setting.icon, size: iconSizeMedium),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      setting.title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                    Text(
                      setting.description,
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
                  value: setting.value(appSettings),
                  onChanged: (v) => setting.onChanged(notifier, v),
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
