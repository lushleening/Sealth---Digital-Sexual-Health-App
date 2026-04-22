import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/appointments/appointment_sync.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';

import '../../helper/mock_objects.dart';

void main() {
  late Database db;
  late AppointmentSyncService syncService;

  setUp(() {
    db = makeTestDatabase();
    // Create sync service with mock Supabase client (we focus on local logic)
    syncService = AppointmentSyncService(
      db: db,
      client: MockSupabaseClient(),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('insertGuestAppointment - conflict detection', () {
    test('inserts appointment when no conflict exists', () async {
      // Insert clinic and service for reference
      await db.into(db.cachedClinics).insert(
        CachedClinicsCompanion.insert(
          id: testClinicId,
          name: 'Test Clinic',
        ),
      );

      await db.into(db.cachedServices).insert(
        CachedServicesCompanion.insert(
          id: testServiceId,
          clinicId: testClinicId,
          name: 'Service',
        ),
      );

      await syncService.insertGuestAppointment(
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2026, 11, 9, 10, 0),
        endTime: DateTime(2026, 11, 9, 10, 30),
      );

      final cached = await db.select(db.cachedAppointments).get();
      expect(cached.length, 1);
      expect(cached.first.userId, 'guest');
    });

    test('detects overlapping appointments at same clinic', () async {
      // Insert existing appointment
      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: 'existing-appt',
          userId: 'guest',
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Test Clinic',
          serviceName: 'Service',
          startTime: DateTime(2026, 11, 9, 10, 0),
          endTime: DateTime(2026, 11, 9, 10, 30),
        ),
      );

      // Try to insert overlapping appointment
      expect(
        () => syncService.insertGuestAppointment(
          clinicId: testClinicId,
          serviceId: testServiceId,
          startTime: DateTime(2026, 11, 9, 10, 15),
          endTime: DateTime(2026, 11, 9, 10, 45),
        ),
        throwsException,
      );
    });

    test('detects appointments at exact same time', () async {
      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: 'existing-appt',
          userId: 'guest',
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Clinic',
          serviceName: 'Service',
          startTime: DateTime(2026, 11, 9, 10, 0),
          endTime: DateTime(2026, 11, 9, 10, 30),
        ),
      );

      expect(
        () => syncService.insertGuestAppointment(
          clinicId: testClinicId,
          serviceId: testServiceId,
          startTime: DateTime(2026, 11, 9, 10, 0),
          endTime: DateTime(2026, 11, 9, 10, 30),
        ),
        throwsException,
      );
    });

    test('allows different time slots at same clinic', () async {
      await db.into(db.cachedClinics).insert(
        CachedClinicsCompanion.insert(
          id: testClinicId,
          name: 'Clinic',
        ),
      );

      await db.into(db.cachedServices).insert(
        CachedServicesCompanion.insert(
          id: testServiceId,
          clinicId: testClinicId,
          name: 'Service',
        ),
      );

      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: 'appt-1',
          userId: 'guest',
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Clinic',
          serviceName: 'Service',
          startTime: DateTime(2026, 11, 9, 10, 0),
          endTime: DateTime(2026, 11, 9, 10, 30),
        ),
      );

      // Different time slot should succeed
      await syncService.insertGuestAppointment(
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2026, 11, 9, 11, 0),
        endTime: DateTime(2026, 11, 9, 11, 30),
      );

      final cached = await db.select(db.cachedAppointments).get();
      expect(cached.length, 2);
    });
  });

  group('insertRegisteredAppointmentLocally', () {
    test('inserts appointment with sync flag', () async {
      await db.into(db.cachedClinics).insert(
        CachedClinicsCompanion.insert(
          id: testClinicId,
          name: 'Clinic',
        ),
      );

      await db.into(db.cachedServices).insert(
        CachedServicesCompanion.insert(
          id: testServiceId,
          clinicId: testClinicId,
          name: 'Service',
        ),
      );

      await syncService.insertRegisteredAppointmentLocally(
        id: testAppointmentId,
        userId: remoteId,
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2026, 11, 9, 10, 0),
        endTime: DateTime(2026, 11, 9, 10, 30),
        needsSync: false,
      );

      final cached = await db.select(db.cachedAppointments).get();
      expect(cached.length, 1);
      expect(cached.first.userId, remoteId);
      expect(cached.first.needsSync, false);
    });

    test('flags appointment for sync when online insert fails', () async {
      await db.into(db.cachedClinics).insert(
        CachedClinicsCompanion.insert(
          id: testClinicId,
          name: 'Clinic',
        ),
      );

      await db.into(db.cachedServices).insert(
        CachedServicesCompanion.insert(
          id: testServiceId,
          clinicId: testClinicId,
          name: 'Service',
        ),
      );

      await syncService.insertRegisteredAppointmentLocally(
        id: testAppointmentId,
        userId: remoteId,
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2026, 11, 9, 10, 0),
        endTime: DateTime(2026, 11, 9, 10, 30),
        needsSync: true,
      );

      final cached = await db.select(db.cachedAppointments).get();
      expect(cached.first.needsSync, true);
    });

    test('generates local ID if not provided', () async {
      await db.into(db.cachedClinics).insert(
        CachedClinicsCompanion.insert(
          id: testClinicId,
          name: 'Clinic',
        ),
      );

      await db.into(db.cachedServices).insert(
        CachedServicesCompanion.insert(
          id: testServiceId,
          clinicId: testClinicId,
          name: 'Service',
        ),
      );

      await syncService.insertRegisteredAppointmentLocally(
        userId: remoteId,
        clinicId: testClinicId,
        serviceId: testServiceId,
        startTime: DateTime(2026, 11, 9, 10, 0),
        endTime: DateTime(2026, 11, 9, 10, 30),
      );

      final cached = await db.select(db.cachedAppointments).get();
      expect(cached.length, 1);
      expect(cached.first.id, isNotEmpty);
    });
  });

  group('checkForConflict', () {
    test('detects conflict when appointment overlaps', () async {
      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: 'existing',
          userId: remoteId,
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Clinic',
          serviceName: 'Service',
          startTime: DateTime(2026, 11, 9, 10, 0),
          endTime: DateTime(2026, 11, 9, 10, 30),
        ),
      );

      final hasConflict = await syncService.checkForConflict(
        clinicId: testClinicId,
        startTime: DateTime(2026, 11, 9, 10, 15),
        endTime: DateTime(2026, 11, 9, 10, 45),
      );

      expect(hasConflict, true);
    });

    test('no conflict when times do not overlap', () async {
      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: 'existing',
          userId: remoteId,
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Clinic',
          serviceName: 'Service',
          startTime: DateTime(2026, 11, 9, 10, 0),
          endTime: DateTime(2026, 11, 9, 10, 30),
        ),
      );

      final hasConflict = await syncService.checkForConflict(
        clinicId: testClinicId,
        startTime: DateTime(2026, 11, 9, 11, 0),
        endTime: DateTime(2026, 11, 9, 11, 30),
      );

      expect(hasConflict, false);
    });

    test('excludes appointment when provided', () async {
      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: 'same-appt',
          userId: remoteId,
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Clinic',
          serviceName: 'Service',
          startTime: DateTime(2026, 11, 9, 10, 0),
          endTime: DateTime(2026, 11, 9, 10, 30),
        ),
      );

      final hasConflict = await syncService.checkForConflict(
        clinicId: testClinicId,
        startTime: DateTime(2026, 11, 9, 10, 0),
        endTime: DateTime(2026, 11, 9, 10, 30),
        excludeAppointmentId: 'same-appt',
      );

      expect(hasConflict, false);
    });
  });

  group('deleteGuestAppointments', () {
    test('deletes all guest appointments', () async {
      // Insert guest appointments
      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: 'guest-appt-1',
          userId: 'guest',
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Clinic',
          serviceName: 'Service',
          startTime: DateTime(2026, 11, 9, 10, 0),
          endTime: DateTime(2026, 11, 9, 10, 30),
        ),
      );

      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: 'guest-appt-2',
          userId: 'guest',
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Clinic',
          serviceName: 'Service',
          startTime: DateTime(2026, 11, 10, 10, 0),
          endTime: DateTime(2026, 11, 10, 10, 30),
        ),
      );

      // Insert registered appointment (should not be deleted)
      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: 'registered-appt',
          userId: remoteId,
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Clinic',
          serviceName: 'Service',
          startTime: DateTime(2026, 11, 11, 10, 0),
          endTime: DateTime(2026, 11, 11, 10, 30),
        ),
      );

      await syncService.deleteGuestAppointments();

      final remaining = await db.select(db.cachedAppointments).get();
      expect(remaining.length, 1);
      expect(remaining.first.userId, remoteId);
    });

    test('handles empty database gracefully', () async {
      expect(
        () => syncService.deleteGuestAppointments(),
        returnsNormally,
      );

      final appointments = await db.select(db.cachedAppointments).get();
      expect(appointments.isEmpty, true);
    });
  });

  group('getCached methods', () {
    test('getCachedClinics returns formatted map', () async {
      await db.into(db.cachedClinics).insert(
        CachedClinicsCompanion.insert(
          id: testClinicId,
          name: 'Test Clinic',
          address: const Value('123 St'),
          latitude: const Value(3.1478),
          longitude: const Value(101.6836),
        ),
      );

      final clinics = await syncService.getCachedClinics();

      expect(clinics.length, 1);
      expect(clinics.first['id'], testClinicId);
      expect(clinics.first['name'], 'Test Clinic');
      expect(clinics.first['address'], '123 St');
    });

    test('getCachedServices filters by clinicId', () async {
      await db.into(db.cachedServices).insert(
        CachedServicesCompanion.insert(
          id: testServiceId,
          clinicId: testClinicId,
          name: 'Service A',
        ),
      );

      await db.into(db.cachedServices).insert(
        CachedServicesCompanion.insert(
          id: 'service-other',
          clinicId: 'clinic-other',
          name: 'Service B',
        ),
      );

      final services = await syncService.getCachedServices(testClinicId);

      expect(services.length, 1);
      expect(services.first['id'], testServiceId);
    });

    test('getCachedAppointments returns Appointment objects', () async {
      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: testAppointmentId,
          userId: remoteId,
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Clinic',
          serviceName: 'Service',
          startTime: DateTime(2026, 11, 9, 10, 0),
          endTime: DateTime(2026, 11, 9, 10, 30),
        ),
      );

      final appointments = await syncService.getCachedAppointments(remoteId);

      expect(appointments.length, 1);
      expect(appointments.first.id, testAppointmentId);
      expect(appointments.first.name, 'Clinic');
      expect(appointments.first.description, 'Service');
    });

    test('getCachedAppointments returns empty list for unknown user',
        () async {
      final appointments = await syncService.getCachedAppointments('unknown');

      expect(appointments.isEmpty, true);
    });
  });
}

