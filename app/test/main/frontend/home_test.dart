import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/user/app_notification/app_notification.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/red_dot.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/new_articles.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/recently_read.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/upcoming_appointments.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/welcome_header.dart';

import 'package:sddp_dsh/backend/articles/providers/articles_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/recently_viewed_provider.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

// Overrides that make ContinueReading and NewArticles render in tests.
final _articleOverrides = [
  articlesProvider.overrideWith((ref) => TestArticlesNotifier(ref: ref)),
  recentlyViewedProvider.overrideWith(
    (ref) => TestRecentlyViewedNotifier(),
  ),
];

void main() {
  late MockAppointmentSyncService mockSyncService;

  setUp(() {
    mockSyncService = MockAppointmentSyncService();

    // Returns a future appointment to ensure it renders properly
    when(() => mockSyncService.getCachedAppointments(any())).thenAnswer(
      (_) async => [
        Appointment(
          id: testAppointmentId,
          name: 'Test Clinic',
          description: 'STI Screening',
          datetime: DateTime.now().add(const Duration(days: 1)),
          clinicId: testClinicId,
          serviceId: testServiceId,
        ),
      ],
    );
    when(() => mockSyncService.syncAppointments()).thenAnswer((_) async {});
    when(() => mockSyncService.getCachedClinics()).thenAnswer((_) async => []);
    when(() => mockSyncService.syncClinics()).thenAnswer((_) async {});
    when(
      () => mockSyncService.getCachedServices(any()),
    ).thenAnswer((_) async => []);
    when(() => mockSyncService.syncServices()).thenAnswer((_) async {});
  });

  group("Home Page", () {
    testWidgets("UI Renders Correctly", (tester) async {
      await initWidget(
        tester: tester,
        path: AppRoute.home,
        mockAppointmentSyncService: mockSyncService,
        otherOverrides: _articleOverrides,
      );
      expectObj(AsyncPage);
      expectObj(WelcomeHeader);
      expectObj(UpcomingAppointments);
      expectObj(RecentlyViewed);
      expectObj(NewArticles);
    });

    group("See More Navigations", () {
      testWidgets("Pending Appointment", (tester) async {
        await testPageBackButtons(
          tester: tester,
          start: AppRoute.home,
          toSubPageBtn: KBtn.navPendingAppointment,
          targetPath: AppRoute.appointments,
          mockAppointmentSyncService: mockSyncService,
        );
      });
      testWidgets("New Articles", (tester) async {
        await testPageBackButtons(
          tester: tester,
          start: AppRoute.home,
          toSubPageBtn: KBtn.navNewArticles,
          targetPath: AppRoute.articles,
          otherOverrides: _articleOverrides,
        );
      });
    });
  });

  group("Notification bell's red dot", () {
    testWidgets(
      "Red dot displays when there's new notifications that has not been read",
      (tester) async {
        await initWidget(
          tester: tester,
          otherOverrides: [
            appNotificationProvider.overrideWith(
              TestAppNotificationOneHasNotReadNotifier.new,
            ),
          ],
        );
        expectObj(RedDot);
      },
    );

    testWidgets(
      "Red dot does not display when there's no new notifications that has not been read",
      (tester) async {
        await initWidget(
          tester: tester,
          otherOverrides: [
            appNotificationProvider.overrideWith(
              TestAppNotificationNoneNotifier.new,
            ),
          ],
        );
        expectObj(RedDot, m: findsNothing);
      },
    );
    testWidgets(
      "Red dot does not display when there's no notifications",
      (tester) async {
        await initWidget(
          tester: tester,
          otherOverrides: [
            appNotificationProvider.overrideWith(
              TestAppNotificationOneHasReadNotifier.new,
            ),
          ],
        );
        expectObj(RedDot, m: findsNothing);
      },
    );
  });
}
