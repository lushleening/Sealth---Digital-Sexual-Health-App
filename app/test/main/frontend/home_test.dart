import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/continue_reading.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/new_articles.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/upcoming_appointments.dart';
import 'package:sddp_dsh/frontend/pages/home/widgets/welcome_header.dart';

import '../../helper/test_helper.dart';

void main() {
  setUp(() async {
    
  });

  group("Home Page", () {
    testWidgets("UI Renders Correctly", (tester) async {
      await initWidget(tester: tester, path: AppRoute.home);
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
