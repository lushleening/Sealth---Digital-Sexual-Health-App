import 'package:flutter/material.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/objects/appointment.dart';
import 'package:sddp_dsh/common_widgets/safe_container.dart';
import 'package:sddp_dsh/pages/appointments/subpages/nearby_services/widgets/services_card.dart';
import 'package:sddp_dsh/testing/key_enum.dart';

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
];

class NearbyServicesPage extends StatefulWidget {
  const NearbyServicesPage({super.key});

  @override
  State<NearbyServicesPage> createState() => _NearbyServicesPageState();
}

class _NearbyServicesPageState extends State<NearbyServicesPage> {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.grayBackground,
      appBar: AppBar(
        title: const Text("Nearby Services"),
        backgroundColor: c.mainColor,
        foregroundColor: c.textWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // NEW: Nearby services card list
            NearbyServicesBody(
              key: KBtn.scheduleAppointment.key,
              services: dummyServices,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
