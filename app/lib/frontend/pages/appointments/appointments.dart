import 'package:flutter/material.dart';
import 'package:sddp_dsh/frontend/pages/appointments/widgets/appointment_card.dart';
import 'package:sddp_dsh/frontend/pages/appointments/widgets/reminder.dart';
import 'package:sddp_dsh/frontend/pages/appointments/widgets/new_event.dart';
import 'package:sddp_dsh/frontend/pages/appointments/widgets/nearby_services_btn.dart';
import 'package:sddp_dsh/frontend/pages/appointments/widgets/calendar.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/frontend/pages/appointments/widgets/dropdownbtn.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

final appointments = [
  Appointment(
    name: 'Downtown Health Center',
    description: 'STI Testing',
    datetime: DateTime(2026, 11, 9, 10, 0),
    linkToSubpage: const SafeContainer(child: Text("STI Testing")),
  ),
  Appointment(
    name: 'Westside Health Center',
    description: 'Contraception Consultation',
    datetime: DateTime(2026, 11, 20, 12, 0),
    linkToSubpage: const SafeContainer(child: Text("Consultation")),
  ),
  Appointment(
    name: 'Eastside Clinic',
    description: 'General Checkup',
    datetime: DateTime(2026, 11, 25, 9, 30),
    linkToSubpage: const SafeContainer(child: Text("Checkup")),
  ),
  Appointment(
    name: 'North Medical Center',
    description: 'Vaccination',
    datetime: DateTime(2026, 12, 2, 14, 0),
    linkToSubpage: const SafeContainer(child: Text("Vaccination")),
  ),
  Appointment(
    name: 'Southside Hospital',
    description: 'Blood Test',
    datetime: DateTime(2026, 12, 5, 11, 0),
    linkToSubpage: const SafeContainer(child: Text("Blood Test")),
  ),
];

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  String selectedFilter = "Upcoming";

  List<Appointment> get filteredAppointments {
    final now = DateTime.now();
    if (selectedFilter == "Today") {
      return appointments
          .where(
            (appt) =>
                appt.datetime.year == now.year &&
                appt.datetime.month == now.month &&
                appt.datetime.day == now.day,
          )
          .toList();
    } else {
      return appointments.where((appt) => appt.datetime.isAfter(now)).toList();
    }
  }

  void _showExpandedAppointments(BuildContext context) {
    final c = context.colors;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.whiteBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
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
                    itemCount: filteredAppointments.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppointmentCard(
                          appointment: filteredAppointments[index],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    // Show only first 2 appointments in main page
    final previewAppointments = filteredAppointments.take(2).toList();

    return Scaffold(
      backgroundColor: c.whiteBackground,
      appBar: AppBar(
        title: const Text("Appointments"),
        backgroundColor: c.whiteBackground,
        foregroundColor: c.textPrimary,
        elevation: 0,               
        scrolledUnderElevation: 0,   // prevents tint when scrolling
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ReminderBanner(
                key: KBtn.reminderBanner.key,
                reminderAppointments: appointments,
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  color: c.mainColoredBox,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: CalendarPage(calendarView: appointments),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppointmentsFilterBar(
                  key: KBtn.filterDropdown.key,
                  selectedFilter: selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Inline preview cards
              Column(
                children: previewAppointments.isEmpty
                    ? [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: c.mainColoredBox,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            selectedFilter == "Today"
                                ? "No appointments scheduled for today."
                                : "No upcoming appointments.",
                            style: TextStyle(
                              color: c.textSecondary,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ]
                    : previewAppointments.map((appt) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AppointmentCard(
                            key: Key(
                              'appointment_${appt.name}_${appt.datetime}',
                            ),
                            appointment: appt,
                          ),
                        );
                      }).toList(),
              ),

              const SizedBox(height: 8),

              // Expand button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _showExpandedAppointments(context),
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
      ),
    );
  }
}
