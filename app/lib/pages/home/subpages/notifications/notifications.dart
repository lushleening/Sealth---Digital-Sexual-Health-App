import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/common_widgets/safe_container.dart';
import 'package:sddp_dsh/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/pages/home/subpages/notifications/widgets/notification_block.dart';
import 'package:sddp_dsh/pages/home/subpages/notifications/providers/app_notification.dart';
import 'package:sddp_dsh/pages/home/subpages/notifications/widgets/test_noti_btn.dart';

// TODO Wait... There are 2 (3) types of notifications???? (Online to all, Online to user only, Offline)
class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.fine("Notification Page generated");
    final notifications = ref.watch(appNotificationProvider);
    return SafeContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TopAppBar(
          title: "Notifications",
          fg: context.colors.textPrimary,
          bg: context.colors.whiteBackground,
        ),
        // TODO This floatingActionButton is for testing, remove this after
        floatingActionButton: const TestNotiBtn(),
        body: notifications.isEmpty
            ? Center(child: Text("No notifications found."))
            : Column(
                children: [
                  SizedBox(height: baseLength),
                  Expanded(
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) => NotificationsBlock(
                        notification: notifications[index],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
