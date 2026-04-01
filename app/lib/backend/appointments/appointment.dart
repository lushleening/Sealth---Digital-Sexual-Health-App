import 'package:intl/intl.dart';

class Appointment {
  final String id;
  final String name;
  final String description;
  final DateTime datetime;
  final String clinicId;
  final String serviceId;
  final String? notes;

  Appointment({
    required this.id,
    required this.name,
    required this.description,
    required this.datetime,
    required this.clinicId,
    required this.serviceId,
    this.notes,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    print('fromMap raw data: $map');
    return Appointment(
      id: map['id'].toString(),
      clinicId: map['clinic_id'].toString(),
      serviceId: map['services_id'].toString(),
      name: map['clinics']?['name'] ?? '',
      description: map['services']?['name'] ?? '',
      datetime: DateTime.parse(map['start_time']),
      notes: map['notes'] as String?,
    );
  }

  String get dateString => DateFormat('dd MMM yyyy').format(datetime);
  String get timeString => DateFormat('EEEE, h.mm a').format(datetime);

  get address => null;
}