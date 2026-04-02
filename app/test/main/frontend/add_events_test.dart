import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

void main() {
  late MockAppointmentSyncService mockSyncService;

  setUp(() {
    mockSyncService = MockAppointmentSyncService();
    when(() => mockSyncService.getCachedClinics()).thenAnswer((_) async => []);
    when(() => mockSyncService.syncClinics()).thenAnswer((_) async {});
    when(
      () => mockSyncService.getCachedAppointments(any()),
    ).thenAnswer((_) async => []);
    when(() => mockSyncService.syncAppointments()).thenAnswer((_) async {});
  });

  testWidgets('AddEventPage renders correctly', (WidgetTester tester) async {
    await initWidget(
      tester: tester,
      path: AppRoute.addEvent, // was AppRoute.addEventR
      mockAppointmentSyncService: mockSyncService,
    );

    expect(find.text('Add New Appointment'), findsOneWidget);
    expectObj(KBtn.eventaddbutton);
    expectObj(KBtn.cancelbutton);
  });

  testWidgets('Add button is tappable', (WidgetTester tester) async {
    await initWidget(
      tester: tester,
      path: AppRoute.addEvent, // was AppRoute.addEventR
      mockAppointmentSyncService: mockSyncService,
    );

    await tap(tester, find.byKey(KBtn.eventaddbutton.key));
    expectObj(KBtn.eventaddbutton);
  });

  testWidgets('Cancel button navigates back', (WidgetTester tester) async {
    final container = await initWidget(
      tester: tester,
      path: AppRoute.addEvent, // was AppRoute.addEventR
      mockAppointmentSyncService: mockSyncService,
    );

    await tap(tester, find.byKey(KBtn.cancelbutton.key));
    expectPath(container, AppRoute.appointments);
  });
}
