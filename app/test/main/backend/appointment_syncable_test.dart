import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/appointment_syncable.dart';

void main() {
  group('AppointmentSyncable', () {
    final testId = 'test-id-123';
    final testUserId = 'user-123';
    final testClinicId = 'clinic-123';
    final testServiceId = 'service-123';
    final testStartTime = DateTime(2025, 1, 15, 10, 0);
    final testEndTime = DateTime(2025, 1, 15, 10, 30);
    final testNotes = 'Test appointment notes';

    test('creates AppointmentSyncable with all required fields', () {
      final syncable = AppointmentSyncable(
        id: testId,
        userId: testUserId,
        clinicId: testClinicId,
        serviceId: testServiceId,
        notes: testNotes,
        startTime: testStartTime,
        endTime: testEndTime,
      );

      expect(syncable.id, testId);
      expect(syncable.userId, testUserId);
      expect(syncable.clinicId, testClinicId);
      expect(syncable.serviceId, testServiceId);
      expect(syncable.notes, testNotes);
      expect(syncable.startTime, testStartTime);
      expect(syncable.endTime, testEndTime);
    });

    test('creates AppointmentSyncable with null notes', () {
      final syncable = AppointmentSyncable(
        id: testId,
        userId: testUserId,
        clinicId: testClinicId,
        serviceId: testServiceId,
        notes: null,
        startTime: testStartTime,
        endTime: testEndTime,
      );

      expect(syncable.notes, isNull);
    });

    test('toJson returns correct JSON structure', () {
      final syncable = AppointmentSyncable(
        id: testId,
        userId: testUserId,
        clinicId: testClinicId,
        serviceId: testServiceId,
        notes: testNotes,
        startTime: testStartTime,
        endTime: testEndTime,
      );

      final json = syncable.toJson();

      expect(json, {
        'id': testId,
        'user_id': testUserId,
        'clinic_id': testClinicId,
        'services_id': testServiceId,
        'notes': testNotes,
        'start_time': testStartTime.toIso8601String(),
        'end_time': testEndTime.toIso8601String(),
      });
    });

    test('toJson handles null notes correctly', () {
      final syncable = AppointmentSyncable(
        id: testId,
        userId: testUserId,
        clinicId: testClinicId,
        serviceId: testServiceId,
        notes: null,
        startTime: testStartTime,
        endTime: testEndTime,
      );

      final json = syncable.toJson();

      expect(json['notes'], null);
      expect(json['id'], testId);
      expect(json['user_id'], testUserId);
    });

    test('toJson converts dates to ISO8601 strings', () {
      final syncable = AppointmentSyncable(
        id: testId,
        userId: testUserId,
        clinicId: testClinicId,
        serviceId: testServiceId,
        notes: null,
        startTime: testStartTime,
        endTime: testEndTime,
      );

      final json = syncable.toJson();
      
      expect(json['start_time'], testStartTime.toIso8601String());
      expect(json['end_time'], testEndTime.toIso8601String());
    });

    test('multiple instances have independent data', () {
      final syncable1 = AppointmentSyncable(
        id: 'id-1',
        userId: 'user-1',
        clinicId: 'clinic-1',
        serviceId: 'service-1',
        notes: null,
        startTime: testStartTime,
        endTime: testEndTime,
      );

      final syncable2 = AppointmentSyncable(
        id: 'id-2',
        userId: 'user-2',
        clinicId: 'clinic-2',
        serviceId: 'service-2',
        notes: 'Different notes',
        startTime: testStartTime.add(const Duration(days: 1)),
        endTime: testEndTime.add(const Duration(days: 1)),
      );

      expect(syncable1.id, 'id-1');
      expect(syncable2.id, 'id-2');
      expect(syncable1.userId, 'user-1');
      expect(syncable2.userId, 'user-2');
      expect(syncable1.toJson()['id'], 'id-1');
      expect(syncable2.toJson()['id'], 'id-2');
    });
  });
}