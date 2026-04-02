import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';

final appointmentSyncServiceProvider = Provider<AppointmentSyncService>((ref) {
  final db = ref.read(databaseProvider);
  final client = ref.read(supabaseServiceProvider);
  return AppointmentSyncService(db: db, client: client);
});

class AppointmentSyncService {
  final Database db;
  final SupabaseClient client;
  AppointmentSyncService({required this.db, required this.client});

  // Sync clinics
  Future<void> syncClinics() async {
    final response = await client.from('clinics').select();
    final rows = List<Map<String, dynamic>>.from(response as List);
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.cachedClinics,
        rows
            .map(
              (r) => CachedClinicsCompanion.insert(
                id: r['id'].toString(),
                name: r['name']?.toString() ?? '',
                address: Value(r['address']?.toString()),
                latitude: Value(r['latitude'] as double?),
                longitude: Value(r['longitude'] as double?),
                lastSynced: Value(DateTime.now()),
              ),
            )
            .toList(),
      );
    });
  }

  // Sync services
  Future<void> syncServices() async {
    final response = await client.from('services').select();
    final rows = List<Map<String, dynamic>>.from(response as List);
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.cachedServices,
        rows
            .map(
              (r) => CachedServicesCompanion.insert(
                id: r['id'].toString(),
                clinicId: r['clinic_id'].toString(),
                name: r['name']?.toString() ?? '',
                durationMinutes: Value(r['duration_minutes'] as int? ?? 30),
                lastSynced: Value(DateTime.now()),
              ),
            )
            .toList(),
      );
    });
  }

  // Sync appointments
  Future<void> syncAppointments() async {
    final user = client.auth.currentUser;
    if (user == null) return;
    final response = await client
        .from('appointments')
        .select('*, clinics(name), services(name)')
        .eq('user_id', user.id)
        .order('start_time', ascending: true);
    final rows = List<Map<String, dynamic>>.from(response as List);
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.cachedAppointments,
        rows
            .map(
              (r) => CachedAppointmentsCompanion.insert(
                id: r['id'].toString(),
                userId: r['user_id'].toString(),
                clinicId: r['clinic_id'].toString(),
                serviceId: r['services_id'].toString(),
                clinicName: r['clinics']?['name']?.toString() ?? '',
                serviceName: r['services']?['name']?.toString() ?? '',
                startTime: DateTime.parse(r['start_time']),
                endTime: DateTime.parse(r['end_time']),
                notes: Value(r['notes'] as String?),
                lastSynced: Value(DateTime.now()),
              ),
            )
            .toList(),
      );
    });
  }

  // Read appointments from Drift
  Future<List<Appointment>> getCachedAppointments(String userId) async {
    final rows =
        await (db.select(db.cachedAppointments)
              ..where((a) => a.userId.equals(userId))
              ..orderBy([(a) => OrderingTerm.asc(a.startTime)]))
            .get();
    return rows
        .map(
          (r) => Appointment(
            id: r.id,
            name: r.clinicName,
            description: r.serviceName,
            datetime: r.startTime,
            clinicId: r.clinicId,
            serviceId: r.serviceId,
            notes: r.notes,
          ),
        )
        .toList();
  }

  // Read clinics from Drift
  Future<List<Map<String, dynamic>>> getCachedClinics() async {
    final rows = await db.select(db.cachedClinics).get();
    return rows
        .map(
          (r) => {
            'id': r.id,
            'name': r.name,
            'address': r.address,
            'latitude': r.latitude,
            'longitude': r.longitude,
          },
        )
        .toList();
  }

  // Read services from Drift
  Future<List<Map<String, dynamic>>> getCachedServices(String clinicId) async {
    final rows = await (db.select(
      db.cachedServices,
    )..where((s) => s.clinicId.equals(clinicId))).get();
    return rows
        .map(
          (r) => {
            'id': r.id,
            'clinic_id': r.clinicId,
            'name': r.name,
            'duration_minutes': r.durationMinutes,
          },
        )
        .toList();
  }

  // Call this once on app startup via ref
  Future<void> initialSync(Ref ref) async {
    final syncService = ref.read(appointmentSyncServiceProvider);
    syncService.syncClinics().catchError((_) {});
    syncService.syncServices().catchError((_) {});
  }

  // Insert guest appointment into Drift only
  Future<void> insertGuestAppointment({
    required String clinicId,
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
  }) async {
    final clinic = await (db.select(
      db.cachedClinics,
    )..where((c) => c.id.equals(clinicId))).getSingleOrNull();
    final service = await (db.select(
      db.cachedServices,
    )..where((s) => s.id.equals(serviceId))).getSingleOrNull();

    await db
        .into(db.cachedAppointments)
        .insert(
          CachedAppointmentsCompanion.insert(
            id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
            userId: 'guest',
            clinicId: clinicId,
            serviceId: serviceId,
            clinicName: clinic?.name ?? '',
            serviceName: service?.name ?? '',
            startTime: startTime,
            endTime: endTime,
            notes: Value(notes),
            lastSynced: Value(DateTime.now()),
          ),
        );
  }
}
