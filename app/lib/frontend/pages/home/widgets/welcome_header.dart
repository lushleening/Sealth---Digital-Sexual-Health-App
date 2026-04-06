import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/red_dot.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/home/welcome_header/welcome_header_data.dart';
import 'package:sddp_dsh/frontend/common_widgets/user_avatar.dart';

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
    final hasUnreadNotifications = uc.notifications.any((n) => !n.hasRead);

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
            name: "Guest@${user.localId.substring(0, 13)}",
            color: context.colors.textSecondary,
          );

    return Container(
      padding: EdgeInsetsGeometry.all(baseLength),
      width: double.infinity,
      height: 180,
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
                  onPressed: () => context.go(AppRoute.notifications),
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
                onTap: () => context.go(AppRoute.profile),
                child: UserAvatar(
                  key: KBtn.navProfile.key,
                  iconRadius: iconSizeSmall,
                ),
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(height: baseLength),
          Padding(
            padding: EdgeInsets.only(
              left: textAdditionalPadding,
              bottom: textAdditionalPadding,
            ),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: context.colors.textPrimary,
                ),
                children: [
                  TextSpan(text: "Hello "),
                  TextSpan(
                    text: displayNameColor.name,
                    style: TextStyle(color: displayNameColor.color),
                  ),
                  TextSpan(text: ", welcome to "),
                  TextSpan(
                    text: data.appName,
                    style: TextStyle(
                      color: context.colors.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              softWrap: true,
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
