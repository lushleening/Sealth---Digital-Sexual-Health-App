import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../helper/test_helper.dart';

void main() {
  group("About Popup", () {
    testWidgets("Test popup shows/hides on button press in profile page", (
      tester,
    ) async {
      await testSubPageBackButtons(
        tester: tester,
        start: AppRoute.profile,
        toSubPageBtn: KBtn.navAboutBtn,
        target: KPage.about,
        backButton: KBtn.closePopup,
      );
    });

    testWidgets("UI Renders Correctly", (tester) async {
      final container = await initWidget(
        tester: tester,
        path: AppRoute.about,
      );
      final metadata = await container.read(appMetadataProvider.future);

      expect(find.text(metadata.appName), findsOneWidget);
      expect(find.text(metadata.versionText), findsOneWidget);
      expect(
        find.text("${metadata.legalLese1}\n${metadata.legalLese2}"),
        findsOneWidget,
      );
      expectObj(KBtn.closePopup);

      for (final a in metadata.authors) {
        expect(find.text(a), findsOneWidget);
      }
    });
  });
}
