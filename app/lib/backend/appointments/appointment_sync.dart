import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
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

  // Sync clinics (paginated — handles more than 1000 rows)
  Future<void> syncClinics() async {
    const pageSize = 1000;
    int offset = 0;
    final allRows = <Map<String, dynamic>>[];

    while (true) {
      final response = await client
          .from('clinics')
          .select()
          .range(offset, offset + pageSize - 1);

      final rows = List<Map<String, dynamic>>.from(response as List);
      allRows.addAll(rows);

      if (rows.length < pageSize) break;
      offset += pageSize;
    }

    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.cachedClinics,
        allRows
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

  // Sync services (paginated — future-proofed)
  Future<void> syncServices() async {
    const pageSize = 1000;
    int offset = 0;
    final allRows = <Map<String, dynamic>>[];

    while (true) {
      final response = await client
          .from('services')
          .select()
          .range(offset, offset + pageSize - 1);

      final rows = List<Map<String, dynamic>>.from(response as List);
      allRows.addAll(rows);

      if (rows.length < pageSize) break;
      offset += pageSize;
    }

    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.cachedServices,
        allRows
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

  // Fetch clinic name: local cache first, fallback to Supabase
  Future<String> _getClinicName(String clinicId) async {
    final cached = await (db.select(db.cachedClinics)
          ..where((c) => c.id.equals(clinicId)))
        .getSingleOrNull();
    if (cached != null) return cached.name;

    try {
      final response = await client
          .from('clinics')
          .select('name')
          .eq('id', clinicId)
          .single();
      return response['name']?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  // Fetch service name: local cache first, fallback to Supabase
  Future<String> _getServiceName(String serviceId) async {
    final cached = await (db.select(db.cachedServices)
          ..where((s) => s.id.equals(serviceId)))
        .getSingleOrNull();
    if (cached != null) return cached.name;

    try {
      final response = await client
          .from('services')
          .select('name')
          .eq('id', serviceId)
          .single();
      return response['name']?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  // Insert guest appointment into Drift only
  Future<void> insertGuestAppointment({
    required String clinicId,
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
  }) async {
    // Check clinic-wide conflicts — no userId filter
    final existing = await (db.select(db.cachedAppointments)
          ..where((a) =>
              a.clinicId.equals(clinicId) &
              a.startTime.isSmallerThanValue(endTime) &
              a.endTime.isBiggerThanValue(startTime)))
          .get();

    if (existing.isNotEmpty) {
      throw Exception(
        'This time slot is already booked at this clinic '
        '(${_formatTime(startTime)} – ${_formatTime(endTime)}).',
      );
    }

    // Fetch names with Supabase fallback so cards always show correctly
    final clinicName = await _getClinicName(clinicId);
    final serviceName = await _getServiceName(serviceId);

    await db.into(db.cachedAppointments).insert(
      CachedAppointmentsCompanion.insert(
        id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'guest',
        clinicId: clinicId,
        serviceId: serviceId,
        clinicName: clinicName,
        serviceName: serviceName,
        startTime: startTime,
        endTime: endTime,
        notes: Value(notes),
        lastSynced: Value(DateTime.now()),
      ),
    );
  }

  // Local-first insert for registered users
  Future<void> insertRegisteredAppointmentLocally({
    String? id,
    required String userId,
    required String clinicId,
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
    bool needsSync = false,
  }) async {
    // check conflicts
    final existing = await (db.select(db.cachedAppointments)
          ..where((a) =>
              a.clinicId.equals(clinicId) &
              a.startTime.isSmallerThanValue(endTime) &
              a.endTime.isBiggerThanValue(startTime)))
          .get();

    if (existing.isNotEmpty) {
      throw Exception(
        'This time slot is already booked at this clinic '
        '(${_formatTime(startTime)} – ${_formatTime(endTime)}).',
      );
    }

    // Fetch names with Supabase fallback so cards always show correctly
    final clinicName = await _getClinicName(clinicId);
    final serviceName = await _getServiceName(serviceId);

    await db.into(db.cachedAppointments).insert(
      CachedAppointmentsCompanion.insert(
        id: id ?? 'local_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        clinicId: clinicId,
        serviceId: serviceId,
        clinicName: clinicName,
        serviceName: serviceName,
        startTime: startTime,
        endTime: endTime,
        notes: Value(notes),
        lastSynced: Value(DateTime.now()),
        needsSync: Value(needsSync),
      ),
    );
  }

  Future<void> deleteGuestAppointments() async {
    await (db.delete(db.cachedAppointments)
          ..where((a) => a.userId.equals('guest')))
        .go();
    appointmentLogger.info('Deleted all guest appointments');
  }

  // Clinic-wide conflict check
  Future<bool> checkForConflict({
    required String clinicId,
    required DateTime startTime,
    required DateTime endTime,
    String? excludeAppointmentId,
  }) async {
    final existing = await (db.select(db.cachedAppointments)
          ..where((a) =>
              a.clinicId.equals(clinicId) &
              a.startTime.isSmallerThanValue(endTime) &
              a.endTime.isBiggerThanValue(startTime)))
          .get();
    if (excludeAppointmentId != null) {
      return existing.any((a) => a.id != excludeAppointmentId);
    }
    return existing.isNotEmpty;
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}