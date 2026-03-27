import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/navigation/nav_router.dart';
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/articles/providers/articles_provider.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/main.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'mock_objects.dart';

ProviderContainer getContainer(bool asRegisteredUser) => ProviderContainer.test(
  overrides: [
    supabaseServiceProvider.overrideWithValue(
      SupabaseClient(
        'https://mock.supabase.co',
        'fakeAnonKey',
        httpClient: MockSupabaseHttpClient(),
        authOptions: const AuthClientOptions(
          autoRefreshToken: false,
        ),
      ),
    ),

    // No need loading here, just mock all required data
    appSettingsProvider.overrideWith(TestAppSettingsNotifier.new),
    appMetadataProvider.overrideWith(TestAppMetadataNotifier.new),
    // articlesProvider.overrideWith((_) => TestArticlesNotifier()), // TODO fix your provider first

    if (asRegisteredUser) ...[
      appUserProvider.overrideWith(TestAppRegisteredNotifier.new),
      appRegisteredProfileProvider.overrideWith(
        TestAppRegisteredProfileNotifier.new,
      ),
    ] else
      appUserProvider.overrideWith(TestAppGuestNotifier.new),
  ],
);


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
  final c1 = await initWidget(
    tester: tester,
    path: start,
    asRegisteredUser: asRegisteredUser,
  );
  await tap(tester, find.byKey(toSubPageBtn.key));
  expectObj(target);
  await systemBack(tester);
  expectPath(c1, start);

  await resetWidget(c1, tester);

  // Checks app's back button
  if (backButton != null) {
    final c2 = await initWidget(
      tester: tester,
      path: start,
      asRegisteredUser: asRegisteredUser,
    );
    await tap(tester, find.byKey(toSubPageBtn.key));
    expectObj(target);
    await tap(tester, find.byKey(backButton.key));
    expectPath(c2, start);
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

void expectPath(ProviderContainer container, String path) => expect(
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
  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();
  // final dynamic bb = tester.state(find.byType(WidgetsApp));
  // await bb.didPopRoute();
}

// TODO golden tests???
