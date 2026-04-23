import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/appointments_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';

// ─── Helpers ──────────────────────────────────────────────────────────────────

Database _makeDb() => Database(NativeDatabase.memory());

/// Inserts a [CachedAppointmentsCompanion] into [db] and returns the inserted row.
Future<CachedAppointment> _insertAppointment(
  Database db, {
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
}) async {
  final now = DateTime.now();
  await db.into(db.cachedAppointments).insert(
        CachedAppointmentsCompanion.insert(
          id: id,
          userId: userId,
          clinicId: clinicId,
          serviceId: serviceId,
          clinicName: clinicName,
          serviceName: serviceName,
          needsSync: Value(needsSync),
          notes: Value(notes),
          startTime: startTime ?? now,
          endTime: endTime ?? now.add(const Duration(minutes: 30)),
        ),
      );

  return (db.select(db.cachedAppointments)
        ..where((a) => a.id.equals(id)))
      .getSingle();
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late Database db;
  late AppointmentsDAO dao;

  setUp(() {
    db = _makeDb();
    dao = AppointmentsDAO(db);
  });

  tearDown(() => db.close());

  // ── getPendingAppointments ──────────────────────────────────────────────────

  group('getPendingAppointments', () {
    test('returns empty list when no appointments exist', () async {
      final result = await dao.getPendingAppointments('user-1');

      expect(result, isEmpty);
    });

    test('returns only appointments for the given userId that need sync',
        () async {
      await _insertAppointment(
        db,
        id: 'appt-1',
        userId: 'user-1',
        clinicId: 'clinic-1',
        serviceId: 'service-1',
        needsSync: true,
      );

      // Different user — should NOT appear
      await _insertAppointment(
        db,
        id: 'appt-2',
        userId: 'user-2',
        clinicId: 'clinic-1',
        serviceId: 'service-1',
        needsSync: true,
      );

      // Same user but already synced — should NOT appear
      await _insertAppointment(
        db,
        id: 'appt-3',
        userId: 'user-1',
        clinicId: 'clinic-1',
        serviceId: 'service-1',
        needsSync: false,
      );

      final result = await dao.getPendingAppointments('user-1');

      expect(result.length, 1);
      expect(result.first.id, 'appt-1');
    });

    test('returns multiple pending appointments for the same user', () async {
      await _insertAppointment(
        db,
        id: 'appt-1',
        userId: 'user-1',
        clinicId: 'clinic-1',
        serviceId: 'service-1',
        needsSync: true,
      );
      await _insertAppointment(
        db,
        id: 'appt-2',
        userId: 'user-1',
        clinicId: 'clinic-2',
        serviceId: 'service-2',
        needsSync: true,
      );

      final result = await dao.getPendingAppointments('user-1');

      expect(result.length, 2);
      expect(result.map((a) => a.id), containsAll(['appt-1', 'appt-2']));
    });

    test('returns empty list when userId does not match any record', () async {
      await _insertAppointment(
        db,
        id: 'appt-1',
        userId: 'user-1',
        clinicId: 'clinic-1',
        serviceId: 'service-1',
      );

      final result = await dao.getPendingAppointments('user-999');

      expect(result, isEmpty);
    });
  });

  // ── markAsSynced ───────────────────────────────────────────────────────────

  group('markAsSynced', () {
    test('sets needsSync to false for the given appointmentId', () async {
      await _insertAppointment(
        db,
        id: 'appt-1',
        userId: 'user-1',
        clinicId: 'clinic-1',
        serviceId: 'service-1',
        needsSync: true,
      );

      await dao.markAsSynced('appt-1');

      final updated = await (db.select(db.cachedAppointments)
            ..where((a) => a.id.equals('appt-1')))
          .getSingle();

      expect(updated.needsSync, isFalse);
    });

    test('updates lastSynced to approximately now', () async {
      await _insertAppointment(
        db,
        id: 'appt-1',
        userId: 'user-1',
        clinicId: 'clinic-1',
        serviceId: 'service-1',
        needsSync: true,
      );

      final before = DateTime.now();
      await dao.markAsSynced('appt-1');
      final after = DateTime.now();

      final updated = await (db.select(db.cachedAppointments)
            ..where((a) => a.id.equals('appt-1')))
          .getSingle();

      expect(
        updated.lastSynced.isAfter(before.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(
        updated.lastSynced.isBefore(after.add(const Duration(seconds: 1))),
        isTrue,
      );
    });

    test('does not affect other appointments', () async {
      await _insertAppointment(
        db,
        id: 'appt-1',
        userId: 'user-1',
        clinicId: 'clinic-1',
        serviceId: 'service-1',
        needsSync: true,
      );
      await _insertAppointment(
        db,
        id: 'appt-2',
        userId: 'user-1',
        clinicId: 'clinic-1',
        serviceId: 'service-1',
        needsSync: true,
      );

      await dao.markAsSynced('appt-1');

      final untouched = await (db.select(db.cachedAppointments)
            ..where((a) => a.id.equals('appt-2')))
          .getSingle();

      expect(untouched.needsSync, isTrue);
    });

    test('is a no-op when appointmentId does not exist', () async {
      // Should complete without throwing
      await expectLater(dao.markAsSynced('non-existent-id'), completes);
    });
  });
}