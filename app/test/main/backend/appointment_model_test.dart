import 'package:flutter_test/flutter_test.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';

import '../../helper/mock_objects.dart';

void main() {
  group('Appointment.fromMap', () {
    test('parses all fields correctly', () {
      final appointment = Appointment.fromMap(testAppointmentMap);

      expect(appointment.id, testAppointmentId);
      expect(appointment.name, 'Test Clinic');
      expect(appointment.description, 'STI Screening');
      expect(appointment.clinicId, testClinicId);
      expect(appointment.serviceId, testServiceId);
      expect(appointment.notes, 'Some notes');
      expect(appointment.datetime, DateTime.parse('2026-11-09T10:00:00.000'));
    });

    test('handles null clinic and service names gracefully', () {
      final map = {
        ...testAppointmentMap,
        'clinics': null,
        'services': null,
        'notes': null,
      };

      final appointment = Appointment.fromMap(map);

      expect(appointment.name, '');
      expect(appointment.description, '');
      expect(appointment.notes, null);
    });

    


    test('dateString formats correctly', () {
      expect(testAppointment.dateString, '09 Nov 2026');
    });

    test('timeString formats correctly', () {
      expect(testAppointment.timeString, 'Monday, 10.00 AM');
    });

    

  });

  group('Result wrapper', () {
    test('Result.success holds value and no error', () {
      const result = Result.success('hello');
      expect(result.value, 'hello');
      expect(result.error, null);
    });

    test('Result.failure holds error and no value', () {
      const result = Result<String>.failure('something went wrong');
      expect(result.error, 'something went wrong');
      expect(result.value, null);
    });

    test('Result.when calls success callback', () {
      const result = Result.success(42);
      int? received;
      result.when(
        success: (v) => received = v,
        failure: (_) => fail('should not call failure'),
      );
      expect(received, 42);
    });

    test('Result.when calls failure callback', () {
      const result = Result<int>.failure('oops');
      String? receivedError;
      result.when(
        success: (_) => fail('should not call success'),
        failure: (e) => receivedError = e,
      );
      expect(receivedError, 'oops');
    });
  });

  test('handles missing address gracefully', () {
  final map = {
    ...testAppointmentMap,
    'clinics': {'name': 'Test Clinic'}, // no address key
  };
  final appointment = Appointment.fromMap(map);
  expect(appointment.address, null);
});

}