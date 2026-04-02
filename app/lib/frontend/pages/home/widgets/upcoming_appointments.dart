import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';

// Upcoming set appointments
class UpcomingAppointments extends StatelessWidget {
  final Appointment appointment;

  const UpcomingAppointments({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("Upcoming appointments generated.");
    final date = appointment.dateString.split(' ');

    return Container(
      padding: EdgeInsetsGeometry.all(baseLength),
      width: double.infinity,
      color: context.colors.grayBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Text(
            'Upcoming appointments',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Consumer(
            builder: (context, ref, _) {
              return GestureDetector(
                onTap: () => context.go('/appointments'),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colors.whiteBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(
                      left: baseLength,
                      right: baseLength,
                      top: baseLength / 2,
                      bottom: baseLength / 2,
                    ),

                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.name,
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      color: context.colors.textPrimary,
                                    ),
                              ),
                              Text(
                                appointment.description,
                                style: TextStyle(
                                  color: context.colors.textSecondary,
                                ),
                              ),
                              Text(
                                appointment.timeString,
                                style: TextStyle(
                                  color: context.colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          children: [
                            Text(
                              date[0],
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(date[1]),
                            Text(
                              date[2],
                              style: TextStyle(
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 12),
          Consumer(
            builder: (context, ref, _) {
              return Center(
                child: ElevatedButton(
                  key: KBtn.navPendingAppointment.key,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: context.colors.textWhite,
                    backgroundColor: context.colors.mainColor,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsetsGeometry.symmetric(
                      horizontal: 30,
                      vertical: 6,
                    ),
                  ),
                  onPressed: () => context.go('/appointments'),
                  child: const Text('See More'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
