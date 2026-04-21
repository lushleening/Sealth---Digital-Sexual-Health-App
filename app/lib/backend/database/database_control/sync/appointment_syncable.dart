import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';

class AppointmentSyncable implements Syncable {
  final String id;
  final String userId;
  final String clinicId;
  final String serviceId;
  final String? notes;
  final DateTime startTime;
  final DateTime endTime;

  AppointmentSyncable({
    required this.id,
    required this.userId,
    required this.clinicId,
    required this.serviceId,
    this.notes,
    required this.startTime,
    required this.endTime,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'clinic_id': clinicId,
      'services_id': serviceId,
      'notes': notes,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
    };
  }
}