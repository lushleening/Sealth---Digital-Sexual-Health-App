import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/profile.dart';
import 'package:sddp_dsh/backend/settings/app_settings/app_settings.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/settings/settings.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../helper/test_helper.dart';

void main() {
  group("Settings Page", () {
    testWidgets("Navigate to/from profile page", (tester) async {
      await testSubPageBackButtons(
        tester: tester,
        start: const ProfilePage(),
        toSubPageBtn: KBtn.navSettingsBtn,
        target: KPage.settings,
        backButton: KBtn.backButton,
      );
    });

    group("UI Renders Correctly", () {
      testWidgets("For Guest", (tester) async {
        await initWidget(
          tester: tester,
          home: const SettingsPage(),
          asRegisteredUser: false,
        );
        expectObj("Settings"); // Top app bar title
        expectObj(KBtn.settingsDarkMode);
        expectObj(KBtn.settingsReceiveNotifications);
        expectObj(KBtn.settingsAutoUpdate);
      });
      testWidgets("For Registered Users", (tester) async {
        await initWidget(
          tester: tester,
          home: const SettingsPage(),
          asRegisteredUser: true,
        );
        expectObj("Settings"); // Top app bar title
        expectObj(KBtn.settingsDarkMode);
        expectObj(KBtn.settingsReceiveNotifications);
        expectObj(KBtn.settingsAutoUpdate);
      });
    });

    // TODO test for db after settings sync completed
    testWidgets("Dark Mode Settings", (tester) async {
      final container = await initWidget(
        tester: tester,
        home: const SettingsPage(),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final before = await container.read(appSettingsProvider.future);
      await tap(tester, find.byKey(KBtn.settingsDarkMode.key));
      expect(
        materialApp.themeMode,
        before.darkMode ? ThemeMode.dark : ThemeMode.light,
      );

      final after = await container.read(appSettingsProvider.future);
      expect(before.darkMode, isNot(after.darkMode));
      expect(
        materialApp.themeMode,
        after.darkMode ? ThemeMode.light : ThemeMode.dark,
      );
    });
  });
}
