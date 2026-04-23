import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/appointments/appointment_sync.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/home/home_data.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/common_widgets/red_dot.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/new_articles.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/upcoming_appointments.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/welcome_header.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

// Overrides homeDataProvider so the home page renders without hitting Supabase.
final _homeOverrides = [
  homeDataProvider.overrideWith(TestHomeDataNotifier.new),
];

void main() {
  late MockAppointmentSyncService mockSyncService;

  setUp(() {
    mockSyncService = MockAppointmentSyncService();

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
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await initWidget(
        tester: tester,
        path: AppRoute.home,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
          ..._homeOverrides,
        ],
      );
      expectObj(WelcomeHeader);
      expectObj(UpcomingAppointments);
      expectObj(NewArticles);
    });

    group("See More Navigations", () {
      testWidgets("Pending Appointment", (tester) async {
        await testPageBackButtons(
          tester: tester,
          start: AppRoute.home,
          toSubPageBtn: KBtn.navPendingAppointment,
          targetPath: AppRoute.appointments,
          otherOverrides: [
            appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
            ..._homeOverrides,
          ],
        );
      });
      testWidgets("New Articles", (tester) async {
        await testPageBackButtons(
          tester: tester,
          start: AppRoute.home,
          toSubPageBtn: KBtn.navNewArticles,
          targetPath: AppRoute.articles,
          otherOverrides: _homeOverrides,
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
            homeDataProvider.overrideWith(TestHomeDataWithUnreadNotifier.new),
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
          otherOverrides: _homeOverrides,
        );
        expectObj(RedDot, m: findsNothing);
      },
    );
    testWidgets(
      "Red dot does not display when there's no notifications",
      (tester) async {
        await initWidget(
          tester: tester,
          otherOverrides: _homeOverrides,
        );
        expectObj(RedDot, m: findsNothing);
      },
    );
  });
}