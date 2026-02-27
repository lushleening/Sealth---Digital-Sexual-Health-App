import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/helper/safe_nav.dart';
import 'package:sddp_dsh/objects/appointment.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/pages/appointments/subpages/edit_events/edit_events.dart';

class AppointmentCard extends ConsumerWidget {
  final Appointment appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.whiteBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: c.boxShadowGray,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Teal calendar icon box
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: c.mainColoredBox,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.calendar_today, color: c.mainColor, size: 20),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.description,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  appointment.name,
                  style: TextStyle(color: c.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 13,
                      color: c.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      appointment.dateString,
                      style: TextStyle(color: c.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 13, color: c.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      appointment.timeString,
                      style: TextStyle(color: c.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Edit icon
          IconButton(
            icon: Icon(Icons.edit_outlined, color: c.mainColor, size: 18),
            onPressed: () {
              navPush(
                context,
                ref,
                EditEvents(appointment: appointment), // used navPush() instead
              );
            },
          ),
        ],
      ),
    );
  }
}
