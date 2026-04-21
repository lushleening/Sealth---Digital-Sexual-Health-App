import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';
import 'package:sddp_dsh/frontend/common_widgets/red_dot.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/notifications/widgets/notification_block.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

void main() {
  group("Notifications Page", () {
    testWidgets("Navigate to/from home page", (tester) async {
      await testPageBackButtons(
        tester: tester,
        start: AppRoute.home,
        toSubPageBtn: KBtn.navNotificationBell,
        targetPath: AppRoute.notifications,
        backButton: KBtn.navBackButton,
      );
    });
  });

  group("Notification block", () {
    testWidgets("Displays red dot on has not read notifications", (
      tester,
    ) async {
      await initWidget(
        tester: tester,
        otherOverrides: [
          appNotificationProvider.overrideWith(
            TestAppNotificationOneHasNotReadNotifier.new,
          ),
        ],
        path: AppRoute.notifications,
      );

      expectObj(NotificationsBlock);
      expectObj(RedDot);
    });

    testWidgets("Does not display red dot on has read notifications", (
      tester,
    ) async {
      await initWidget(
        tester: tester,
        otherOverrides: [
          appNotificationProvider.overrideWith(
            TestAppNotificationOneHasReadNotifier.new,
          ),
        ],
        path: AppRoute.notifications,
      );

      expectObj(NotificationsBlock);
      expectObj(RedDot, m: findsNothing);
    });

    testWidgets("Displays no notification blocks correctly", (tester) async {
      await initWidget(
        tester: tester,
        otherOverrides: [
          appNotificationProvider.overrideWith(
            TestAppNotificationNoneNotifier.new,
          ),
        ],
        path: AppRoute.notifications,
      );
      expectObj(NotificationsBlock, m: findsNothing);
    });

    testWidgets("Displays two notification blocks correctly", (tester) async {
      await initWidget(
        tester: tester,
        otherOverrides: [
          appNotificationProvider.overrideWith(
            TestAppNotificationsMoreNotifier.new,
          ),
        ],
        path: AppRoute.notifications,
      );

      expectObj(NotificationsBlock, m: findsExactly(2));
      expectObj(RedDot, m: findsOneWidget);
    });

    testWidgets("Notification block takes user to respective pages on tap", (
      tester,
    ) async {
      final container = await initWidget(
        tester: tester,
        otherOverrides: [
          appNotificationProvider.overrideWith(
            TestAppNotificationOneHasNotReadNotifier.new,
          ),
        ],
        path: AppRoute.notifications,
      );
      await tap(tester, find.byType(NotificationsBlock));
      expectPath(container, testAppNotificationsOneHasNotRead.linkToPage);
    });

    testWidgets(
      "Remove button in notification block calls the remove notification function",
      (tester) async {
        registerFallbackValue(testAppNotificationsOneHasNotRead);

        final mockNoti = MockAppNotificationsNotifier();
        when(
          () => mockNoti.build(),
        ).thenAnswer((_) => Stream.value([testAppNotificationsOneHasNotRead]));
        when(() => mockNoti.removeNotification(any())).thenAnswer((_) async {});

        final container = await initWidget(
          tester: tester,
          otherOverrides: [
            appNotificationProvider.overrideWith(() => mockNoti),
          ],
          path: AppRoute.notifications,
        );
        container.listen(appNotificationProvider, (_, _) {});

        expectObj(NotificationsBlock);
        await tap(tester, find.byKey(KBtn.removeNotification.key));
        verify(() => mockNoti.removeNotification(any())).called(1);
      },
    );
  });
}
