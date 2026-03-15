import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/notifications/widgets/notification_block.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';

// Reminders for user
class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.finer("Notification Page generated");
    final notifications = ref.watch(appNotificationProvider);
    return SafeContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TopAppBar(
          title: "Notifications",
          fg: context.colors.textPrimary,
          bg: context.colors.whiteBackground,
        ),
        body: notifications.isEmpty
            ? Center(child: Text("No notifications found."))
            : Column(
                children: [
                  const SizedBox(height: baseLength),
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
