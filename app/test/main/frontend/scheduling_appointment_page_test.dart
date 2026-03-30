import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../../helper/test_helper.dart';

void main() {
  testWidgets('NearbyServicesPage renders correctly', (
    WidgetTester tester,
  ) async {
    await initWidget(tester: tester, path: AppRoute.nearbyServices);

    // Verify page loads
    expect(find.text('Nearby Services'), findsOneWidget);

    // Verify services card list exists
    expectObj(KBtn.scheduleAppointment);
  });

  testWidgets('Services card list is tappable', (WidgetTester tester) async {
    await initWidget(tester: tester, path: AppRoute.nearbyServices);

    // Scroll into view before tapping
    await tap(tester, find.byKey(KBtn.scheduleAppointment.key));

    // Confirm widget still exists (no crash)
    expectObj(KBtn.scheduleAppointment);
  });
}
