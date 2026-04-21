import 'package:drift/drift.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/schema.dart';

part 'appointments_dao.g.dart';

@DriftAccessor(tables: [CachedAppointments])
class AppointmentsDAO extends DatabaseAccessor<Database> with _$AppointmentsDAOMixin {
  AppointmentsDAO(super.attachedDatabase);

  Future<List<CachedAppointment>> getPendingAppointments(String localUserId) async {
    return await (select(cachedAppointments)
          ..where((a) => a.userId.equals(localUserId))
          ..where((a) => a.needsSync.equals(true)))
        .get();
  }

  Future<void> markAsSynced(String appointmentId) async {
    await (update(cachedAppointments)
          ..where((a) => a.id.equals(appointmentId)))
        .write(CachedAppointmentsCompanion(
          needsSync: const Value(false),
          lastSynced: Value(DateTime.now()),
        ));
  }
}
