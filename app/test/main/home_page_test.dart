import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/pages/home/home.dart';
import 'package:sddp_dsh/pages/home/widgets/continue_reading.dart';
import 'package:sddp_dsh/pages/home/widgets/new_articles.dart';
import 'package:sddp_dsh/pages/home/widgets/upcoming_appointments.dart';
import 'package:sddp_dsh/pages/home/widgets/welcome_header.dart';

import '../helper/test_helper.dart';

void main() {
  group("Home Page", () {
    testWidgets("UI Renders Correctly", (tester) async {
      await initWidget(tester: tester, home: const HomePage());
      expectObj(WelcomeHeader);
      expectObj(UpcomingAppointments);
      expectObj(ContinueReading);
      expectObj(NewArticles);
    });

    // group("Complex navigation push", () {
    //   // I haven't thought of a way to do this without backend logic
    //   // So leave this blank until backend structure is complete
    // });

    // TODO connectivity changes UI backend
  });
}
