import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/notifications/notification_type.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/notifications/widgets/notification_block.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userContextProvider);
    return AsyncPage(
      state: state,
      pageContent: (uc) => NotificationsPageContent(uc: uc),
      logTextOnError: (e, _) => "Unable to generate notifications page: $e",
    );
  }
}

// Reminders for user
class NotificationsPageContent extends ConsumerWidget {
  final UserContext uc;
  const NotificationsPageContent({super.key, required this.uc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.finer("Notification Page generated");
    final notifications = uc.notifications;
    final notifier = ref.read(appNotificationProvider.notifier);

    return SafeContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TopAppBar(
          title: "Notifications",
          fg: context.colors.textPrimary,
          bg: context.colors.whiteBackground,
        ),
        floatingActionButton: IconButton(
          onPressed: () {
            // TODO remove dummy
            final n = AppNotifications.timed(
              title: "title",
              description: "description",
              notificationType: NotificationType.discussion.name,
              isAlertMessage: false,
              hasRead: false,
              linkToPage: AppRoute.articles,
              delayDuration: Duration(seconds: 5), // 5 seconds before push to system notification
            );

            uc.isRegisteredUser
                ? notifier.insertNotificationToRemote(n)
                : notifier.upsertNotificationToLocal(n);
          },
          icon: Icon(Icons.add),
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
