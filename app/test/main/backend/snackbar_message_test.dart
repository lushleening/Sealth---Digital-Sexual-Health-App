import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';

import '../../helper/test_helper.dart';

void main() {
  testWidgets("showSnackbarMessage works", (tester) async {
    const text = "Hello World";
    await initWidget(tester: tester);
    showSnackbarMessage(text);
    await tester.pumpAndSettle();
    expectObj(text);
  });
}