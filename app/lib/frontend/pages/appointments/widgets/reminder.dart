import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';

class ReminderBanner extends StatelessWidget {
  final List<Appointment> reminderAppointments;

  const ReminderBanner({required this.reminderAppointments, super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final upcoming =
        reminderAppointments.where((a) => a.datetime.isAfter(now)).toList()
          ..sort((a, b) => a.datetime.compareTo(b.datetime));

    if (upcoming.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.colors.mainColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "No upcoming appointments.",
          style: TextStyle(
            color: context.colors.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final next = upcoming.first;
    final daysUntil = next.datetime.difference(now).inDays;

    String header;
    if (daysUntil == 0) {
      header = "Reminder: Next Appointment is today!";
    } else if (daysUntil == 1) {
      header = "Reminder: Next Appointment is tomorrow!";
    } else {
      header = "Reminder: Next Appointment is in $daysUntil days!";
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.colors.mainColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            header,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.colors.textWhite,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),

          // White box with equal gaps left/right
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.colors.whiteBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.colors.mainColoredBox,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.medical_services,
                          color: context.colors.mainColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            next.description,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            next.name,
                            style: TextStyle(
                              color: context.colors.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: context.colors.mainColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            next.dateString,
                            style: TextStyle(
                              color: context.colors.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: context.colors.mainColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            next.timeString,
                            style: TextStyle(
                              color: context.colors.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
