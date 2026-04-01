import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/frontend/pages/appointments/widgets/appointment_card.dart';
import 'package:sddp_dsh/frontend/pages/appointments/widgets/reminder.dart';
import 'package:sddp_dsh/frontend/pages/appointments/widgets/new_event.dart';
import 'package:sddp_dsh/frontend/pages/appointments/widgets/nearby_services_btn.dart';
import 'package:sddp_dsh/frontend/pages/appointments/widgets/calendar.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/frontend/pages/appointments/widgets/dropdownbtn.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

class AppointmentsPage extends ConsumerStatefulWidget {
  const AppointmentsPage({super.key});

  @override
  ConsumerState<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends ConsumerState<AppointmentsPage> {
  String selectedFilter = "Upcoming";

  List<Appointment> _filterAppointments(List<Appointment> appointments) {
    final now = DateTime.now();
    if (selectedFilter == "Today") {
      return appointments
          .where(
            (a) =>
                a.datetime.year == now.year &&
                a.datetime.month == now.month &&
                a.datetime.day == now.day,
          )
          .toList();
    }
    if (selectedFilter == "All") {
      return appointments;
    }
    return appointments.where((a) => a.datetime.isAfter(now)).toList();
  }

  String get _emptyMessage {
    if (selectedFilter == "Today")
      return "No appointments scheduled for today.";
    if (selectedFilter == "All") return "You have no appointments.";
    return "No upcoming appointments.";
  }

  void _showExpandedAppointments(
    BuildContext context,
    List<Appointment> filtered,
  ) {
    final c = context.colors;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.whiteBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "All Appointments",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppointmentCard(appointment: filtered[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final appointmentsAsync = ref.watch(userAppointmentsProvider);

    return Scaffold(
      backgroundColor: c.whiteBackground,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsetsGeometry.directional(start: 16, end: 16, top: 8),
          child: Text("Appointments"),
        ),
        backgroundColor: c.whiteBackground,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: appointmentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading appointments: $e')),
        data: (allAppointments) {
          final filtered = _filterAppointments(allAppointments);
          final preview = filtered.take(2).toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ReminderBanner(
                      key: KBtn.reminderBanner.key,
                      reminderAppointments: allAppointments,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      color: c.mainColoredBox,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: CalendarPage(calendarView: allAppointments),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppointmentsFilterBar(
                      key: KBtn.filterDropdown.key,
                      selectedFilter: selectedFilter,
                      onChanged: (value) =>
                          setState(() => selectedFilter = value!),
                    ),
                  ),

                  const SizedBox(height: 16),

                  preview.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: c.mainColoredBox,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _emptyMessage,
                            style: TextStyle(
                              color: c.textSecondary,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : Column(
                          children: preview
                              .map(
                                (appt) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: AppointmentCard(
                                    key: Key('appointment_${appt.id}'),
                                    appointment: appt,
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () =>
                          _showExpandedAppointments(context, filtered),
                      icon: const Icon(Icons.open_in_full),
                      label: const Text("See All"),
                      style: TextButton.styleFrom(foregroundColor: c.mainColor),
                    ),
                  ),

                  const SizedBox(height: 16),
                  AddEventButton(key: KBtn.addEvent.key),
                  const SizedBox(height: 16),
                  NearbyServicesButton(key: KBtn.nearbyServices.key),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
