import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/navigation/nav_router.dart';
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/user/app_settings/app_settings.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/main.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'mock_objects.dart';

// Provides the container to read providers
// Checkout initWidgets instead for usage
ProviderContainer getContainer({
  MockSupabaseHttpClient?
  supabaseMockClient, // For inserting data into mock database
  required bool asRegisteredUser, // Use Guest or Registered User
}) => ProviderContainer.test(
  overrides: [
    supabaseServiceProvider.overrideWithValue(
      SupabaseClient(
        'https://mock.supabase.co',
        'fakeAnonKey',
        httpClient: supabaseMockClient ?? MockSupabaseHttpClient(),
        authOptions: const AuthClientOptions(autoRefreshToken: false),
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
  MockSupabaseHttpClient? supabaseMockClient,
  bool asRegisteredUser = false,
}) async {
  // Used for accessing providers
  final container = getContainer(
    supabaseMockClient: supabaseMockClient,
    asRegisteredUser: asRegisteredUser,
  );
  
  // Builds the app
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

  return container;
}

// Resets initWidget in one test
// Use this on your own consequence and make sure you know what you're doing
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
  String? targetPath, // Try to use this for pages
  Object? targetObj, // Checks expectObj under the hood
  KBtn? backButton,
  bool asRegisteredUser = false,
}) async {
  if (targetPath == null && targetObj == null) {
    throw Exception("One target must at least be specified");
  }

  // Checks system's back button
  final c1 = await initWidget(
    tester: tester,
    path: start,
    asRegisteredUser: asRegisteredUser,
  );
  await tap(tester, find.byKey(toSubPageBtn.key));
  if (targetObj != null) expectObj(targetObj);
  if (targetPath != null) expectPath(c1, targetPath);
  await systemBack(tester);
  expectPath(c1, start);

  // Reset
  await resetWidget(c1, tester);

  // Checks app's back button
  if (backButton != null) {
    final c2 = await initWidget(
      tester: tester,
      path: start,
      asRegisteredUser: asRegisteredUser,
    );
    await tap(tester, find.byKey(toSubPageBtn.key));
    if (targetObj != null) expectObj(targetObj);
    if (targetPath != null) expectPath(c2, targetPath);
    await tap(tester, find.byKey(backButton.key));
    expectPath(c2, start);
  }
}

// Catch-all helper function for expecting objects in testing
// default expecting findsOneWidget but you can change that
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

// Helper function that checks the current path of the navRouter (Navigtion 2.0)
void expectPath(ProviderContainer container, String path) => expect(
  container.read(navRouter).routeInformationProvider.value.uri.toString(),
  path,
);

// Less error prone version of tester.tap()
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
