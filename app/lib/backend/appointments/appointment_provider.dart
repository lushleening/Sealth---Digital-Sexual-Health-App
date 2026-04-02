import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/appointments/appointment_sync.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- Supabase Client ---
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return ref.watch(supabaseServiceProvider);
});

// --- Auth User ID (stream so it reacts to sign in/out) ---
final authUserIdProvider = StreamProvider<String?>((ref) {
  return ref
      .watch(supabaseServiceProvider)
      .auth
      .onAuthStateChange
      .map((data) => data.session?.user.id);
});

// --- Clinics Provider (cache-first) ---
final clinicsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final syncService = ref.read(appointmentSyncServiceProvider);

  final cached = await syncService.getCachedClinics();
  if (cached.isEmpty) {
    await syncService.syncClinics();
    return syncService.getCachedClinics();
  }

  syncService.syncClinics().catchError((_) {});
  return cached;
});

// --- Nearby Clinics Provider (always live, no cache) ---
typedef NearbyParams = ({double lat, double lng, double radiusKm});

final nearbyClinicsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, NearbyParams>((
      ref,
      params,
    ) async {
      final client = ref.read(supabaseProvider);
      final response = await client.rpc(
        'get_clinics_nearby',
        params: {
          'user_lat': params.lat,
          'user_lng': params.lng,
          'radius_km': params.radiusKm,
        },
      );
      return List<Map<String, dynamic>>.from(response as List);
    });

// --- Geocode Postcode (Nominatim) ---
Future<Map<String, double>?> geocodePostcode(String postcode) async {
  try {
    final encoded = Uri.encodeComponent(postcode);
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$encoded+Malaysia&format=json&limit=1&countrycodes=my',
    );
    final response = await http.get(
      uri,
      headers: {'User-Agent': 'sddp_dsh/1.0 (lushdab@gmail.com)'},
    );
    final data = jsonDecode(response.body) as List;
    if (data.isEmpty) return null;
    return {
      'lat': double.parse(data[0]['lat']),
      'lng': double.parse(data[0]['lon']),
    };
  } catch (_) {
    return null;
  }
}

// --- Services Provider (cache-first) ---
final servicesProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      clinicId,
    ) async {
      final syncService = ref.read(appointmentSyncServiceProvider);

      final cached = await syncService.getCachedServices(clinicId);
      if (cached.isEmpty) {
        await syncService.syncServices();
        return syncService.getCachedServices(clinicId);
      }

      syncService.syncServices().catchError((_) {});
      return cached;
    });

// --- Service By ID ---
final serviceByIdProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, serviceId) async {
    final client = ref.read(supabaseProvider);
    final response = await client
        .from('services')
        .select()
        .eq('id', serviceId)
        .single();
    return Map<String, dynamic>.from(response as Map);
  },
);

// --- Create Appointment ---
final createAppointmentProvider = Provider<CreateAppointment>(
  (ref) => CreateAppointment(ref),
);

class CreateAppointment {
  final Ref ref;
  CreateAppointment(this.ref);

  Future<Result<void>> createAppointment({
    required String userId,
    required String clinicId,
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
  }) async {
    final authUserId = ref.read(authUserIdProvider).value;
    final isGuest = authUserId == null;

    if (isGuest) {
      try {
        final syncService = ref.read(appointmentSyncServiceProvider);
        await syncService.insertGuestAppointment(
          clinicId: clinicId,
          serviceId: serviceId,
          startTime: startTime,
          endTime: endTime,
          notes: notes,
        );
        return const Result.success(null);
      } catch (e) {
        return Result.failure(e.toString());
      }
    }

    try {
      final client = ref.read(supabaseProvider);
      await client.from('appointments').insert({
        'user_id': userId,
        'clinic_id': clinicId,
        'services_id': serviceId,
        'notes': notes,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
      });
      return const Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}

// --- User Appointments Provider (cache-first, reacts to auth changes) ---
final userAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final authState = ref.watch(
    authUserIdProvider,
  ); // watches stream for auth changes
  final userId = authState.value;
  final syncService = ref.read(appointmentSyncServiceProvider);

  if (userId == null) {
    // Guest — read from Drift only
    return syncService.getCachedAppointments('guest');
  }

  // Logged in — cache-first
  final cached = await syncService.getCachedAppointments(userId);
  if (cached.isEmpty) {
    await syncService.syncAppointments();
    return syncService.getCachedAppointments(userId);
  }

  syncService.syncAppointments().catchError((_) {});
  return cached;
});

// --- Result Wrapper ---
class Result<T> {
  final T? value;
  final String? error;

  const Result.success(this.value) : error = null;
  const Result.failure(this.error) : value = null;

  void when({
    required void Function(T) success,
    required void Function(String) failure,
  }) {
    if (error != null) {
      failure(error!);
    } else {
      success(value as T);
    }
  }
}
