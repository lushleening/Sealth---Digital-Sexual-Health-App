import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/appointments/appointment_sync.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/recently_viewed_provider.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/navigation/nav_router.dart';
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/notifications/notification_service.dart';
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
  // For inserting data into mock database
  MockSupabaseHttpClient? supabaseMockClient,

  // Use Guest or Registered User (works for UI, some config are needed to mock backend behavior)
  bool asRegisteredUser = false,

  // Use with otherOverrides
  bool overrideSettings = true,

  AppointmentSyncService? mockAppointmentSyncService,

  // Other overrides
  List<Override> otherOverrides = const [],
}) {
  // Some mocks
  final testDB = Database(NativeDatabase.memory());
  addTearDown(() => testDB.close());

  final mockNotiService = MockNotificationService();
  when(() => mockNotiService.cancelNotification(any())).thenAnswer((_) async {});


  return ProviderContainer.test(
    overrides: [
      appMetadataProvider.overrideWith(TestAppMetadataNotifier.new),
      databaseProvider.overrideWithValue(testDB),

      supabaseServiceProvider.overrideWithValue(
        SupabaseClient(
          'https://mock.supabase.co',
          'fakeAnonKey',
          httpClient: supabaseMockClient ?? MockSupabaseHttpClient(),
          authOptions: const AuthClientOptions(autoRefreshToken: false),
        ),
      ),

      // No need loading here, just mock all required data
      if (overrideSettings)
        appSettingsProvider.overrideWith(TestAppSettingsNotifier.new),

      if (mockAppointmentSyncService != null)
        appointmentSyncServiceProvider.overrideWithValue(
          mockAppointmentSyncService,
        ),

      authUserIdProvider.overrideWith(
        (ref) => Stream.value(asRegisteredUser ? remoteId : null),
      ),

      if (asRegisteredUser) ...[
        appUserProvider.overrideWith(TestAppRegisteredNotifier.new),
        appRegisteredProfileProvider.overrideWith(
          TestAppRegisteredProfileNotifier.new,
        ),
      ] else
        appUserProvider.overrideWith(TestAppGuestNotifier.new),

      // TODO OVERRIDE IT YOURSELF IN otherOverrides DONT FUCKING PUT HERE YOURRE FAILING MY TESTS
      // appNotificationProvider.overrideWith(TestAppNotificationNoneNotifier.new),

      recentlyViewedProvider.overrideWith((ref) {
        final dao = MockRecentlyViewedDAO();
        when(() => dao.getRecentlyViewed(any())).thenAnswer((_) async => []);
        when(() => dao.upsertViewed(any(), any())).thenAnswer((_) async {});
        return RecentlyViewedNotifier(dao: dao, localId: 'test-user');
      }),

      notificationPluginProvider.overrideWithValue(
        MockFlutterLocalNotificationsPlugin(),
      ),
      notificationServiceProvider.overrideWithValue(mockNotiService),

      supabaseHealthCheckProvider.overrideWith((_) async => true),

      ...otherOverrides,
    ],
  );
}

// Initializes the widget for testing purposes
// Must align with app's expectations and use the mock version if exists
Future<ProviderContainer> initWidget({
  required WidgetTester tester,
  String? path,
  bool asRegisteredUser = false,
  bool overrideSettings = true,
  AppointmentSyncService? mockAppointmentSyncService,
  List<Override> otherOverrides = const [],
}) async {
  // Used for accessing providers
  final container =
      getContainer(
        asRegisteredUser: asRegisteredUser,
        overrideSettings: overrideSettings,
        mockAppointmentSyncService: mockAppointmentSyncService,
        otherOverrides: otherOverrides,
      );

  // Builds the app
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: Consumer(builder: (context, ref, _) => buildApp(ref)),
    ),
  );
  // pumpAndSettle hangs on LoadingPage's repeating animation; use fixed pumps instead.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));

  if (path != null) {
    container.read(navRouter).go(path);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }
  return container;
}

// Resets initWidget in one test
// Use this on your own consequence and make sure you know what you're doing
Future<void> resetWidget(
  ProviderContainer container,
  WidgetTester tester,
) async {
  container.read(databaseProvider).close();
  container.dispose();
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpAndSettle();
}

// Tests the back button functionality of subpages
Future<void> testPageBackButtons({
  required WidgetTester tester,
  required String start,
  required KBtn toSubPageBtn,
  String? targetPath, // Try to use this for pages
  Object? targetObj, // Checks expectObj under the hood
  KBtn? backButton,
  bool asRegisteredUser = false,
  AppointmentSyncService? mockAppointmentSyncService,
  List<Override> otherOverrides = const [],
}) async {
  if (targetPath == null && targetObj == null) {
    throw Exception("One target must at least be specified");
  }

  // Checks system's back button
  final c1 = await initWidget(
    tester: tester,
    path: start,
    asRegisteredUser: asRegisteredUser,
    mockAppointmentSyncService: mockAppointmentSyncService,
    otherOverrides: otherOverrides,
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
      mockAppointmentSyncService: mockAppointmentSyncService,
      otherOverrides: otherOverrides,
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
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

// Equivalent to phone's back button
Future<void> systemBack(WidgetTester tester) async {
  // https://github.com/flutter/flutter/blob/master/packages/flutter/test/material/will_pop_test.dart
  await tester.binding.handlePopRoute();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  // final dynamic bb = tester.state(find.byType(WidgetsApp));
  // await bb.didPopRoute();
}
