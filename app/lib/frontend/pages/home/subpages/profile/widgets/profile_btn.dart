import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/navigation/safer_navigation/safer_navigation.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

class ProfileBtnData {
  final KBtn? kBtn;
  final IconData icon;
  final String title;
  final String description;
  final Widget? linkToPage;
  final bool? displayCondition;
  final VoidCallback? popup;

  const ProfileBtnData({
    this.kBtn,
    required this.icon,
    required this.title,
    required this.description,
    this.linkToPage,
    this.popup,
    this.displayCondition,
  });
}

class ProfileBtn extends ConsumerWidget {
  final ProfileBtnData data;

  const ProfileBtn({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.finer("Profile button with title '${data.title}' generated.");
    final link = data.linkToPage;
    final popup = data.popup;
    final cd = data.displayCondition;
    if (cd == false) return SizedBox.shrink();

    return Column(
      key: data.kBtn?.key,
      children: [
        const SizedBox(height: baseLength / 2),

        GestureDetector(
          onTap: () {
            if (link != null) {
              navPush(context, ref, link);
            }
            popup?.call();
          },
          child: Container(
            padding: EdgeInsetsGeometry.all(baseLength),
            decoration: BoxDecoration(
              color: context.colors.whiteBackground,
              border: BoxBorder.all(color: context.colors.buttonBorder),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (context.colors.boxShadowGray).withValues(alpha: .5),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),

            child: Row(
              children: [
                Container(
                  margin: EdgeInsetsGeometry.all(baseLength / 4),
                  padding: EdgeInsetsGeometry.all(baseLength / 2),
                  decoration: BoxDecoration(
                    color: context.colors.mainColoredBox,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    data.icon,
                    size: iconSizeMedium,
                    color: context.colors.mainColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: baseLength),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(color: context.colors.textPrimary),
                      ),
                      Text(
                        data.description,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(color: context.colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
