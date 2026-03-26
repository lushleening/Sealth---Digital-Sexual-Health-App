import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/navigation/main_page_route.dart';
import 'package:sddp_dsh/backend/navigation/nav_router.dart';
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/articles/providers/articles_provider.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/main.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';

import 'mock_objects.dart';

ProviderContainer getContainer(bool asRegisteredUser) => ProviderContainer.test(
  overrides: [
    // No need loading here, just mock all required data
    appSettingsProvider.overrideWith(TestAppSettingsNotifier.new),
    appMetadataProvider.overrideWith(TestAppMetadataNotifier.new),
    articlesProvider.overrideWith((_) => TestArticlesNotifier()),

    if (asRegisteredUser) ...[
      appUserProvider.overrideWith(TestAppRegisteredNotifier.new),
      appRegisteredProfileProvider.overrideWith(
        TestAppRegisteredProfileNotifier.new,
      ),
    ] else
      appUserProvider.overrideWith(TestAppGuestNotifier.new),
  ],
);

// TODO
// There's a setup all here you can use https://pub.dev/packages/mock_supabase_http_client
// final mockSupabase = SupabaseClient(
//   'https://mock.supabase.co', // Does not matter what URL you pass here as long as it's a valid URL
//   'fakeAnonKey', // Does not matter what string you pass here
//   httpClient: MockSupabaseHttpClient(),
// );

// Initializes the widget for testing purposes
// Must align with app's expectations and use the mock version if exists
Future<ProviderContainer> initWidget({
  required WidgetTester tester,
  String? path,
  bool asRegisteredUser = false,
}) async {
  final container = getContainer(asRegisteredUser);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: Consumer(builder: (context, ref, _) => buildApp(ref)),
    ),
  );
  await tester.pumpAndSettle();

  if (path != null) {
    container.read(navRouter).go(path);
    await tester.pumpAndSettle();
  }

  return container; // Can be used for accessing providers in this context
}

// Resets initWidget
// Definitely do not recommend using this function unless circumstances required / you know what you are doing
// Find alternatives instead
// e.g. arranging your group() and testWidget() better
Future<void> resetWidget(
  ProviderContainer container,
  WidgetTester tester,
) async {
  container.dispose();
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpAndSettle();
}

// Tests the back button functionality of subpages
Future<void> testSubPageBackButtons({
  required WidgetTester tester,
  required String start,
  required KBtn toSubPageBtn,
  required KPage target,
  KBtn? backButton,
  bool asRegisteredUser = false,
}) async {
  // Checks system's back button
  final c = await initWidget(
    tester: tester,
    path: start,
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
      path: start,
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

void expectCurrentPath(ProviderContainer container, String path) => expect(
  container.read(navRouter).routeInformationProvider.value.uri.toString(),
  path,
);

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
