import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

void main() {
  late MockAppointmentSyncService mockSyncService;

  final startTime = DateTime(2026, 11, 9, 10, 0);
  final endTime = DateTime(2026, 11, 9, 10, 30);

  setUp(() {
    mockSyncService = MockAppointmentSyncService();

    when(
      () => mockSyncService.insertGuestAppointment(
        clinicId: any(named: 'clinicId'),
        serviceId: any(named: 'serviceId'),
        startTime: any(named: 'startTime'),
        endTime: any(named: 'endTime'),
        notes: any(named: 'notes'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => mockSyncService.getCachedAppointments(any()),
    ).thenAnswer((_) async => [testAppointment]);

    when(() => mockSyncService.syncAppointments()).thenAnswer((_) async {});
  });

  group('CreateAppointment - guest user', () {
    test('inserts into local Drift when user is not logged in', () async {
      final container = getContainer(
        mockAppointmentSyncService: mockSyncService,
        asRegisteredUser: false, // guest
      );

      final creator = container.read(createAppointmentProvider);
      final result = await creator.createAppointment(
        userId: '',
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: startTime,
        endTime: endTime,
        notes: 'Test notes',
      );

      result.when(
        success: (_) => expect(true, true),
        failure: (e) => fail('Expected success but got: $e'),
      );

      verify(
        () => mockSyncService.insertGuestAppointment(
          clinicId: testClinicId,
          serviceId: testServiceId,
          startTime: startTime,
          endTime: endTime,
          notes: 'Test notes',
        ),
      ).called(1);
    });

    test('returns failure when insertGuestAppointment throws', () async {
      when(
        () => mockSyncService.insertGuestAppointment(
          clinicId: any(named: 'clinicId'),
          serviceId: any(named: 'serviceId'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
          notes: any(named: 'notes'),
        ),
      ).thenThrow(Exception('DB error'));

      final container = getContainer(
        mockAppointmentSyncService: mockSyncService,
        asRegisteredUser: false,
      );

      final creator = container.read(createAppointmentProvider);
      final result = await creator.createAppointment(
        userId: '',
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: startTime,
        endTime: endTime,
      );

      result.when(
        success: (_) => fail('Expected failure'),
        failure: (e) => expect(e, contains('DB error')),
      );
    });
  });

  group('userAppointmentsProvider - guest user', () {
    test('returns cached appointments for guest', () async {
      final container = getContainer(
        mockAppointmentSyncService: mockSyncService,
        asRegisteredUser: false,
      );

      await container.pump();

      final appointments = await container.read(
        userAppointmentsProvider.future,
      );

      expect(appointments.length, 1);
      expect(appointments.first.id, testAppointmentId);
      verify(() => mockSyncService.getCachedAppointments(any())).called(1);
    });

    test('returns empty list when no cached appointments', () async {
      when(
        () => mockSyncService.getCachedAppointments(any()),
      ).thenAnswer((_) async => []);

      final container = getContainer(
        mockAppointmentSyncService: mockSyncService,
        asRegisteredUser: false,
      );

      final appointments = await container.read(
        userAppointmentsProvider.future,
      );
      expect(appointments.isEmpty, true);
    });
  });

  group('userAppointmentsProvider - registered user', () {
    test(
      'returns appointments from sync service for registered user',
      () async {
        final container = getContainer(
          mockAppointmentSyncService: mockSyncService,
          asRegisteredUser: true,
        );

        await container.pump();

        final appointments = await container.read(
          userAppointmentsProvider.future,
        );

        expect(appointments.length, 1);
        expect(appointments.first.id, testAppointmentId);
      },
    );
  });
}
