import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';

import '../../helper/mock_objects.dart';

void main() {
  late Database db; // uses makeTestDatabase() helper

  setUp(() {
    db = makeTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  group('CachedClinics', () {
    test('inserts and reads a clinic', () async {
      await db.into(db.cachedClinics).insert(
        CachedClinicsCompanion.insert(
          id: testClinicId,
          name: 'Test Clinic',
          address: const Value('123 Test St'),
          latitude: const Value(3.1478),
          longitude: const Value(101.6836),
        ),
      );

      final clinics = await db.select(db.cachedClinics).get();
      expect(clinics.length, 1);
      expect(clinics.first.name, 'Test Clinic');
    });

    test('upserts without duplicating', () async {
      final companion = CachedClinicsCompanion.insert(
        id: testClinicId,
        name: 'Test Clinic',
      );
      await db.into(db.cachedClinics).insertOnConflictUpdate(companion);
      await db.into(db.cachedClinics).insertOnConflictUpdate(companion);

      final clinics = await db.select(db.cachedClinics).get();
      expect(clinics.length, 1);
    });
  });

  group('CachedServices', () {
    test('inserts and reads a service', () async {
      await db.into(db.cachedServices).insert(
        CachedServicesCompanion.insert(
          id: testServiceId,
          clinicId: testClinicId,
          name: 'STI Screening',
          durationMinutes: const Value(30),
        ),
      );

      final services = await db.select(db.cachedServices).get();
      expect(services.length, 1);
      expect(services.first.durationMinutes, 30);
    });

    test('filters services by clinicId', () async {
      await db.into(db.cachedServices).insert(
        CachedServicesCompanion.insert(
          id: testServiceId,
          clinicId: testClinicId,
          name: 'STI Screening',
        ),
      );
      await db.into(db.cachedServices).insert(
        CachedServicesCompanion.insert(
          id: 'other-service',
          clinicId: 'other-clinic',
          name: 'HIV Test',
        ),
      );

      final results = await (db.select(db.cachedServices)
            ..where((s) => s.clinicId.equals(testClinicId)))
          .get();

      expect(results.length, 1);
      expect(results.first.id, testServiceId);
    });
  });

  group('CachedAppointments', () {
    test('inserts and reads a guest appointment', () async {
      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: testAppointmentId,
          userId: 'guest',
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Test Clinic',
          serviceName: 'STI Screening',
          startTime: DateTime(2026, 11, 9, 10, 0),
          endTime: DateTime(2026, 11, 9, 10, 30),
        ),
      );

      final results = await (db.select(db.cachedAppointments)
            ..where((a) => a.userId.equals('guest')))
          .get();

      expect(results.length, 1);
      expect(results.first.clinicName, 'Test Clinic');
    });

    test('deletes appointment by id', () async {
      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: testAppointmentId,
          userId: 'guest',
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Test Clinic',
          serviceName: 'STI Screening',
          startTime: DateTime(2026, 11, 9, 10, 0),
          endTime: DateTime(2026, 11, 9, 10, 30),
        ),
      );

      await (db.delete(db.cachedAppointments)
            ..where((a) => a.id.equals(testAppointmentId)))
          .go();

      final results = await db.select(db.cachedAppointments).get();
      expect(results.isEmpty, true);
    });

    test('updates appointment fields', () async {
      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: testAppointmentId,
          userId: 'guest',
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Old Clinic',
          serviceName: 'Old Service',
          startTime: DateTime(2026, 11, 9, 10, 0),
          endTime: DateTime(2026, 11, 9, 10, 30),
        ),
      );

      await (db.update(db.cachedAppointments)
            ..where((a) => a.id.equals(testAppointmentId)))
          .write(const CachedAppointmentsCompanion(
        clinicName: Value('New Clinic'),
        serviceName: Value('New Service'),
      ));

      final result = await (db.select(db.cachedAppointments)
            ..where((a) => a.id.equals(testAppointmentId)))
          .getSingle();

      expect(result.clinicName, 'New Clinic');
      expect(result.serviceName, 'New Service');
    });

    test('orders appointments by startTime ascending', () async {
      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: 'appt-2',
          userId: remoteId,
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Clinic',
          serviceName: 'Service',
          startTime: DateTime(2026, 12, 1),
          endTime: DateTime(2026, 12, 1, 1),
        ),
      );
      await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: 'appt-1',
          userId: remoteId,
          clinicId: testClinicId,
          serviceId: testServiceId,
          clinicName: 'Clinic',
          serviceName: 'Service',
          startTime: DateTime(2026, 11, 1),
          endTime: DateTime(2026, 11, 1, 1),
        ),
      );

      final results = await (db.select(db.cachedAppointments)
            ..orderBy([(a) => OrderingTerm.asc(a.startTime)]))
          .get();

      expect(results.first.id, 'appt-1');
      expect(results.last.id, 'appt-2');
    });
  });

}