import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/common_widgets/red_dot.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/helper/safe_nav.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/pages/home/subpages/notifications/providers/notification.dart';
import 'package:sddp_dsh/pages/home/subpages/notifications/providers/app_notification.dart';

// TODO: Logic seems strange, and duplicate issues are more complex than I think

// Notifications of the app, a UI display for NotificationObj
class NotificationsBlock extends ConsumerWidget {
  final NotificationObj notification;

  const NotificationsBlock({super.key, required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warnColor = notification.warning ? context.colors.warning : null;
    final borderColor = notification.warning
        ? context.colors.warning.withValues(alpha: .5)
        : null;
    final notifications = ref.read(appNotificationProvider.notifier);
    uiLogger.fine("Notification block with '${notification.title}' generated");
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            final pageSub = notification.linkToPageSub;
            if (pageSub == null) return;
            navPush(context, ref, pageSub);
            notifications.markAsRead(notification);

            // TODO: Ask them about this
            // navPop(context, ref);
            // dualNavPush(
            //   context,
            //   ref,
            //   toMainPage: notification.linkToPageMainIndex,
            //   toSubPage: notification.linkToPageSub,
            // );
          },
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              vertical: baseLength / 2,
              horizontal: baseLength,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsetsGeometry.all(baseLength),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.colors.whiteBackground,
                    border: BoxBorder.all(
                      color: borderColor ?? context.colors.boxShadowGray,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (borderColor ?? context.colors.boxShadowGray)
                            .withValues(alpha: .25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        notification.icon,
                        size: iconSizeMedium,
                        color: warnColor,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title,
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: warnColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              notification.description,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall!.copyWith(color: warnColor),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => notifications.remove(notification),
                        icon: Padding(
                          padding: EdgeInsetsGeometry.all(4),
                          child: Icon(Icons.close, color: warnColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!notification.read) const RedDot(left: 12, top: 3, radius: 15),
      ],
    );
  }
}
