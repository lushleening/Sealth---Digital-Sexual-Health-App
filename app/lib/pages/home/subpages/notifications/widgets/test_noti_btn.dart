import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/common_widgets/safe_container.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';
import 'package:sddp_dsh/nav/main_page_route.dart';
import 'package:sddp_dsh/pages/home/subpages/notifications/providers/app_notification.dart';
import 'package:sddp_dsh/pages/home/subpages/notifications/providers/notification.dart';

// TODO This file is for testing, remove this after
final dummyNotifications = [
  NotificationObj(
    title: "New Article Release: Safe sex",
    description: "Check it out!",
    icon: Icons.article_outlined,
    linkToPageMainIndex: MainPageRoute.article,
    linkToPageSub: SafeContainer(child: Text("Safe sex")),
  ),
  NotificationObj(
    title: "Late Appointment",
    description:
        "You had an appointment due 2 hours ago. Did you forget about it?",
    icon: Icons.calendar_month_outlined,
    warning: true,
    linkToPageMainIndex: MainPageRoute.appointment,
    linkToPageSub: SafeContainer(child: Text("Late Appointment")),
  ),
  NotificationObj(
    title: "Conversation",
    description: "Jason replied to your message!",
    icon: Icons.chat_bubble_outline,
    linkToPageMainIndex: MainPageRoute.discussion,
    linkToPageSub: SafeContainer(child: Text("Convo")),
  ),
  NotificationObj(
    title:
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    description:
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    icon: Icons.chat_bubble_outline,
    linkToPageMainIndex: MainPageRoute.discussion,
    linkToPageSub: SafeContainer(child: Text("TEST FOR LONG WORDS")),
  ),
];

class TestNotiBtn extends ConsumerWidget {
  const TestNotiBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.fine("Test Noti button generated [Remove after use]");
    return IconButton(
      onPressed: () {
        final r = ref.read(appNotificationProvider.notifier);
        for (final n in dummyNotifications) {
          r.addNew(n);
        }
      },
      icon: Icon(Icons.add),
    );
  }
}
