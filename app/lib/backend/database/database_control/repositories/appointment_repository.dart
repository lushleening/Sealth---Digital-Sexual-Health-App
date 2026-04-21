import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/appointment_syncable.dart';
import 'package:sddp_dsh/backend/database/database_control/sync/sync_tools.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/dao/appointments_dao.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';

part 'appointment_repository.g.dart';

@Riverpod(keepAlive: true)
AppointmentRepository appointmentRepository(Ref ref) {
  return AppointmentRepository(
    dao: AppointmentsDAO(ref.read(databaseProvider)),
  );
}

class AppointmentRepository {
  final AppointmentsDAO dao;
  
  AppointmentRepository({required this.dao});

  Future<List<AppointmentSyncable>> getPendingAppointments(
    String localUserId, 
    String remoteUserId,
  ) async {
    final pending = await dao.getPendingAppointments(localUserId);
    return pending.map((a) => AppointmentSyncable(
      id: a.id,
      userId: remoteUserId,
      clinicId: a.clinicId,
      serviceId: a.serviceId,
      notes: a.notes,
      startTime: a.startTime,
      endTime: a.endTime,
    )).toList();
  }
  
  Future<void> markAsSynced(String appointmentId) async {
    await dao.markAsSynced(appointmentId);
  }
}