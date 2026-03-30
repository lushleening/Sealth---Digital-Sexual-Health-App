import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/settings/settings.dart';

import '../../helper/test_helper.dart';

void main() {
  group("Settings Page", () {
    testWidgets("Navigate to/from profile page", (tester) async {
      await testPageBackButtons(
        tester: tester,
        start: AppRoute.profile,
        toSubPageBtn: KBtn.navSettings,
        targetPath: AppRoute.settings,
        backButton: KBtn.navBackButton,
      );
    });

    group("UI Renders Correctly", () {
      testWidgets("For Guest", (tester) async {
        await initWidget(
          tester: tester,
          path: AppRoute.settings,
          asRegisteredUser: false,
        );
        expectObj(SettingsPage);
        expectObj(KBtn.settingsDarkMode);
        expectObj(KBtn.settingsReceiveNotifications);
        expectObj(KBtn.settingsBiometricConfirmation, m: findsNothing);
      });
      testWidgets("For Registered Users", (tester) async {
        await initWidget(
          tester: tester,
          path: AppRoute.settings,
          asRegisteredUser: true,
        );
        expectObj(SettingsPage);
        expectObj(KBtn.settingsDarkMode);
        expectObj(KBtn.settingsReceiveNotifications);
        expectObj(KBtn.settingsBiometricConfirmation);
      });
    });

    group("Settings work as expected", () {
      testWidgets("Dark Mode", (tester) async {
        final container = await initWidget(
          tester: tester,
          path: AppRoute.settings,
        );

        final materialApp = tester.widget<MaterialApp>(
          find.byType(MaterialApp),
        );
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

      testWidgets("Receive Notification", (tester) async {
        await testSettingsSwitch(
          tester: tester,
          switchBtn: KBtn.settingsReceiveNotifications,
          settingValue: (s) => s.receiveNotifications,
          asRegisteredUser: true,
        );

        // TODO Since notifications are not implemented, we can only test the value in providers
      });

      // Biometric Confirmation are on OS level and is provided by an external package thus not testing it
    });
  });
}

Future<void> testSettingsSwitch({
  required WidgetTester tester,
  required KBtn switchBtn,
  required bool Function(AppSettings) settingValue,
  bool asRegisteredUser = false,
  VoidCallback? alsoCheckBefore,
  VoidCallback? alsoCheckAfter,
}) async {
  final container = await initWidget(
    tester: tester,
    path: AppRoute.settings,
    asRegisteredUser: asRegisteredUser,
  );
  final before = await container.read(appSettingsProvider.future);
  alsoCheckBefore?.call();

  await tap(tester, find.byKey(switchBtn.key));
  final after = await container.read(appSettingsProvider.future);
  alsoCheckAfter?.call();

  expect(settingValue(before), isNot(settingValue(after)));
}
