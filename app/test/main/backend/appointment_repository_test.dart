import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/database/database_control/repositories/appointment_repository.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';

import '../../helper/mock_objects.dart';

// ─── Helpers ──────────────────────────────────────────────────────────────────

/// Builds a [CachedAppointment] value object for use in mock return values.
CachedAppointment _makeCachedAppointment({
  required String id,
  required String userId,
  required String clinicId,
  required String serviceId,
  String clinicName = 'Test Clinic',
  String serviceName = 'Test Service',
  bool needsSync = true,
  String? notes,
  DateTime? startTime,
  DateTime? endTime,
}) {
  final now = DateTime.now();
  return CachedAppointment(
    id: id,
    userId: userId,
    clinicId: clinicId,
    serviceId: serviceId,
    clinicName: clinicName,
    serviceName: serviceName,
    needsSync: needsSync,
    notes: notes,
    startTime: startTime ?? now,
    endTime: endTime ?? now.add(const Duration(minutes: 30)),
    lastSynced: now,
  );
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late MockAppointmentsDAO mockDao;
  late AppointmentRepository repository;

  setUp(() {
    mockDao = MockAppointmentsDAO();
    repository = AppointmentRepository(dao: mockDao);
  });

  // ── getPendingAppointments ─────────────────────────────────────────────────

  group('getPendingAppointments', () {
    test('returns empty list when DAO returns no pending appointments',
        () async {
      when(() => mockDao.getPendingAppointments(any()))
          .thenAnswer((_) async => []);

      final result = await repository.getPendingAppointments(
        localId,
        remoteId,
      );

      expect(result, isEmpty);
      verify(() => mockDao.getPendingAppointments(localId)).called(1);
    });

    test('maps CachedAppointment rows to AppointmentSyncable with remoteUserId',
        () async {
      final now = DateTime.now();
      final end = now.add(const Duration(minutes: 30));

      final cached = _makeCachedAppointment(
        id: testAppointmentId,
        userId: localId,
        clinicId: testClinicId,
        serviceId: testServiceId,
        notes: 'Some notes',
        startTime: now,
        endTime: end,
      );

      when(() => mockDao.getPendingAppointments(any()))
          .thenAnswer((_) async => [cached]);

      final result = await repository.getPendingAppointments(localId, remoteId);

      expect(result.length, 1);

      final syncable = result.first;
      expect(syncable.id, testAppointmentId);
      // userId on the syncable should be the remoteUserId, not the localId
      expect(syncable.userId, remoteId);
      expect(syncable.clinicId, testClinicId);
      expect(syncable.serviceId, testServiceId);
      expect(syncable.notes, 'Some notes');
      expect(syncable.startTime, now);
      expect(syncable.endTime, end);
    });

    test('maps multiple rows, all receiving remoteUserId', () async {
      final rows = [
        _makeCachedAppointment(
          id: 'appt-1',
          userId: localId,
          clinicId: 'clinic-1',
          serviceId: 'service-1',
        ),
        _makeCachedAppointment(
          id: 'appt-2',
          userId: localId,
          clinicId: 'clinic-2',
          serviceId: 'service-2',
        ),
      ];

      when(() => mockDao.getPendingAppointments(any()))
          .thenAnswer((_) async => rows);

      final result = await repository.getPendingAppointments(localId, remoteId);

      expect(result.length, 2);
      expect(result.every((s) => s.userId == remoteId), isTrue);
      expect(result.map((s) => s.id), containsAll(['appt-1', 'appt-2']));
    });

    test('passes localUserId (not remoteId) to the DAO', () async {
      when(() => mockDao.getPendingAppointments(any()))
          .thenAnswer((_) async => []);

      await repository.getPendingAppointments(localId, remoteId);

      // DAO must be queried with localId so it filters by the correct SQLite row
      verify(() => mockDao.getPendingAppointments(localId)).called(1);
      verifyNever(() => mockDao.getPendingAppointments(remoteId));
    });

    test('propagates exceptions thrown by the DAO', () async {
      when(() => mockDao.getPendingAppointments(any()))
          .thenThrow(Exception('DB error'));

      expect(
        () => repository.getPendingAppointments(localId, remoteId),
        throwsException,
      );
    });
  });

  // ── markAsSynced ───────────────────────────────────────────────────────────

  group('markAsSynced', () {
    test('delegates to DAO with the given appointmentId', () async {
      when(() => mockDao.markAsSynced(any())).thenAnswer((_) async {});

      await repository.markAsSynced(testAppointmentId);

      verify(() => mockDao.markAsSynced(testAppointmentId)).called(1);
    });

    test('completes normally when DAO succeeds', () async {
      when(() => mockDao.markAsSynced(any())).thenAnswer((_) async {});

      await expectLater(repository.markAsSynced(testAppointmentId), completes);
    });

    test('propagates exceptions thrown by the DAO', () async {
      when(() => mockDao.markAsSynced(any()))
          .thenThrow(Exception('DB error'));

      expect(
        () => repository.markAsSynced(testAppointmentId),
        throwsException,
      );
    });
  });
}