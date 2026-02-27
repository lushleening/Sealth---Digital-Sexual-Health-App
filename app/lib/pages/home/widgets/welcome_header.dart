import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sddp_dsh/common_widgets/async_page.dart';
import 'package:sddp_dsh/common_widgets/red_dot.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/testing/key_enum.dart';
import 'package:sddp_dsh/helper/safe_nav.dart';
import 'package:sddp_dsh/pages/home/providers/welcome_header_notifier.dart';
import 'package:sddp_dsh/pages/home/subpages/notifications/notifications.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/profile.dart';
import 'package:sddp_dsh/user/app_user.dart';

class WelcomeHeader extends ConsumerWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(welcomeHeaderProvider);

    return AsyncPage(
      state: state,
      pageContent: (data) => WelcomeHeaderContent(data: data),
      logTextOnError: (e, st) =>
          // TODO Log text standardization
          "Could not get user information on welcome header: $e",
    );
  }
}

class WelcomeHeaderContent extends ConsumerWidget {
  final WelcomeHeaderData data;

  const WelcomeHeaderContent({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.fine("Welcome header generated.");
    final loggedInTimeString = DateFormat().add_yMd().add_jm().format(
      data.user.lastLoggedIn,
    );
    const textAdditionalPadding = 4.0;

    final displayNameColor = !data.user.isRegistered
        ? _DisplayNameColor(
            name: "Guest@${data.user.localId.substring(0, 6)}",
            color: context.colors.textSecondary,
          )
        : _DisplayNameColor(
            name: data.profile!.username,
            color: context.colors.mainColor,
          );

    return Container(
      padding: EdgeInsetsGeometry.all(baseLength),
      width: double.infinity,
      height: 160,
      color: context.colors.whiteBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Transform.translate(
                offset: Offset(-8, 0),
                child: IconButton(
                  key: KBtn.navNotificationBell.key,
                  onPressed: () => navPush(
                    context,
                    ref,
                    NotificationPage(key: KPage.notification.key),
                  ),
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.notifications,
                        size: iconSizeLarge,
                        color: data.hasNotifications
                            ? context.colors.mainColor
                            : context.colors.textBoxIcon,
                      ),

                      if (data.hasNotifications)
                        RedDot(top: 2, right: 2, radius: 10),
                    ],
                  ),
                ),
              ),

              const Spacer(),
              GestureDetector(
                onTap: () =>
                    navPush(context, ref, ProfilePage(key: KPage.profile.key)),

                // TODO: Real fix for this profile pic
                child: CircleAvatar(
                  key: KBtn.navProfileAvatar.key,
                  radius: iconSizeSmall,
                  backgroundColor: context.colors.mainColor,
                  child: Icon(
                    Icons.person,
                    color: context.colors.whiteBackground,
                    size: iconSizeMedium,
                  ),
                ),
                // CircleAvatar(
                //   key: KBtn.navProfileAvatar.key,
                //   radius: iconSizeSmall,
                //   backgroundColor: context.colors.mainColor,
                //   child: const Text(
                //     'A',
                //     style: TextStyle(color: Colors.white),
                //   ), // This will be replaced so Colors.white will be changed
                // ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsetsGeometry.only(left: textAdditionalPadding),
            child: Row(
              children: [
                Text(
                  "Hello ",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  displayNameColor.name,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: displayNameColor.color,
                  ),
                ),
                Text(
                  ", welcome to ",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  data.appName,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: context.colors.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsetsGeometry.only(left: textAdditionalPadding),
            child: Text(
              'Last logged in at: $loggedInTimeString',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisplayNameColor {
  final String name;
  final Color color;

  _DisplayNameColor({required this.name, required this.color});
}
