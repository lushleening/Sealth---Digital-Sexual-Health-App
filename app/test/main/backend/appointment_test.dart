import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/appointments/appointment_sync.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_service.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';

import '../../helper/mock_objects.dart';
import '../../helper/test_helper.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Stubs every method on [MockAppointmentSyncService] that may be called
/// during provider initialisation so mocktail never returns null for a
/// Future-returning method.
void _stubSyncDefaults(MockAppointmentSyncService mock) {
  when(() => mock.getCachedAppointments(any()))
      .thenAnswer((_) async => []);
  when(() => mock.getCachedClinics())
      .thenAnswer((_) async => []);
  when(() => mock.getCachedServices(any()))
      .thenAnswer((_) async => []);
  when(() => mock.syncAppointments()).thenAnswer((_) async {});
  when(() => mock.syncClinics()).thenAnswer((_) async {});
  when(() => mock.syncServices()).thenAnswer((_) async {});
  when(() => mock.checkForConflict(
        clinicId: any(named: 'clinicId'),
        startTime: any(named: 'startTime'),
        endTime: any(named: 'endTime'),
        excludeAppointmentId: any(named: 'excludeAppointmentId'),
      )).thenAnswer((_) async => false);
  when(() => mock.insertGuestAppointment(
        clinicId: any(named: 'clinicId'),
        serviceId: any(named: 'serviceId'),
        startTime: any(named: 'startTime'),
        endTime: any(named: 'endTime'),
        notes: any(named: 'notes'),
      )).thenAnswer((_) async {});
  when(() => mock.insertRegisteredAppointmentLocally(
        id: any(named: 'id'),
        userId: any(named: 'userId'),
        clinicId: any(named: 'clinicId'),
        serviceId: any(named: 'serviceId'),
        startTime: any(named: 'startTime'),
        endTime: any(named: 'endTime'),
        notes: any(named: 'notes'),
        needsSync: any(named: 'needsSync'),
      )).thenAnswer((_) async {});
  when(() => mock.deleteGuestAppointments()).thenAnswer((_) async {});
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(SyncTable.appointments);
  });

  // ─── Result wrapper ───────────────────────────────────────────────────────
  group('Result wrapper', () {
    test('success holds value and null error', () {
      const r = Result.success(42);
      expect(r.value, 42);
      expect(r.error, isNull);
    });

    test('failure holds error and null value', () {
      const r = Result<int>.failure('oops');
      expect(r.error, 'oops');
      expect(r.value, isNull);
    });

    test('when() calls success callback', () {
      const r = Result.success('ok');
      String? got;
      r.when(success: (v) => got = v, failure: (_) => fail('wrong branch'));
      expect(got, 'ok');
    });

    test('when() calls failure callback', () {
      const r = Result<String>.failure('bad');
      String? got;
      r.when(success: (_) => fail('wrong branch'), failure: (e) => got = e);
      expect(got, 'bad');
    });
  });

  
  // ─── clinicsProvider ─────────────────────────────────────────────────────
  group('clinicsProvider', () {
    test('returns empty list when cache and remote are empty', () async {
      final c = getContainer();
      addTearDown(c.dispose);
      final result = await c.read(clinicsProvider.future);
      expect(result, isEmpty);
    });

    test('returns cached clinics without calling syncClinics eagerly',
        () async {
      final mockSync = MockAppointmentSyncService();
      _stubSyncDefaults(mockSync);
      when(() => mockSync.getCachedClinics()).thenAnswer(
        (_) async => [
          {'id': testClinicId, 'name': 'Test Clinic'},
        ],
      );

      final c = getContainer(
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSync),
        ],
      );
      addTearDown(c.dispose);

      final result = await c.read(clinicsProvider.future);
      expect(result.length, 1);
      expect(result.first['id'], testClinicId);
    });

    test('syncs from remote when cache is empty', () async {
      final mockSync = MockAppointmentSyncService();
      _stubSyncDefaults(mockSync);
      var callCount = 0;
      when(() => mockSync.getCachedClinics()).thenAnswer((_) async {
        callCount++;
        return callCount == 1
            ? []
            : [
                {'id': testClinicId, 'name': 'Test Clinic'},
              ];
      });

      final c = getContainer(
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSync),
        ],
      );
      addTearDown(c.dispose);

      final result = await c.read(clinicsProvider.future);
      verify(() => mockSync.syncClinics()).called(1);
      expect(result.length, 1);
    });
  });

  // ─── servicesProvider ────────────────────────────────────────────────────
  group('servicesProvider', () {
    test('returns empty list when no services cached', () async {
      final c = getContainer();
      addTearDown(c.dispose);
      final result = await c.read(servicesProvider(testClinicId).future);
      expect(result, isEmpty);
    });

    test('returns cached services for clinic', () async {
      final mockSync = MockAppointmentSyncService();
      _stubSyncDefaults(mockSync);
      when(() => mockSync.getCachedServices(testClinicId)).thenAnswer(
        (_) async => [
          {
            'id': testServiceId,
            'clinic_id': testClinicId,
            'name': 'STI Screening',
            'duration_minutes': 30,
          },
        ],
      );

      final c = getContainer(
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSync),
        ],
      );
      addTearDown(c.dispose);

      final result = await c.read(servicesProvider(testClinicId).future);
      expect(result.length, 1);
      expect(result.first['name'], 'STI Screening');
    });

    test('syncs services when cache is empty', () async {
      final mockSync = MockAppointmentSyncService();
      _stubSyncDefaults(mockSync);
      var callCount = 0;
      when(() => mockSync.getCachedServices(testClinicId)).thenAnswer(
          (_) async {
        callCount++;
        return callCount == 1
            ? []
            : [
                {
                  'id': testServiceId,
                  'clinic_id': testClinicId,
                  'name': 'STI Screening',
                  'duration_minutes': 30,
                },
              ];
      });

      final c = getContainer(
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSync),
        ],
      );
      addTearDown(c.dispose);

      await c.read(servicesProvider(testClinicId).future);
      verify(() => mockSync.syncServices()).called(1);
    });
  });

  // ─── userAppointmentsProvider ─────────────────────────────────────────────
  group('userAppointmentsProvider', () {
    test('returns guest appointments when not logged in', () async {
      final mockSync = MockAppointmentSyncService();
      _stubSyncDefaults(mockSync);
      when(() => mockSync.getCachedAppointments('guest'))
          .thenAnswer((_) async => [testAppointment]);

      final c = getContainer(
        asRegisteredUser: false,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSync),
        ],
      );
      addTearDown(c.dispose);

      final result = await c.read(userAppointmentsProvider.future);
      expect(result.length, 1);
      expect(result.first.id, testAppointmentId);
    });


    test('returns empty list for guest with no cached appointments', () async {
      final mockSync = MockAppointmentSyncService();
      _stubSyncDefaults(mockSync);

      final c = getContainer(
        asRegisteredUser: false,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSync),
        ],
      );
      addTearDown(c.dispose);

      final result = await c.read(userAppointmentsProvider.future);
      expect(result, isEmpty);
    });
  });

  // ─── CreateAppointment — guest ────────────────────────────────────────────
  group('CreateAppointment — guest', () {
    late MockAppointmentSyncService mockSync;
    late ProviderContainer c;

    final start = DateTime(2027, 6, 1, 10, 0);
    final end = DateTime(2027, 6, 1, 10, 30);

    setUp(() {
      mockSync = MockAppointmentSyncService();
      _stubSyncDefaults(mockSync);
      c = getContainer(
        asRegisteredUser: false,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSync),
        ],
      );
    });

    tearDown(() => c.dispose());

    test('returns success when no conflict', () async {
      // checkForConflict already returns false via _stubSyncDefaults
      final result = await c.read(createAppointmentProvider).createAppointment(
            userId: 'guest',
            clinicId: testClinicId,
            serviceId: testServiceId,
            startTime: start,
            endTime: end,
          );

      String? err;
      result.when(success: (_) {}, failure: (e) => err = e);
      expect(err, isNull);
    });

    test('returns failure when conflict exists', () async {
      when(() => mockSync.checkForConflict(
            clinicId: any(named: 'clinicId'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            excludeAppointmentId: any(named: 'excludeAppointmentId'),
          )).thenAnswer((_) async => true);

      final result = await c.read(createAppointmentProvider).createAppointment(
            userId: 'guest',
            clinicId: testClinicId,
            serviceId: testServiceId,
            startTime: start,
            endTime: end,
          );

      String? err;
      result.when(success: (_) => fail('should fail'), failure: (e) => err = e);
      expect(err, contains('already booked'));
    });

    test('conflict message includes formatted time range', () async {
      when(() => mockSync.checkForConflict(
            clinicId: any(named: 'clinicId'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            excludeAppointmentId: any(named: 'excludeAppointmentId'),
          )).thenAnswer((_) async => true);

      final result = await c.read(createAppointmentProvider).createAppointment(
            userId: 'guest',
            clinicId: testClinicId,
            serviceId: testServiceId,
            startTime: start,
            endTime: end,
          );

      String? err;
      result.when(success: (_) => fail('should fail'), failure: (e) => err = e);
      expect(err, contains('10:00'));
      expect(err, contains('10:30'));
    });

    test('returns failure when insertGuestAppointment throws', () async {
      when(() => mockSync.insertGuestAppointment(
            clinicId: any(named: 'clinicId'),
            serviceId: any(named: 'serviceId'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            notes: any(named: 'notes'),
          )).thenThrow(Exception('db error'));

      final result = await c.read(createAppointmentProvider).createAppointment(
            userId: 'guest',
            clinicId: testClinicId,
            serviceId: testServiceId,
            startTime: start,
            endTime: end,
          );

      String? err;
      result.when(success: (_) => fail('should fail'), failure: (e) => err = e);
      expect(err, isNotNull);
    });

    test('does not call insertGuestAppointment when conflict detected',
        () async {
      when(() => mockSync.checkForConflict(
            clinicId: any(named: 'clinicId'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            excludeAppointmentId: any(named: 'excludeAppointmentId'),
          )).thenAnswer((_) async => true);

      await c.read(createAppointmentProvider).createAppointment(
            userId: 'guest',
            clinicId: testClinicId,
            serviceId: testServiceId,
            startTime: start,
            endTime: end,
          );

      verifyNever(() => mockSync.insertGuestAppointment(
            clinicId: any(named: 'clinicId'),
            serviceId: any(named: 'serviceId'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            notes: any(named: 'notes'),
          ));
    });
  });

  // ─── CreateAppointment — registered user offline queue ────────────────────
  group('CreateAppointment — registered user offline queue', () {
    late MockAppointmentSyncService mockSync;
    late MockSyncService mockSyncSvc;
    late ProviderContainer c;

    final start = DateTime(2027, 6, 1, 10, 0);
    final end = DateTime(2027, 6, 1, 10, 30);

    setUp(() {
      mockSync = MockAppointmentSyncService();
      _stubSyncDefaults(mockSync);
      mockSyncSvc = MockSyncService();
      when(() => mockSyncSvc.addJob(any(), any())).thenAnswer((_) async {});

      // No supabaseMockClient — HTTP calls fail, triggering offline queue path
      c = getContainer(
        asRegisteredUser: true,
        otherOverrides: [
          appointmentSyncServiceProvider.overrideWithValue(mockSync),
          syncServiceProvider.overrideWithValue(mockSyncSvc),
        ],
      );
    });

    tearDown(() => c.dispose());

    test('conflict blocks registered user and never queues', () async {
      when(() => mockSync.checkForConflict(
            clinicId: any(named: 'clinicId'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            excludeAppointmentId: any(named: 'excludeAppointmentId'),
          )).thenAnswer((_) async => true);

      final result = await c.read(createAppointmentProvider).createAppointment(
            userId: remoteId,
            clinicId: testClinicId,
            serviceId: testServiceId,
            startTime: start,
            endTime: end,
          );

      String? err;
      result.when(success: (_) => fail('should fail'), failure: (e) => err = e);
      expect(err, contains('already booked'));

      verifyNever(() => mockSync.insertRegisteredAppointmentLocally(
            id: any(named: 'id'),
            userId: any(named: 'userId'),
            clinicId: any(named: 'clinicId'),
            serviceId: any(named: 'serviceId'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            notes: any(named: 'notes'),
            needsSync: any(named: 'needsSync'),
          ));
      verifyNever(() => mockSyncSvc.addJob(any(), any()));
    });
  });

  // ─── AppointmentSyncService — real in-memory DB ───────────────────────────
  group('AppointmentSyncService — real in-memory DB', () {
    late ProviderContainer c;

    setUp(() {
      c = getContainer(asRegisteredUser: false);
    });

    tearDown(() => c.dispose());

    test('getCachedAppointments returns empty initially', () async {
      final svc = c.read(appointmentSyncServiceProvider);
      expect(await svc.getCachedAppointments('guest'), isEmpty);
    });

    test('getCachedClinics returns empty initially', () async {
      final svc = c.read(appointmentSyncServiceProvider);
      expect(await svc.getCachedClinics(), isEmpty);
    });

    test('getCachedServices returns empty initially', () async {
      final svc = c.read(appointmentSyncServiceProvider);
      expect(await svc.getCachedServices(testClinicId), isEmpty);
    });

    test('insertGuestAppointment inserts and retrieves', () async {
      final svc = c.read(appointmentSyncServiceProvider);
      await svc.insertGuestAppointment(
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2027, 8, 1, 9, 0),
        endTime: DateTime(2027, 8, 1, 9, 30),
      );

      final result = await svc.getCachedAppointments('guest');
      expect(result.length, 1);
      expect(result.first.clinicId, testClinicId);
      expect(result.first.serviceId, testServiceId);
    });

    test('insertGuestAppointment throws on overlapping time at same clinic',
        () async {
      final svc = c.read(appointmentSyncServiceProvider);
      await svc.insertGuestAppointment(
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2027, 8, 1, 9, 0),
        endTime: DateTime(2027, 8, 1, 9, 30),
      );

      expect(
        () => svc.insertGuestAppointment(
          clinicId: testClinicId,
          serviceId: testServiceId,
          startTime: DateTime(2027, 8, 1, 9, 15),
          endTime: DateTime(2027, 8, 1, 9, 45),
        ),
        throwsException,
      );
    });

    test('back-to-back appointments at same clinic do not conflict', () async {
      final svc = c.read(appointmentSyncServiceProvider);
      await svc.insertGuestAppointment(
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2027, 8, 1, 9, 0),
        endTime: DateTime(2027, 8, 1, 9, 30),
      );
      await svc.insertGuestAppointment(
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2027, 8, 1, 9, 30),
        endTime: DateTime(2027, 8, 1, 10, 0),
      );

      expect(await svc.getCachedAppointments('guest'), hasLength(2));
    });

    test('overlapping time at different clinic does not conflict', () async {
      final svc = c.read(appointmentSyncServiceProvider);
      final start = DateTime(2027, 8, 1, 9, 0);
      final end = DateTime(2027, 8, 1, 9, 30);

      await svc.insertGuestAppointment(
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: start,
        endTime: end,
      );
      await svc.insertGuestAppointment(
        clinicId: 'other-clinic',
        serviceId: testServiceId,
        startTime: start,
        endTime: end,
      );

      expect(await svc.getCachedAppointments('guest'), hasLength(2));
    });

    test('checkForConflict returns false when no appointments', () async {
      final svc = c.read(appointmentSyncServiceProvider);
      expect(
        await svc.checkForConflict(
          clinicId: testClinicId,
          startTime: DateTime(2027, 8, 1, 9, 0),
          endTime: DateTime(2027, 8, 1, 9, 30),
        ),
        isFalse,
      );
    });

    test('checkForConflict returns true on overlap', () async {
      final svc = c.read(appointmentSyncServiceProvider);
      await svc.insertGuestAppointment(
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2027, 8, 1, 9, 0),
        endTime: DateTime(2027, 8, 1, 9, 30),
      );

      expect(
        await svc.checkForConflict(
          clinicId: testClinicId,
          startTime: DateTime(2027, 8, 1, 9, 10),
          endTime: DateTime(2027, 8, 1, 9, 40),
        ),
        isTrue,
      );
    });

    test('checkForConflict returns false for different clinic', () async {
      final svc = c.read(appointmentSyncServiceProvider);
      await svc.insertGuestAppointment(
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2027, 8, 1, 9, 0),
        endTime: DateTime(2027, 8, 1, 9, 30),
      );

      expect(
        await svc.checkForConflict(
          clinicId: 'other-clinic',
          startTime: DateTime(2027, 8, 1, 9, 0),
          endTime: DateTime(2027, 8, 1, 9, 30),
        ),
        isFalse,
      );
    });

    test('checkForConflict excludes self via excludeAppointmentId', () async {
      final svc = c.read(appointmentSyncServiceProvider);
      await svc.insertGuestAppointment(
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2027, 8, 1, 9, 0),
        endTime: DateTime(2027, 8, 1, 9, 30),
      );

      final id = (await svc.getCachedAppointments('guest')).first.id;

      expect(
        await svc.checkForConflict(
          clinicId: testClinicId,
          startTime: DateTime(2027, 8, 1, 9, 0),
          endTime: DateTime(2027, 8, 1, 9, 30),
          excludeAppointmentId: id,
        ),
        isFalse,
      );
    });

    test('deleteGuestAppointments removes all guest entries', () async {
      final svc = c.read(appointmentSyncServiceProvider);
      await svc.insertGuestAppointment(
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2027, 8, 1, 9, 0),
        endTime: DateTime(2027, 8, 1, 9, 30),
      );

      await svc.deleteGuestAppointments();
      expect(await svc.getCachedAppointments('guest'), isEmpty);
    });

    test('insertRegisteredAppointmentLocally inserts with correct userId',
        () async {
      final svc = c.read(appointmentSyncServiceProvider);
      await svc.insertRegisteredAppointmentLocally(
        userId: remoteId,
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2027, 8, 1, 9, 0),
        endTime: DateTime(2027, 8, 1, 9, 30),
      );

      expect(await svc.getCachedAppointments(remoteId), hasLength(1));
    });

    test('cross-user conflict: different userId same clinic same slot throws',
        () async {
      final svc = c.read(appointmentSyncServiceProvider);
      final start = DateTime(2027, 8, 1, 9, 0);
      final end = DateTime(2027, 8, 1, 9, 30);

      await svc.insertRegisteredAppointmentLocally(
        userId: 'user-a',
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: start,
        endTime: end,
      );

      expect(
        () => svc.insertRegisteredAppointmentLocally(
          userId: 'user-b',
          clinicId: testClinicId,
          serviceId: testServiceId,
          startTime: start,
          endTime: end,
        ),
        throwsException,
      );
    });

    test('insertRegisteredAppointmentLocally with needsSync=true succeeds',
        () async {
      final svc = c.read(appointmentSyncServiceProvider);
      await svc.insertRegisteredAppointmentLocally(
        userId: remoteId,
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2027, 8, 1, 11, 0),
        endTime: DateTime(2027, 8, 1, 11, 30),
        needsSync: true,
      );
      expect(await svc.getCachedAppointments(remoteId), hasLength(1));
    });
  });

  // ─── Appointment model ────────────────────────────────────────────────────
  group('Appointment model', () {
    test('dateString is non-empty', () {
      expect(testAppointment.dateString, isNotEmpty);
    });

    test('timeString is non-empty', () {
      expect(testAppointment.timeString, isNotEmpty);
    });

    test('notes defaults to null when not provided', () {
      final a = Appointment(
        id: 'x',
        name: 'Clinic',
        description: 'Service',
        datetime: DateTime.now(),
        clinicId: 'c',
        serviceId: 's',
      );
      expect(a.notes, isNull);
    });

    test('notes is preserved when provided', () {
      expect(testAppointment.notes, 'Some notes');
    });

    test('all fields are accessible', () {
      expect(testAppointment.id, testAppointmentId);
      expect(testAppointment.clinicId, testClinicId);
      expect(testAppointment.serviceId, testServiceId);
      expect(testAppointment.name, 'Test Clinic');
      expect(testAppointment.description, 'STI Screening');
    });
  });
}