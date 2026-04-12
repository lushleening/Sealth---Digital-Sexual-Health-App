import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/biometric/biometric_confirmation.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/settings_repository.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/settings/settings.dart';

import '../../helper/mock_objects.dart';
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
      late MockSettingsRepository mockRepo;
      late List<Override> otherOverrides;
      late StreamController<AppSettings> controller;
      setUp(() {
        // As editing settings requires special containers, override the default one
        mockRepo = MockSettingsRepository();
        otherOverrides = [
          settingsRepositoryProvider.overrideWithValue(mockRepo),
        ];

        controller = StreamController<AppSettings>.broadcast();
        var currentState = testAppSettings;
        controller.add(currentState);
        when(
          () => mockRepo.getSetting(any()),
        ).thenAnswer((_) async => currentState);
        when(() => mockRepo.watchSetting(any())).thenAnswer((_) async* {
          yield currentState;
          yield* controller.stream;
        });

        registerFallbackValue(testAppSettings);

        when(
          () => mockRepo.updateSettingAndSync(
            localId: any(named: 'localId'),
            remoteId: any(named: 'remoteId'),
            newSettings: any(named: 'newSettings'),
          ),
        ).thenAnswer((invocation) async {
          currentState = invocation.namedArguments[#newSettings];
          controller.add(currentState);
        });
      });

      tearDown(() {
        controller.close();
      });

      testWidgets("Dark Mode", (tester) async {
        // We mimic settings write behavior thus don't override settings, override repo instead
        final container = await initWidget(
          tester: tester,
          path: AppRoute.settings,
          overrideSettings: false,
          otherOverrides: otherOverrides,
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
          overrides: otherOverrides,
        );

        // Effect testing is located on other tests
      });

      testWidgets("Biometric Confirmation", (tester) async {
        await testSettingsSwitch(
          tester: tester,
          switchBtn: KBtn.settingsBiometricConfirmation,
          settingValue: (s) => s.biometricConfirmation,
          asRegisteredUser: true,
          overrides: otherOverrides,
        );
        
        // Effect testing is located on other tests
      });
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
  required List<Override> overrides,
}) async {
  final mockBio = MockBiometricConfirmation();
  when(
    () => mockBio.tryBiometricConfirmation(
      bypassSettingCheck: any(named: 'bypassSettingCheck'),
    ),
  ).thenAnswer((_) async => true);

  // We mimic settings write behavior thus don't override settings here, override repo instead
  final container = await initWidget(
    tester: tester,
    path: AppRoute.settings,
    asRegisteredUser: asRegisteredUser,
    overrideSettings: false,
    otherOverrides: [
      biometricConfirmationProvider.overrideWithValue(mockBio),
      ...overrides,
    ],
  );

  final before = await container.read(appSettingsProvider.future);
  alsoCheckBefore?.call();

  await tap(tester, find.byKey(switchBtn.key));
  final after = await container.read(appSettingsProvider.future);
  alsoCheckAfter?.call();

  expect(settingValue(before), isNot(settingValue(after)));
}
