import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/add_events/widgets/events.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/add_events/widgets/add_btn.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/add_events/widgets/cancel_btn.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';

class AddEventPage extends ConsumerStatefulWidget {
  final String? preselectedClinicId;
  const AddEventPage({super.key, this.preselectedClinicId});

  @override
  ConsumerState<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends ConsumerState<AddEventPage> {
  bool isSubmitting = false;

  // holds reference to EventsPage's submit function
  VoidCallback? _submitEvent;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.grayBackground,
      appBar: AppBar(
        title: const Text("Add New Appointment"),
        backgroundColor: c.mainColor,
        foregroundColor: c.textWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            EventsPage(
              preselectedClinicId: widget.preselectedClinicId,
              // NEW: capture submit fn from EventsPage
              onSubmitReady: (fn) => _submitEvent = fn,
              onChanged: ({
                required String clinicId,
                required String serviceId,
                required DateTime dateTime,
                String? notes,
              }) async {
                setState(() => isSubmitting = true);

                final userId = ref.read(supabaseAuthProvider).currentUser?.id;
                print('Current user ID: $userId'); // add this line here

                if (userId == null) {
                  showSnackbarMessage('You are not logged in');
                  setState(() => isSubmitting = false);
                  return;
                }

                final durationMinutes = await getServiceDuration(serviceId);

                final result = await ref
                    .read(createAppointmentProvider)
                    .createAppointment(
                      userId: userId,
                      clinicId: clinicId,
                      serviceId: serviceId,
                      startTime: dateTime,
                      endTime: dateTime.add(Duration(minutes: durationMinutes)),
                      notes: notes,
                    );

                setState(() => isSubmitting = false);

                result.when(
                  success: (_) {
                    ref.invalidate(userAppointmentsProvider);
                    showSnackbarMessage('Appointment scheduled successfully!');
                    Navigator.pop(context);
                  },
                  failure: (err) {
                    showSnackbarMessage('Failed to schedule: $err');
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            
            AddButton(
              onPressed: () => _submitEvent?.call(),
            ),

            const SizedBox(height: 16),

            
            Cancelbtn(
              onPressed: () => Navigator.pop(context),
            ),

            const SizedBox(height: 24),
            if (isSubmitting) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<int> getServiceDuration(String serviceId) async {
    try {
      final service = await ref.read(serviceByIdProvider(serviceId).future);
      return service['duration_minutes'] as int? ?? 30;
    } catch (_) {
      return 30;
    }
  }
}