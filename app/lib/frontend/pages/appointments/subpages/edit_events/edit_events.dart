import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/database/sqlite_drift/database.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/edit_events/widgets/edit_event_card.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/edit_events/widgets/save_but.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/edit_events/widgets/del_but.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/edit_events/widgets/cancel_but.dart';
import 'package:drift/drift.dart' show Value;
import 'package:supabase_flutter/supabase_flutter.dart';

class EditEvents extends ConsumerStatefulWidget {
  final Appointment appointment;
  const EditEvents({super.key, required this.appointment});

  @override
  ConsumerState<EditEvents> createState() => _EditEventState();
}

class _EditEventState extends ConsumerState<EditEvents> {
  bool _isSaving = false;

  String? _clinicId;
  String? _serviceId;
  DateTime? _selectedDateTime;
  String? _notes;

  bool get _isGuest => Supabase.instance.client.auth.currentUser == null;

  @override
  void initState() {
    super.initState();
    _clinicId = widget.appointment.clinicId;
    _serviceId = widget.appointment.serviceId;
    _selectedDateTime = widget.appointment.datetime;
    _notes = widget.appointment.notes;
  }

  Future<void> _save() async {
    if (_clinicId == null || _serviceId == null || _selectedDateTime == null) {
      showSnackbarMessage('Please fill in all required fields');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final durationMinutes = await _getServiceDuration(_serviceId!);
      final startTime = _selectedDateTime!;
      final endTime = startTime.add(Duration(minutes: durationMinutes));

      if (_isGuest) {
        // Guest → update Drift only
        final db = ref.read(databaseProvider);

        // Resolve names from cache
        final clinic = await (db.select(
          db.cachedClinics,
        )..where((c) => c.id.equals(_clinicId!))).getSingleOrNull();
        final service = await (db.select(
          db.cachedServices,
        )..where((s) => s.id.equals(_serviceId!))).getSingleOrNull();

        await (db.update(
          db.cachedAppointments,
        )..where((a) => a.id.equals(widget.appointment.id))).write(
          CachedAppointmentsCompanion(
            clinicId: Value(_clinicId!),
            serviceId: Value(_serviceId!),
            clinicName: Value(clinic?.name ?? ''),
            serviceName: Value(service?.name ?? ''),
            startTime: Value(startTime),
            endTime: Value(endTime),
            notes: Value(_notes),
            lastSynced: Value(DateTime.now()),
          ),
        );
      } else {
        // Logged in → update Supabase
        final client = ref.read(supabaseProvider);
        await client
            .from('appointments')
            .update({
              'clinic_id': _clinicId,
              'services_id': _serviceId,
              'start_time': startTime.toIso8601String(),
              'end_time': endTime.toIso8601String(),
              'notes': _notes,
            })
            .eq('id', widget.appointment.id);
      }

      ref.invalidate(userAppointmentsProvider);
      if (mounted) {
        showSnackbarMessage('Appointment updated successfully!');
        Navigator.pop(context);
      }
    } catch (e) {
      showSnackbarMessage('Failed to update: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _delete() async {
    final c = context.colors;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: c.whiteBackground,
        title: const Text('Delete Appointment'),
        content: const Text(
          'Are you sure you want to delete this appointment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: c.mainColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: c.alert)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      if (_isGuest) {
        // Guest → delete from Drift only
        final db = ref.read(databaseProvider);
        await (db.delete(
          db.cachedAppointments,
        )..where((a) => a.id.equals(widget.appointment.id))).go();
      } else {
        // Logged in → delete from Supabase
        final client = ref.read(supabaseProvider);
        await client
            .from('appointments')
            .delete()
            .eq('id', widget.appointment.id);
      }

      ref.invalidate(userAppointmentsProvider);
      if (mounted) {
        showSnackbarMessage('Appointment deleted');
        Navigator.pop(context);
      }
    } catch (e) {
      showSnackbarMessage('Delete failed: $e');
    }
  }

  Future<int> _getServiceDuration(String serviceId) async {
    try {
      if (_isGuest) {
        // Guest → read duration from local Drift cache
        final db = ref.read(databaseProvider);
        final service = await (db.select(
          db.cachedServices,
        )..where((s) => s.id.equals(serviceId))).getSingleOrNull();
        return service?.durationMinutes ?? 30;
      }
      final service = await ref.read(serviceByIdProvider(serviceId).future);
      return service['duration_minutes'] as int? ?? 30;
    } catch (_) {
      return 30;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.grayBackground,
      appBar: AppBar(
        title: const Text("Edit Appointment"),
        backgroundColor: c.mainColor,
        foregroundColor: c.textWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            EditEventsPage(
              appointment: widget.appointment,
              onChanged:
                  ({
                    required String clinicId,
                    required String serviceId,
                    required DateTime dateTime,
                    String? notes,
                  }) {
                    _clinicId = clinicId;
                    _serviceId = serviceId;
                    _selectedDateTime = dateTime;
                    _notes = notes;
                  },
            ),
            const SizedBox(height: 32),
            if (_isSaving)
              const LoadingCircleMainColor()
            else ...[
              SaveButton(key: KBtn.savebutton.key, onPressed: _save),
              const SizedBox(height: 16),
              Deletebtn(key: KBtn.deletebutton.key, onPressed: _delete),
              const SizedBox(height: 16),
              Cancelbtn(
                key: KBtn.cancelbutton.key,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
