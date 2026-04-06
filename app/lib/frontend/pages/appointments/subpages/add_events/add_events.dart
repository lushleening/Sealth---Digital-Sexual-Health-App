import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/user/app_user/app_user.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/add_events/widgets/events.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/add_events/widgets/add_btn.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/add_events/widgets/cancel_btn.dart';
import 'package:sddp_dsh/backend/snackbar/snackbar_message.dart';

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
              // capture submit fn from EventsPage
              onSubmitReady: (fn) => _submitEvent = fn,
              onChanged:
                  ({
                    required String clinicId,
                    required String serviceId,
                    required DateTime dateTime,
                    String? notes,
                  }) async {
                    setState(() => isSubmitting = true);

                    final userId =
                        (await ref.read(appUserProvider.future)).remoteId ??
                        'guest';
                    appointmentLogger.info('Current user ID: $userId');

                    final durationMinutes = await getServiceDuration(serviceId);

                    final result = await ref
                        .read(createAppointmentProvider)
                        .createAppointment(
                          userId: userId,
                          clinicId: clinicId,
                          serviceId: serviceId,
                          startTime: dateTime,
                          endTime: dateTime.add(
                            Duration(minutes: durationMinutes),
                          ),
                          notes: notes,
                        );

                    setState(() => isSubmitting = false);

                    result.when(
                      success: (_) {
                        ref.invalidate(userAppointmentsProvider);
                        showSnackbarMessage(
                          'Appointment scheduled successfully!',
                        );
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
              key: KBtn.eventaddbutton.key,
              onPressed: () => _submitEvent?.call(),
            ),

            const SizedBox(height: 16),

            Cancelbtn(
              key: KBtn.cancelbutton.key,
              onPressed: () => Navigator.pop(context),
            ),

            const SizedBox(height: 24),
            if (isSubmitting) const LoadingCircleMainColor(),
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
