import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/red_dot.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/navigation/safer_navigation/safer_navigation.dart';
import 'package:sddp_dsh/backend/home/welcome_header/welcome_header_data.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/notifications/notifications.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/profile.dart';

// Large top bar on the home page
class WelcomeHeader extends ConsumerWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(welcomeHeaderProvider);
    return AsyncPage(
      state: state,
      pageContent: (data) => _WelcomeHeaderContent(data: data),
      logTextOnError: (e, _) =>
          // TODO Log text standardization
          "Could not get user information on welcome header: $e",
    );
  }
}

class _WelcomeHeaderContent extends ConsumerWidget {
  final WelcomeHeaderData data;

  const _WelcomeHeaderContent({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uc = data.userContext;
    final user = uc.user;
    final profile = uc.profile;
    final hasUnreadNotifications = uc.notifications.any((n) => !n.read);

    uiLogger.finer("Welcome header generated.");
    final loggedInTimeString = DateFormat().add_yMd().add_jm().format(
      user.lastLoggedIn,
    );
    const textAdditionalPadding = 4.0;

    final displayNameColor = uc.isRegisteredUser
        ? _DisplayNameColor(
            name: profile!.username,
            color: context.colors.mainColor,
          )
        : _DisplayNameColor(
            name: "Guest@${user.localId.substring(0, 6)}",
            color: context.colors.textSecondary,
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
                        color: hasUnreadNotifications
                            ? context.colors.mainColor
                            : context.colors.textBoxIcon,
                      ),

                      if (hasUnreadNotifications)
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
