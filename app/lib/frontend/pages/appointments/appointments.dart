import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
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
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class AppointmentsPage extends ConsumerStatefulWidget {
  const AppointmentsPage({super.key});

  @override
  ConsumerState<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends ConsumerState<AppointmentsPage> {
  String selectedFilter = "Upcoming";

  bool _isConnected = true;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _setupConnectivityListener();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _isConnected = !connectivityResult.contains(ConnectivityResult.none);
      });
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      if (mounted) {
        setState(() {
          _isConnected = !result.contains(ConnectivityResult.none);
        });
      }
    });
  }

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
    if (selectedFilter == "All") return appointments;
    return appointments.where((a) => a.datetime.isAfter(now)).toList();
  }

  String get _emptyMessage {
    if (selectedFilter == "Today") return "No appointments scheduled for today.";
    if (selectedFilter == "All") return "You have no appointments.";
    return "No upcoming appointments.";
  }

  void _showExpandedAppointments(BuildContext context) {
    final c = context.colors;
    final rootContext = context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.whiteBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _ExpandedAppointmentsSheet(
        filter: selectedFilter,
        rootContext: rootContext,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final appointmentsAsync = ref.watch(userAppointmentsProvider);

    // show offline message instead of appointments when offline
    if (!_isConnected) {
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                size: 64,
                color: c.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No Internet Connection',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your connection to view appointments',
                style: TextStyle(
                  fontSize: 14,
                  color: c.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  await _checkConnectivity();
                  if (_isConnected && mounted) {
                    ref.invalidate(userAppointmentsProvider);
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.mainColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

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
        loading: () => const Center(child: LoadingCircleMainColor()),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _showExpandedAppointments(context),
                        icon: const Icon(Icons.open_in_full),
                        label: const Text("See All"),
                        style: TextButton.styleFrom(
                          foregroundColor: c.mainColor,
                        ),
                      ),
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

// Reactive sheet — watches userAppointmentsProvider directly so it rebuilds
// after edits/deletes.
// Takes rootContext so AppointmentCard uses the correctnavigator for go_router pushes
class _ExpandedAppointmentsSheet extends ConsumerWidget {
  final String filter;
  final BuildContext rootContext;

  const _ExpandedAppointmentsSheet({
    required this.filter,
    required this.rootContext,
  });

  List<Appointment> _filterAppointments(List<Appointment> appointments) {
    final now = DateTime.now();
    if (filter == "Today") {
      return appointments
          .where(
            (a) =>
                a.datetime.year == now.year &&
                a.datetime.month == now.month &&
                a.datetime.day == now.day,
          )
          .toList();
    }
    if (filter == "All") return appointments;
    return appointments.where((a) => a.datetime.isAfter(now)).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);

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
              child: appointmentsAsync.when(
                loading: () => const Center(child: LoadingCircleMainColor()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (allAppointments) {
                  final filtered = _filterAppointments(allAppointments);
                  if (filtered.isEmpty) {
                    return const Center(child: Text('No appointments found'));
                  }
                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppointmentCard(
                        key: Key('expanded_${filtered[index].id}'),
                        appointment: filtered[index],
                        // Pass root context so go_router push works
                        // regardless of navigation history
                        navigationContext: rootContext,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}