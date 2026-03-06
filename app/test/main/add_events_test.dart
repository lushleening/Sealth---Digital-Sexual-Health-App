import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/add_events/add_events.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../helper/test_helper.dart';

void main() {
  testWidgets('AddEventPage renders correctly', (WidgetTester tester) async {
    await initWidget(tester: tester, home: const AddEventPage());

    // Verify page loads
    expectObj(KPage.addEvents);

    // Verify AppBar title
    expect(find.text('Add New Event'), findsOneWidget);

    // Verify buttons exist
    expectObj(KBtn.eventaddbutton);
    expectObj(KBtn.cancelbutton);
  });

  testWidgets('Add button is tappable', (WidgetTester tester) async {
    await initWidget(tester: tester, home: const AddEventPage());

    // Scroll into view before tapping
    await tap(tester, find.byKey(KBtn.eventaddbutton.key));

    // Confirm button still exists (no crash)
    expectObj(KBtn.eventaddbutton);
  });

  testWidgets('Cancel button is tappable', (WidgetTester tester) async {
    await initWidget(tester: tester, home: const AddEventPage());

    // Scroll into view before tapping
    await tap(tester, find.byKey(KBtn.cancelbutton.key));

    // Confirm button still exists (no crash)
    expectObj(KBtn.cancelbutton);
  });
}
