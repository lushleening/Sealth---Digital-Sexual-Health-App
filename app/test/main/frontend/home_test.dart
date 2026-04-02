import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/continue_reading.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/new_articles.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/upcoming_appointments.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/welcome_header.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

void main() {
  late MockAppointmentSyncService mockSyncService;

  setUp(() {
    mockSyncService = MockAppointmentSyncService();

    // Returns a future appointment to ensure it renders properly
    when(() => mockSyncService.getCachedAppointments(any()))
        .thenAnswer((_) async => [
          Appointment(
            id: testAppointmentId,
            name: 'Test Clinic',
            description: 'STI Screening',
            datetime: DateTime.now().add(const Duration(days: 1)),
            clinicId: testClinicId,
            serviceId: testServiceId,
          ),
        ]);
    when(() => mockSyncService.syncAppointments())
        .thenAnswer((_) async {});
    when(() => mockSyncService.getCachedClinics())
        .thenAnswer((_) async => []);
    when(() => mockSyncService.syncClinics())
        .thenAnswer((_) async {});
    when(() => mockSyncService.getCachedServices(any()))
        .thenAnswer((_) async => []);
    when(() => mockSyncService.syncServices())
        .thenAnswer((_) async {});
  });

  group("Home Page", () {
    testWidgets("UI Renders Correctly", (tester) async {
      await initWidget(tester: tester, path: AppRoute.home, mockAppointmentSyncService: mockSyncService,);
      expectObj(WelcomeHeader);
      expectObj(UpcomingAppointments);
      expectObj(ContinueReading);
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
      testWidgets("Continue Reading Article", (tester) async {
        await testPageBackButtons(
          tester: tester,
          start: AppRoute.home,
          toSubPageBtn: KBtn.navContinueReadingArticle,
          targetPath: AppRoute.articles,
        );
      });
      testWidgets("New Articles", (tester) async {
        await testPageBackButtons(
          tester: tester,
          start: AppRoute.home,
          toSubPageBtn: KBtn.navNewArticles,
          targetPath: AppRoute.articles,
        );
      });
    });

    // TODO integration is done in D7 after all have included their reponsibilities in home page
  });
}
