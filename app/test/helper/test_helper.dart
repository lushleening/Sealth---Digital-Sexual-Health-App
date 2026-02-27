import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/common_widgets/main_scaffold.dart';
import 'package:sddp_dsh/helper/app_metadata.dart';
import 'package:sddp_dsh/nav/main_page_route.dart';
import 'package:sddp_dsh/pages/home/subpages/profile/subpages/settings/providers/app_settings.dart';
import 'package:sddp_dsh/providers/app_init.dart';
import 'package:sddp_dsh/providers/articles_provider.dart';
import 'package:sddp_dsh/testing/key_enum.dart';
import 'package:sddp_dsh/main.dart';
import 'package:sddp_dsh/user/app_user.dart';
import 'package:sddp_dsh/user/registered_profile.dart';

import 'mock_objects.dart';

// Initializes the widget for testing purposes
// Must align with app's expectations and use the mock version if exists
Future<ProviderContainer> initWidget({
  required WidgetTester tester,
  Widget? home,
  bool asRegisteredUser = false,
}) async {
  final container = ProviderContainer.test(
    overrides: [
      // No need loading here, just mock all required data
      appInitDoneProvider.overrideWith((_) async => true),
      appSettingsProvider.overrideWith(TestAppSettingsNotifier.new),
      appMetadataProvider.overrideWith(TestAppMetadataNotifier.new),
      articlesProvider.overrideWith((_) => TestArticlesNotifier()),

      if (asRegisteredUser) ...[
        appUserProvider.overrideWith(TestAppRegisteredNotifier.new),
        registeredProfileProvider.overrideWith(
          TestRegisteredProfileNotifier.new,
        ),
      ] else
        appUserProvider.overrideWith(TestAppGuestNotifier.new),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: Consumer(
        builder: (context, ref, _) => buildApp(ref, home: home ?? MyApp()),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container; // Can be used for accessing providers in this context
}

// Resets initWidget
// Definitely do not recommend using this function unless circumstances required, find alternatives instead
// e.g. arranging your group() and testWidget() better
Future<void> resetWidget(
  ProviderContainer container,
  WidgetTester tester,
) async {
  container.dispose();
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpAndSettle();
}

// Start testing from clicking a bottom nav btn and going to that page
// Returns ProviderContainer to check for riverpod
// Remember to await this function
Future<ProviderContainer> startFromMainScaffold(
  WidgetTester tester,
  MainPageRoute route,
) async {
  final container = await initWidget(tester: tester, home: MainScaffold());
  await tap(tester, find.byKey(route.from.key));
  expectMainPage(container, route);
  return container;
}

// Start from MainScaffold
// Taps a button and expects the corresponding page to appear
Future<void> mainPageToSubPage({
  required WidgetTester tester,
  required MainPageRoute start,
  required KBtn btn,
  required KPage target,
}) async {
  await startFromMainScaffold(tester, start);
  await tap(tester, find.byKey(btn.key));
  expectObj(target);
}

// Tests the back button functionality of subpages
Future<void> testSubPageBackButtons({
  required WidgetTester tester,
  required Widget start,
  required KBtn toSubPageBtn,
  required KPage target,
  KBtn? backButton,
  bool asRegisteredUser = false,
}) async {
  // Checks system's back button
  final c = await initWidget(
    tester: tester,
    home: start,
    asRegisteredUser: asRegisteredUser,
  );
  await tap(tester, find.byKey(toSubPageBtn.key));
  expectObj(target);
  await systemBack(tester);
  expectObj(start);

  await resetWidget(c, tester);

  // Checks app's back button
  if (backButton != null) {
    await initWidget(
      tester: tester,
      home: start,
      asRegisteredUser: asRegisteredUser,
    );
    await tap(tester, find.byKey(toSubPageBtn.key));
    expectObj(target);
    await tap(tester, find.byKey(backButton.key));
    expectObj(start);
  }
}

// Providing a list of buttons,
// this function will start from the very first app initialization until
// the target page by pressing according to the button list
Future<ProviderContainer> goToSubPageFromStart({
  required WidgetTester tester,
  required List<KBtn> btnList,
  required KPage target,
}) async {
  final container = await initWidget(tester: tester);
  for (final btn in btnList) {
    await tap(tester, find.byKey(btn.key));
  }
  expectObj(target);
  return container;
}

// Expects
void expectMainPage(ProviderContainer container, MainPageRoute idx) {
  expect(find.byKey(idx.to.key), findsOneWidget);
  expect(container.read(mainPageRouteProvider), idx);
}

// Catch-all helper function for expecting objects in testing
// default expecting one but you can change that
// used to shorten the normal expect function
void expectObj(Object o, {Matcher m = findsOneWidget}) {
  switch (o) {
    case KBtn k:
      expect(find.byKey(k.key), m);
      break;
    case KPage k:
      expect(find.byKey(k.key), m);
      break;
    case Type t:
      expect(find.byType(t), m);
      break;
    case String s:
      expect(find.text(s), m);
      break;
    case Widget w:
      expect(find.byWidget(w), m);
      break;
    default:
      throw ArgumentError('Unsupported type: ${o.runtimeType}');
  }
}

// User operations
Future<void> tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.tap(f);
  await tester.pumpAndSettle();
}

// Equivalent to phone's back button
Future<void> systemBack(WidgetTester tester) async {
  // https://github.com/flutter/flutter/blob/master/packages/flutter/test/material/will_pop_test.dart
  final dynamic bb = tester.state(find.byType(WidgetsApp));
  await bb.didPopRoute();
  await tester.pumpAndSettle();
}

// TODO golden tests???
