import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/edit_events/widgets/edit_event_card.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/edit_events/widgets/save_but.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/edit_events/widgets/del_but.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/edit_events/widgets/cancel_but.dart';

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
      final client = ref.read(supabaseProvider);
      final durationMinutes = await _getServiceDuration(_serviceId!);
      final startTime = _selectedDateTime!;
      final endTime = startTime.add(Duration(minutes: durationMinutes));

      print('Updating appointment id: ${widget.appointment.id}');
      print('clinic_id: $_clinicId');
      print('services_id: $_serviceId');
      print('start_time: ${_selectedDateTime!.toIso8601String()}');
      print('end_time: ${_selectedDateTime!.add(Duration(minutes: durationMinutes)).toIso8601String()}');

      await client.from('appointments').update({
        'clinic_id': _clinicId,
        'services_id': _serviceId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'notes': _notes,
      }).eq('id', widget.appointment.id);

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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Appointment'),
        content: const Text('Are you sure you want to delete this appointment?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final client = ref.read(supabaseProvider);
      await client
          .from('appointments')
          .delete()
          .eq('id', widget.appointment.id);
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
        title: const Text("Edit Event"),
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
              onChanged: ({
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
              const CircularProgressIndicator()
            else ...[
              SaveButton(key: KBtn.savebutton.key, onPressed: _save),
              const SizedBox(height: 16),
              Deletebtn(key: KBtn.deletebutton.key, onPressed: _delete),
              const SizedBox(height: 16),
              Cancelbtn(
                  key: KBtn.cancelbutton.key,
                  onPressed: () => Navigator.pop(context)),
            ],
          ],
        ),
      ),
    );
  }
}