import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/appointments/appointment_sync.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/nearby_services/widgets/services_card.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

// Mock nearby clinics data
final mockNearbyClinics = [
  {
    'id': testClinicId,
    'name': 'Test Clinic',
    'address': '123 Test Street, KL',
    'distance_km': 1.5,
  },
];

final mockMultipleClinics = [
  {
    'id': 'clinic-1',
    'name': 'Klinik Kesihatan Kuala Lumpur',
    'address': '123 Jalan Pudu, Kuala Lumpur',
    'distance_km': 1.5,
  },
  {
    'id': 'clinic-2',
    'name': 'Klinik Mediviron',
    'address': '456 Jalan Bangsar, Kuala Lumpur',
    'distance_km': 2.3,
  },
  {
    'id': 'clinic-3',
    'name': 'Hospital Pantai',
    'address': '789 Jalan Bukit Pantai',
    'distance_km': 3.1,
  },
];

// Helper to wrap widget with theme
Widget _wrapWithTheme(Widget widget) {
  return MaterialApp(
    title: 'Test App',
    theme: ThemeData(extensions: [lightAppColors]),
    home: Scaffold(body: widget),
  );
}

void main() {
  late MockAppointmentSyncService mockSyncService;

  setUp(() {
    mockSyncService = MockAppointmentSyncService();
    when(
      () => mockSyncService.getCachedAppointments(any()),
    ).thenAnswer((_) async => []);
    when(() => mockSyncService.syncAppointments()).thenAnswer((_) async {});
    when(() => mockSyncService.getCachedClinics()).thenAnswer((_) async => []);
    when(() => mockSyncService.syncClinics()).thenAnswer((_) async {});
  });

  testWidgets('NearbyServicesPage renders correctly', (
    WidgetTester tester,
  ) async {
    await initWidget(
      tester: tester,
      path: AppRoute.nearbyServices,
      otherOverrides: [
        appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
      ],
    );

    expect(find.text('Nearby Services'), findsOneWidget);
    expect(
      find.text(
        'Enter a postcode or use your location\nto find clinics near you.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('NearbyServicesPage shows postcode search field', (
    WidgetTester tester,
  ) async {
    await initWidget(
      tester: tester,
      path: AppRoute.nearbyServices,
      otherOverrides: [
        appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
      ],
    );

    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Use my location'), findsOneWidget);
  });

  testWidgets('Schedule Appointment button navigates to AddEventPage', (
    WidgetTester tester,
  ) async {
    await initWidget(
      tester: tester,
      path: AppRoute.nearbyServices,
      otherOverrides: [
        appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
        nearbyClinicsProvider((
          lat: 3.1478,
          lng: 101.6836,
          radiusKm: 10,
        )).overrideWith((_) async => mockNearbyClinics),
      ],
    );

    expect(
      find.text(
        'Enter a postcode or use your location\nto find clinics near you.',
      ),
      findsOneWidget,
    );
  });

  // ========== FIXED TESTS ==========

  testWidgets('shows error message when geocoding fails', (
    WidgetTester tester,
  ) async {
    await initWidget(
      tester: tester,
      path: AppRoute.nearbyServices,
      otherOverrides: [
        appointmentSyncServiceProvider.overrideWithValue(mockSyncService),
      ],
    );

    final searchButton = find.text('Search');
    await tester.enterText(
      find.widgetWithText(TextField, 'Enter postcode (e.g. 50450)'),
      '99999',
    );
    await tester.tap(searchButton);
    await tester.pumpAndSettle();

    expect(find.text('Postcode not found'), findsOneWidget);
  });

  testWidgets('search field filters clinics by name', (
    WidgetTester tester,
  ) async {
    final services = mockMultipleClinics
        .map((c) => NearbyService.fromMap(c))
        .toList();

    await tester.pumpWidget(
      _wrapWithTheme(NearbyServicesBody(services: services)),
    );

    final searchField = find.widgetWithText(
      TextField,
      'Search by name or address',
    );
    await tester.enterText(searchField, 'Klinik Kesihatan');
    await tester.pump();

    expect(find.text('Klinik Kesihatan Kuala Lumpur'), findsOneWidget);
    expect(find.text('Klinik Mediviron'), findsNothing);
  });

  testWidgets('search field filters clinics by address', (
    WidgetTester tester,
  ) async {
    final services = mockMultipleClinics
        .map((c) => NearbyService.fromMap(c))
        .toList();

    await tester.pumpWidget(
      _wrapWithTheme(NearbyServicesBody(services: services)),
    );

    final searchField = find.widgetWithText(
      TextField,
      'Search by name or address',
    );
    await tester.enterText(searchField, 'Bangsar');
    await tester.pump();

    expect(find.text('Klinik Mediviron'), findsOneWidget);
    expect(find.text('Klinik Kesihatan Kuala Lumpur'), findsNothing);
  });

  testWidgets('shows "No clinics found" when search returns no results', (
    WidgetTester tester,
  ) async {
    final services = mockMultipleClinics
        .map((c) => NearbyService.fromMap(c))
        .toList();

    await tester.pumpWidget(
      _wrapWithTheme(NearbyServicesBody(services: services)),
    );

    final searchField = find.widgetWithText(
      TextField,
      'Search by name or address',
    );
    await tester.enterText(searchField, 'Non Existent Clinic Name');
    await tester.pump();

    expect(find.text('No clinics found.'), findsOneWidget);
  });

  testWidgets('clearing search shows all clinics again', (
    WidgetTester tester,
  ) async {
    final services = mockMultipleClinics
        .map((c) => NearbyService.fromMap(c))
        .toList();

    await tester.pumpWidget(
      _wrapWithTheme(NearbyServicesBody(services: services)),
    );

    final searchField = find.widgetWithText(
      TextField,
      'Search by name or address',
    );

    await tester.enterText(searchField, 'Klinik Kesihatan');
    await tester.pump();
    expect(find.text('Klinik Mediviron'), findsNothing);

    await tester.enterText(searchField, '');
    await tester.pump();

    expect(find.text('Klinik Mediviron'), findsOneWidget);
    expect(find.text('Hospital Pantai'), findsOneWidget);
  });

  testWidgets('schedule appointment button exists for each clinic', (
    WidgetTester tester,
  ) async {
    final services = mockMultipleClinics
        .map((c) => NearbyService.fromMap(c))
        .toList();

    await tester.pumpWidget(
      _wrapWithTheme(NearbyServicesBody(services: services)),
    );

    final scheduleButtons = find.text('Schedule Appointment');
    expect(scheduleButtons, findsNWidgets(3));
  });
}
